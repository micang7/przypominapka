# Backend Technical Documentation

## Overview

The Przypominapka backend is a RESTful API built with Node.js, Express, and TypeScript. It provides authentication, task management, and real-time synchronization capabilities for the mobile application. The API is secured with industry-standard security practices and designed to handle offline-first synchronization scenarios.

- **Runtime**: Node.js (v20+)
- **Framework**: Express.js
- **Language**: TypeScript
- **Database**: PostgreSQL 16
- **ORM**: Drizzle ORM
- **Authentication**: JWT (Access + Refresh tokens)
- **Password Hashing**: Argon2

## API Documentation

### Interactive Documentation

- **Swagger UI**: `/api/v1/docs/ui` - Interactive API explorer with ability to test endpoints
- **OpenAPI Schema**: `/api/v1/docs/openapi.json` - Machine-readable API specification (OpenAPI 3.0 format)
- **Privacy Policy**: `/api/v1/docs/privacy-policy` - User data handling and compliance information

### Health Check Endpoints

- **Liveness**: `GET /health/live` - Returns `200 OK` if the service is running
- **Readiness**: `GET /health/ready` - Returns `200 UP` and database connection status; returns `503 DEGRADED` if database is unavailable

## Security Architecture

### Helmet Security Headers

The application uses [Helmet.js](https://helmetjs.github.io/) middleware to set secure HTTP headers:

- Content Security Policy (CSP)
- X-Frame-Options (prevents clickjacking)
- X-Content-Type-Options (prevents MIME-type sniffing)
- Strict-Transport-Security (HSTS)
- X-XSS-Protection (legacy XSS protection)

```typescript
app.use(helmet());
```

### CORS Configuration

Cross-Origin Resource Sharing is configured to allow:

- Requests only from whitelisted origins (environment variable: `ALLOWED_ORIGINS`)
- Credentials (cookies, authorization headers)

```typescript
app.use(cors({ origin: env.ALLOWED_ORIGINS, credentials: true }));
```

### Rate Limiting

Production environment enforces rate limiting on critical endpoints:

| Endpoint                 | Window     | Limit        | Purpose                        |
| ------------------------ | ---------- | ------------ | ------------------------------ |
| All `/api/v1/` endpoints | 15 minutes | 100 requests | General API protection         |
| `/api/v1/auth/login`     | 15 minutes | 5 requests   | Brute force protection         |
| `/api/v1/auth/register`  | 15 minutes | 5 requests   | Account enumeration protection |

**Implementation**: Uses `express-rate-limit` with `TooManyRequestsError` (HTTP 429)

### Password Security

#### Strong Password Validation (Client-side + Server-side)

Passwords must meet the following criteria:

- **Minimum length**: 8 characters
- **Uppercase letter**: At least one (regex: `/[A-Z]/`)
- **Numeric digit**: At least one (regex: `/[0-9]/`)
- **Special character**: At least one (regex: `/[^A-Za-z0-9]/`)
- **Confirmation match**: Both password fields must match

The validation is enforced at the DTO level during registration and password changes:

```typescript
const AuthRegisterDto = z
  .object({
    password: z.string().min(1).max(255),
    confirmPassword: z
      .string()
      .min(8)
      .regex(/[A-Z]/, "password_uppercase")
      .regex(/[0-9]/, "password_number")
      .regex(/[^A-Za-z0-9]/, "password_special")
      .max(255),
  })
  .refine((data) => data.password === data.confirmPassword);
```

#### Password Hashing with Argon2

All passwords are hashed using [Argon2](https://argon2.online/), a memory-hard password hashing function resistant to GPU/ASIC attacks:

```typescript
const passwordHash = await hash(data.password);
const isPasswordValid = await verify(user.passwordHash, data.password);
```

### JWT Authentication

#### Token Strategy

The system uses a two-token approach:

| Token         | Type        | Expiration                | Purpose                    | Storage        |
| ------------- | ----------- | ------------------------- | -------------------------- | -------------- |
| Access Token  | Short-lived | 15 minutes (configurable) | API request authentication | Memory/Headers |
| Refresh Token | Long-lived  | 1 day (configurable)      | Obtain new access token    | Secure storage |

**Environment Variables**:

- `JWT_SECRET`: Secret key for signing access tokens
- `JWT_REFRESH_SECRET`: Separate secret for refresh tokens
- `JWT_EXPIRES_IN`: Access token expiration (default: "15m")
- `JWT_REFRESH_EXPIRES_IN`: Refresh token expiration (default: "1d")

#### Token Generation

Generated tokens include:

- `userId`: Subject identifier
- `jti` (JWT ID): Unique identifier for the specific token using UUID v4
- Standard JWT claims: `iat`, `exp`

```typescript
const accessToken = jwt.sign({ userId, jti: randomUUID() }, env.JWT_SECRET, {
  expiresIn: env.JWT_EXPIRES_IN,
});
```

#### Refresh Token Security

Refresh tokens are **hashed using Argon2** before storage in the database. This prevents token exposure if the database is compromised:

```typescript
const tokenHash = await hash(refreshToken);
await db.insert(sessions).values({ userId, tokenHash, deviceId, fcmToken });
```

#### User Existence Validation During Token Authentication

When validating access tokens, the middleware:

1. Decodes the JWT
2. **Queries the database to verify the user still exists**
3. Returns `401 Unauthorized` if user is not found

This ensures that:

- Deleted users cannot use their cached access tokens
- Account deletion takes immediate effect
- No stale references exist

```typescript
// jwtAuth.ts
const user = await db.query.users.findFirst({ where: eq(users.id, userId) });
if (!user) {
  throw new UnauthorizedError("User does not exist");
}
```

#### Invalid Refresh Token Detection & Session Termination

When a refresh token cannot be matched to any stored session:

1. The system detects an invalid/misused refresh token
2. **All sessions for that user are immediately terminated** (security measure against token theft)
3. User is logged out of all devices
4. Exception: The current session (derived from the refresh token) is preserved as per UX best practices

```typescript
// auth.service.ts - refresh() method
if (!activeSession) {
  appLogger.warn({ userId }, "Refresh token blocked (no matching session)");
  // Terminate ALL sessions for this user due to suspected token compromise
  await db.delete(sessions).where(eq(sessions.userId, userId));
  throw new UnauthorizedError("Invalid or expired refresh token");
}
```

**Why this matters**:

- Detects stolen refresh tokens early (attacker would use a token that doesn't match any session)
- Prevents persistent unauthorized access
- Triggers session termination on the client side, forcing re-authentication
- Improves security without requiring password re-entry (UX-friendly)

#### Endpoint Authentication

Routes requiring authentication use JWT Bearer tokens in the Authorization header:

```
Authorization: Bearer <access_token>
```

The middleware automatically applies JWT validation based on route metadata marked with `bearerAuth` security requirement.

### Per-Device Session Management

Each login session is tied to a specific device (`deviceId`). The system maintains:

- Session creation timestamp
- FCM token for push notifications
- Token hash for verification

This enables:

- Multi-device support (different tokens per device)
- Device-specific logout
- Targeted push notifications for synchronization

## Data Model

### Schema Design

![Backend Database Schema](../assets/erd-remote.png)

#### Users Table

```typescript
users {
  id: serial (PRIMARY KEY)
  login: varchar(50) NOT NULL UNIQUE
  passwordHash: varchar(255) NOT NULL
  createdAt: timestamp NOT NULL DEFAULT now()
  updatedAt: timestamp NOT NULL DEFAULT now()
}
```

#### Sessions Table

```typescript
sessions {
  id: serial (PRIMARY KEY)
  userId: integer NOT NULL REFERENCES users(id) ON DELETE CASCADE
  tokenHash: varchar(255) NOT NULL UNIQUE
  deviceId: text NOT NULL
  fcmToken: text (nullable)
  createdAt: timestamp NOT NULL DEFAULT now()
  updatedAt: timestamp NOT NULL DEFAULT now()
}
```

#### Tasks Table

```typescript
tasks {
  id: uuid (PRIMARY KEY)
  userId: integer NOT NULL REFERENCES users(id) ON DELETE CASCADE
  title: text NOT NULL
  description: text (nullable)
  type: enum('one_time', 'recurrent') NOT NULL
  completed: boolean NOT NULL DEFAULT false
  timeTriggerAt: timestamp (nullable)
  geoTriggerLatitude: double precision (nullable)
  geoTriggerLongitude: double precision (nullable)
  geoTriggerRadius: integer (nullable)
  version: integer NOT NULL DEFAULT 1         // Optimistic Concurrency Control
  createdAt: timestamp NOT NULL DEFAULT now()
  updatedAt: timestamp NOT NULL DEFAULT now()
  deletedAt: timestamp (nullable)              // Soft delete flag
}
```

### Check Constraints

The database enforces geographic validity:

| Constraint       | Rule                         | Purpose                           |
| ---------------- | ---------------------------- | --------------------------------- |
| `latitudeCheck`  | `-90.0 ≤ latitude ≤ 90.0`    | Valid latitude range              |
| `longitudeCheck` | `-180.0 ≤ longitude ≤ 180.0` | Valid longitude range             |
| `radiusCheck`    | `0 < radius ≤ 50000`         | Radius must be positive, max 50km |

These constraints are enforced **in addition to** DTO validation, ensuring data integrity even if DTOs are bypassed.

### Indexes

```typescript
// Improve query performance for user-specific data
index("user_idx").on(tasks.userId);

// Optimize soft-delete queries
index("deleted_at_idx").on(tasks.deletedAt);
```

### Data Deletion (Cascading)

Foreign key: `userId` REFERENCES `users.id` ON DELETE CASCADE

When a user is deleted:

- All associated sessions are deleted automatically
- All associated tasks are deleted automatically
- No orphaned records remain

This ensures full compliance with data deletion requirements (GDPR, Google Play Store policies).

### Local Database Schema

![Local Database Schema](../assets/erd-local.png)

## Advanced Synchronization

### Overview

The system implements a sophisticated two-way synchronization protocol optimized for:

- **Offline-first applications**: Changes made without network connectivity are queued and synced
- **Conflict resolution**: Version-based Optimistic Concurrency Control (OCC)
- **Bandwidth efficiency**: Only changed data is transmitted (differential sync)
- **Multi-device support**: Automatic synchronization between devices

### Synchronization Payload

#### Client Request (Push Changes to Server)

```typescript
{
  last_sync_at: "2024-06-17T12:00:00Z",      // Last successful sync timestamp
  deviceId: "device-uuid",                    // Identifies the requesting device
  changes: {
    created: [                                // New tasks created on client
      {
        id: "task-uuid",
        title: "Buy groceries",
        description: null,
        type: "one_time",
        timeTriggerAt: null,
        geoTriggerLatitude: null,
        geoTriggerLongitude: null,
        geoTriggerRadius: null,
        version: 1
      }
    ],
    updated: [                                // Existing tasks modified on client
      {
        id: "task-uuid-2",
        title: "Updated title",
        version: 2,
        ...otherFields
      }
    ],
    deleted: [                                // Tasks marked for deletion on client
      { id: "task-uuid-3" }
    ]
  }
}
```

#### Server Response (Pull Changes from Server)

```typescript
{
  sync_at: "2024-06-17T12:00:05Z",            // Server sync timestamp
  changes: {
    created: [                                // Tasks created on server/other devices
      {
        id: "task-uuid-4",
        title: "Server-created task",
        version: 1,
        createdAt: "2024-06-17T11:59:00Z",
        updatedAt: "2024-06-17T11:59:00Z",
        ...otherFields
      }
    ],
    updated: [                                // Tasks updated on server/other devices
      {
        id: "task-uuid-2",
        title: "Updated by other device",
        version: 3,
        updatedAt: "2024-06-17T12:00:02Z",
        ...otherFields
      }
    ],
    deleted: [                                // Tasks deleted on server/other devices
      { id: "task-uuid-5" }
    ]
  }
}
```

### Sync Processing Pipeline

#### Step 1: Client Changes Processing (Transactional)

All client changes are processed within a single database transaction:

**A. Created Tasks**

- Inserted as-is into the database with `version: 1`
- Conflict handling: `onConflictDoNothing()` - if task already exists, ignore (idempotency)

**B. Updated Tasks (OCC Conflict Resolution)**

- Version check: Compare client version with server version
- **Server Wins Strategy**: Only apply update if `clientVersion >= serverVersion`
- If outdated: Log warning, exclude from `processedIds`, allowing server to re-send newer version
- If valid: Increment version (`nextVersion = serverVersion + 1`)
- Uses `UPSERT` (INSERT ON CONFLICT DO UPDATE) for atomicity

Example:

```
Client sends: version 2
Server has: version 3
Action: REJECT (client is outdated, will receive v3 in response)

Client sends: version 3
Server has: version 2
Action: ACCEPT (client is current, update to v4)

Client sends: version 2
Server has: version 2
Action: ACCEPT (client is current, update to v3)
```

**C. Deleted Tasks**

- Soft delete: Set `deletedAt` timestamp and increment `version`
- Hard deletion is deferred (see retention policies)

#### Step 2: Server Changes Query

Query all tasks modified since `last_sync_at`:

- Exclude tasks that were processed in step 1 (already sent by client)
- Only return changed data, not full user dataset

```sql
SELECT * FROM tasks
WHERE userId = ?
  AND updatedAt > last_sync_at
  AND id NOT IN (processedIds)
```

**Bandwidth Efficiency**:

- Differential sync: Only changed tasks since last sync
- Excludes user metadata, session info, or other unrelated data
- Reduced payload size for slower networks

#### Step 3: Task Classification

Server categorizes returned tasks:

- **Created**: `createdAt > last_sync_at`
- **Updated**: `createdAt <= last_sync_at`
- **Deleted**: `deletedAt` is set and `deletedAt > last_sync_at`

#### Step 4: Multi-Device Push Notifications

After sync completes, the server sends FCM notifications to **other active devices** of the same user:

- Query all sessions except current (`deviceId`)
- Filter to only sessions with FCM tokens
- Send `SYNC_REQUEST` notification containing timestamp

This prompts other devices to initiate sync automatically.

```typescript
const activeOtherSessions = await db
  .select({ fcmToken: sessions.fcmToken })
  .from(sessions)
  .where(
    and(
      eq(sessions.userId, userId),
      not(eq(sessions.deviceId, data.deviceId)), // Exclude current device
      isNotNull(sessions.fcmToken),
    ),
  );
```

### Version Field Schema

| Field       | Type      | Purpose                  | Behavior                                          |
| ----------- | --------- | ------------------------ | ------------------------------------------------- |
| `version`   | integer   | Tracks task mutations    | Incremented on each change (create/update/delete) |
| `updatedAt` | timestamp | Tracks modification time | Updated automatically with every change           |
| `deletedAt` | timestamp | Soft delete marker       | Set when task is deleted (not removed from DB)    |

### Sync Timestamp Management

- **`last_sync_at`** (Client): Time of last successful sync; client includes in request
- **`sync_at`** (Server): Generated on server during sync response; used by next sync

Timeline:

```
Device A (t0=12:00): last_sync_at=11:50
  → Syncs at 12:00
  ← Receives sync_at=12:00:05
  → Next sync uses last_sync_at=12:00:05

Device B (12:01): Modifies task X
  → Task X.updatedAt=12:01:10

Device A (12:02): Syncs again
  → Sends last_sync_at=12:00:05
  ← Receives updated Task X (updatedAt > 12:00:05)
```

### Conflict Resolution Algorithm

**Optimistic Concurrency Control (OCC) with Server Wins**

```typescript
if (!existingTask || task.version >= existingTask.version) {
  // Apply client change: client version is current or ahead
  nextVersion = existingTask ? existingTask.version + 1 : 1;
  UPDATE task SET ... , version = nextVersion;
} else {
  // Reject client change: client version is outdated
  // Server will send newer version in response
  exclude from processedIds; // Ensures server re-sends updated task
}
```

**Advantages**:

- No blocking/locking required (optimistic)
- Deterministic conflict resolution (server always wins)
- Client learns about server state in same response
- Suitable for offline-first sync scenarios

### Limitations & Considerations

- **Last-Write-Wins**: Concurrent updates from multiple devices on the same task result in the latest write winning (no merge logic)
- **No Operational Transformation**: Complex concurrent edits cannot be merged; one is selected
- **Eventual Consistency**: Temporary divergence between devices during sync; consistency achieved after next sync

## Testing Strategy

### Unit Tests

**Location**: `server/src/**/*.unit.test.ts`

Isolated testing of individual components:

- Error handler logic
- DTO validation
- Utility functions

**Execution**: `npm run test:unit`

**Command**:

```bash
npx vitest run --include "**/*.unit.test.ts"
```

### Integration Tests

**Location**: `server/src/**/*.int.test.ts`

Full-stack testing with real database:

- API endpoints (controllers + services)
- Database transactions
- Error handling
- JWT authentication flow

**Includes Testing**:

- Authentication (registration, login, logout, refresh)
- Session management
- Task CRUD operations
- Synchronization protocol
- Password changes
- User deletion

**Execution**: `npm run test:int`

**Command**:

```bash
npm ci
npm run db:mg  # Apply migrations to test DB
npx vitest run --include "**/*.int.test.ts"
```

### Acceptance Tests

**Location**: `app/test/acceptance_test.dart` (Flutter)

User story validation combining frontend and backend:

- Real API server (Express)
- Real database (PostgreSQL)
- Flutter app UI interactions
- End-to-end workflows

**User Stories Covered**:

- User registration with validation
- User login
- Task creation, update, deletion
- Synchronization with conflict scenarios
- Multi-device sync
- Logout and session termination

**Execution**: `flutter test test/acceptance_test.dart`

### Test Database Setup

Tests use isolated PostgreSQL database:

- Database: `test`
- User: `test`
- Password: `test`
- Host: `localhost:5432`

Each test suite:

1. Runs migrations to create fresh schema
2. Executes tests in isolation
3. Cleans up after completion

## CI/CD Pipeline

### Overview

Automated testing and deployment ensure code quality and fast release cycles.

### Server CI Pipeline

**Trigger**: Every push to any branch except `main`/`develop`, or PR to `main`/`develop`

**Workflow**: `.github/workflows/server-ci.yaml`

```yaml
1. Checkout code
2. Setup Node.js (v20)
3. Install dependencies (npm ci)
4. Run linter (ESLint)
5. Build TypeScript (tsc)
6. Run unit tests (npm run test:unit)
7. [On PR only] Run integration tests (npm run test:int)
```

**Services**:

- PostgreSQL 16 (for integration tests on PR)
  - Health check ensures readiness
  - Exposed on port 5432

**Environment**:

- `DATABASE_URL`: postgres://test:test@localhost:5432/test
- `JWT_SECRET`: test
- `JWT_REFRESH_SECRET`: test
- `JWT_EXPIRES_IN`: 15m
- `JWT_REFRESH_EXPIRES_IN`: 1d

**Allowed Failures**: None - all checks must pass

### Acceptance Test Pipeline

**Trigger**: Every PR to `main` or `develop`

**Workflow**: `.github/workflows/acceptance-ci.yaml`

```yaml
1. Checkout code
2. Setup Node.js (v20)
3. Install backend dependencies
4. Run database migrations
5. Start backend server in background
6. Wait for server health check (/health/ready)
7. Setup Java (required for Flutter in CI)
8. Setup Flutter SDK (stable channel)
9. Install frontend dependencies (flutter pub get)
10. Run acceptance tests (flutter test)
```

**Parallel Services**:

- PostgreSQL 16 with test database
- Node.js backend API server (port 3000)

**Pass Criteria**: All acceptance tests pass (user stories validated)

### App CI Pipeline

**Trigger**: Every PR to `main` or `develop`

**Workflow**: `.github/workflows/app-ci.yaml`

Covers:

- Flutter linting (dart analyze)
- Format checking (dart format)
- Build test (flutter build)

### Server CD Pipeline (Deployment)

**Trigger**: Every push to `main` branch

**Workflow**: `.github/workflows/server-cd.yaml`

```yaml
1. Trigger Render Deploy Webhook
```

**Deployment Target**: [Render.com](https://render.com) \
**Production Base URL:** https://przypominapka.onrender.com

**Process**:

1. GitHub triggers webhook on Render
2. Render pulls latest code from `main`
3. Render runs build & start commands
4. New service is deployed and replaces previous version
5. Automatic SSL/TLS certificate management

**Environment on Render**:

- Runtime: Node.js
- Build command: `npm install && npm run build`
- Start command: `npm run start`
- Environment variables managed in Render dashboard

## Compliance & Data Rights

### User Data Deletion (Google Play Store Compliance)

**Requirement**: Users must be able to completely remove their data as per Google Play Store policies and GDPR.

**Implementation**: `DELETE /api/v1/users` endpoint

```typescript
async delete(userId: number): Promise<void> {
  appLogger.debug({ userId }, 'User account deletion initiated');

  await db.delete(users).where(eq(users.id, userId));

  appLogger.info({ userId }, 'User account deleted successfully');
}
```

**Cascading Deletes**:

- User deletion automatically deletes all associated sessions
- User deletion automatically deletes all associated tasks
- No orphaned records remain in database

**Audit Trail**:

- Deletion logged with timestamp and userId
- No soft-delete for users (hard delete ensures data removal)

**Recovery**: No recovery possible after user deletion

## Environment Configuration

### Required Environment Variables

```bash
# Database
DATABASE_URL=postgres://user:password@localhost:5432/database

# JWT Configuration
JWT_SECRET=your-secret-key-here-min-32-chars
JWT_REFRESH_SECRET=your-refresh-secret-key-min-32-chars
JWT_EXPIRES_IN=15m                    # Access token expiration
JWT_REFRESH_EXPIRES_IN=1d             # Refresh token expiration

# CORS
ALLOWED_ORIGINS=http://localhost:5173,http://localhost:5174

# Environment
NODE_ENV=development|production|test
PORT=3000
```

## Error Handling

### HTTP Status Codes

| Status | Meaning             | Example                     |
| ------ | ------------------- | --------------------------- |
| 200    | Success             | Task retrieved successfully |
| 400    | Bad Request         | Invalid DTO validation      |
| 401    | Unauthorized        | Invalid/missing JWT token   |
| 409    | Conflict            | Login already in use        |
| 429    | Too Many Requests   | Rate limit exceeded         |
| 500    | Server Error        | Unhandled exception         |
| 503    | Service Unavailable | Database connection failed  |

### Error Response Format

```typescript
{
  error: {
    code: "VALIDATION_ERROR" | "UNAUTHORIZED" | "CONFLICT" | ...,
    message: "Human-readable error message",
    details: [
      {
        path: "body.email",
        code: "password_uppercase",
        error: "Password must contain an uppercase letter"
      }
    ]
  }
}
```

## Logging

### Structured Logging with Pino

All events are logged with structured fields for observability:

```typescript
appLogger.debug({ userId, sessionId }, "Processing user session");
appLogger.info({ userId }, "Login completed");
appLogger.warn({ userId }, "Failed login attempt");
appLogger.error({ err }, "Unexpected error");
```

**Log Levels**:

- `debug`: Detailed diagnostic information
- `info`: General informational messages
- `warn`: Warning messages (suspicious activity)
- `error`: Error conditions

**Persisted Fields**:

- Timestamp (`time`)
- Log level (`level`)
- Message (`msg`)
- Context object (all passed fields)

## Database Migrations

### Running Migrations

```bash
# Development (using drizzle-kit)
npm run db:mg

# Production (without drizzle-kit by running script)
npm run migrate
```

### Creating New Migrations

```bash
npm run db:gn
```

Migrations are stored in `server/src/db/migrations/`.

## Performance Considerations

### Query Optimization

- Indexes on frequently filtered columns (`user_idx`, `deleted_at_idx`)
- Efficient JWT validation with database lookup (identifies stale tokens)
- Differential sync reduces bandwidth for large datasets

### Rate Limiting

Protects against:

- Brute force attacks on auth endpoints
- API abuse and DoS attacks
- Resource exhaustion

### Database Pooling

Connection pooling managed by Drizzle ORM:

- Reuses database connections
- Reduces latency
- Handles concurrent requests efficiently

## Security Best Practices Implemented

✅ **Password Security**

- Argon2 hashing (memory-hard, GPU-resistant)
- Strong password requirements (8+ chars, uppercase, number, special)
- Password change invalidates other sessions

✅ **JWT Token Security**

- Separate secrets for access and refresh tokens
- Refresh tokens are hashed before storage
- Short-lived access tokens (15 min default)
- Long-lived refresh tokens (1 day default)
- JTI (JWT ID) uniqueness per token

✅ **Session Management**

- Per-device session tracking
- Invalid refresh token triggers all-session logout
- User existence validation on every request
- Secure token delivery via Authorization header

✅ **Data Protection**

- Check constraints at database level (geo data validation)
- DTO validation at API boundary
- Cascading deletes prevent orphaned data
- User deletion irreversible (regulatory compliance)

✅ **API Security**

- Helmet security headers
- CORS whitelisting
- Rate limiting on auth endpoints
- Request validation and sanitization

✅ **Infrastructure**

- HTTPS enforced (HSTS header)
- Secure headers against common attacks (CSP, X-Frame-Options, etc.)
- Proxy trust configuration for reverse proxies

## Troubleshooting

### Common Issues

**"User does not exist" error during token validation**

- Token is valid but user was deleted
- Clear token cache on client and re-authenticate

**"Invalid or expired refresh token"**

- Refresh token was revoked (password change, logout all devices)
- User needs to login again

**Rate limit (429) error**

- Too many requests in short time window
- Implement exponential backoff on client
- Check for retry loops in integration tests
