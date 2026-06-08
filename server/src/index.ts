import { app } from './app.js';
import { env } from './config/env.js';
import { appLogger } from './config/logger.js';
import { checkDbConnWithRetry } from './db/client.js';

async function bootstrap() {
  try {
    await checkDbConnWithRetry();

    app.listen(env.PORT, () => {
      appLogger.info(`Server running on port ${env.PORT}`);
    });
  } catch (err) {
    appLogger.fatal({ err }, 'Database connection failed');
    process.exit(1);
  }
}
await bootstrap();
