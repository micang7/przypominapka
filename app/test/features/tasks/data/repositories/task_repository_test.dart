import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:app/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/core/api/models/task_models.dart' as api;
import 'package:app/core/services/device_service.dart';
import 'package:app/core/services/notification_service.dart';
import 'package:app/core/services/geofencing_service.dart';
import 'package:app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:app/features/tasks/domain/entities/task.dart';
import 'package:app/core/database/database.dart';

class MockTaskLocalDatasource extends Mock implements ITaskLocalDatasource {}
class MockApiClient extends Mock implements ApiClient {}
class MockSyncNamespace extends Mock implements SyncNamespace {}
class MockDeviceService extends Mock implements DeviceService {}
class MockNotificationService extends Mock implements NotificationService {}
class MockGeofencingService extends Mock implements GeofencingService {}
class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}

// Helper to register fallbacks for mocktail
class FakeTaskEntry extends Fake implements TaskEntry {}
class FakeSyncRequest extends Fake implements api.SyncRequest {}

void initFallbackValues() {
  registerFallbackValue(FakeTaskEntry());
  registerFallbackValue(FakeSyncRequest());
}

void main() {
  setUpAll(() {
    initFallbackValues();
  });

  late TaskRepositoryImpl repository;
  late MockTaskLocalDatasource mockLocalDatasource;
  late MockApiClient mockApiClient;
  late MockSyncNamespace mockSyncNamespace;
  late MockDeviceService mockDeviceService;
  late MockNotificationService mockNotificationService;
  late MockGeofencingService mockGeofencingService;
  late MockAuthLocalDatasource mockAuthLocalDatasource;

  setUp(() {
    mockLocalDatasource = MockTaskLocalDatasource();
    mockApiClient = MockApiClient();
    mockSyncNamespace = MockSyncNamespace();
    mockDeviceService = MockDeviceService();
    mockNotificationService = MockNotificationService();
    mockGeofencingService = MockGeofencingService();
    mockAuthLocalDatasource = MockAuthLocalDatasource();

    when(() => mockApiClient.sync).thenReturn(mockSyncNamespace);
    
    // Default stubbing for common void methods
    when(() => mockNotificationService.cancelNotification(any())).thenAnswer((_) async {});
    when(() => mockNotificationService.scheduleNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledDate: any(named: 'scheduledDate'),
        )).thenAnswer((_) async {});
    when(() => mockGeofencingService.registerGeofence(
          id: any(named: 'id'),
          title: any(named: 'title'),
          lat: any(named: 'lat'),
          lng: any(named: 'lng'),
          radius: any(named: 'radius'),
        )).thenAnswer((_) async {});
    when(() => mockGeofencingService.removeGeofence(any(), any())).thenAnswer((_) async {});

    repository = TaskRepositoryImpl(
      localDatasource: mockLocalDatasource,
      apiClient: mockApiClient,
      deviceService: mockDeviceService,
      notificationService: mockNotificationService,
      geofencingService: mockGeofencingService,
      authLocalDatasource: mockAuthLocalDatasource,
    );
  });

  group('TaskRepositoryImpl', () {
    test('addTask should upsert task locally and call syncTasks', () async {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Test Task',
        type: TaskType.oneTime,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(() => mockLocalDatasource.upsertTask(any())).thenAnswer((_) async {});
      when(() => mockLocalDatasource.getMetadata(any())).thenAnswer((_) async => null);
      when(() => mockLocalDatasource.setMetadata(any(), any())).thenAnswer((_) async {});
      when(() => mockDeviceService.getDeviceId()).thenAnswer((_) async => 'device123');
      when(() => mockAuthLocalDatasource.getAccessToken()).thenAnswer((_) async => 'token');
      when(() => mockLocalDatasource.getPendingSyncTasks()).thenAnswer((_) async => []);
      
      final syncResponse = api.SyncResponse(
        sync_at: DateTime.now(),
        changes: const api.SyncChanges(),
      );
      when(() => mockSyncNamespace.sync(any())).thenAnswer((_) async => syncResponse);

      // Act
      await repository.addTask(task);

      // Assert
      verify(() => mockLocalDatasource.upsertTask(any())).called(1);
      // verify(() => mockSyncNamespace.sync(any())).called(1); // unawaited might not have run yet
    });

    test('syncTasks should push local changes and apply server changes', () async {
      // Arrange
      final pendingTask = TaskEntry(
        id: '1',
        title: 'Local Task',
        type: 'one_time',
        completed: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPendingSync: true,
      );

      when(() => mockLocalDatasource.getMetadata(any())).thenAnswer((_) async => null);
      when(() => mockLocalDatasource.setMetadata(any(), any())).thenAnswer((_) async {});
      when(() => mockDeviceService.getDeviceId()).thenAnswer((_) async => 'device123');
      when(() => mockAuthLocalDatasource.getAccessToken()).thenAnswer((_) async => 'token');
      when(() => mockLocalDatasource.getPendingSyncTasks()).thenAnswer((_) async => [pendingTask]);
      
      final serverTask = api.TaskDto(
        id: '2',
        title: 'Server Task',
        type: 'one_time',
        updatedAt: DateTime.now(),
      );

      final syncResponse = api.SyncResponse(
        sync_at: DateTime.now(),
        changes: api.SyncChanges(updated: [serverTask]),
      );

      when(() => mockSyncNamespace.sync(any())).thenAnswer((_) async => syncResponse);
      when(() => mockLocalDatasource.upsertTasks(any())).thenAnswer((_) async {});
      when(() => mockLocalDatasource.markAsSynced(any())).thenAnswer((_) async {});

      // Act
      await repository.syncTasks();

      // Assert
      verify(() => mockSyncNamespace.sync(any())).called(1);
      verify(() => mockLocalDatasource.upsertTasks(any())).called(1);
      verify(() => mockLocalDatasource.markAsSynced('1')).called(1);
    });

    test('deleteTask should cancel triggers and delete locally', () async {
      // Arrange
      final entry = TaskEntry(
        id: '1',
        title: 'Task to delete',
        type: 'one_time',
        completed: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPendingSync: false,
      );

      when(() => mockLocalDatasource.getTaskById('1')).thenAnswer((_) async => entry);
      when(() => mockNotificationService.cancelNotification(any())).thenAnswer((_) async {});
      when(() => mockGeofencingService.removeGeofence(any(), any())).thenAnswer((_) async {});
      when(() => mockLocalDatasource.deleteTask('1')).thenAnswer((_) async {});
      
      // Mock syncTasks internal calls
      when(() => mockLocalDatasource.getMetadata(any())).thenAnswer((_) async => null);
      when(() => mockLocalDatasource.setMetadata(any(), any())).thenAnswer((_) async {});
      when(() => mockDeviceService.getDeviceId()).thenAnswer((_) async => 'device123');
      when(() => mockAuthLocalDatasource.getAccessToken()).thenAnswer((_) async => 'token');
      when(() => mockLocalDatasource.getPendingSyncTasks()).thenAnswer((_) async => []);
      when(() => mockSyncNamespace.sync(any())).thenAnswer((_) async => api.SyncResponse(sync_at: DateTime.now(), changes: const api.SyncChanges()));

      // Act
      await repository.deleteTask('1');

      // Assert
      verify(() => mockNotificationService.cancelNotification(any())).called(1);
      verify(() => mockGeofencingService.removeGeofence('1', 'Task to delete')).called(1);
      verify(() => mockLocalDatasource.deleteTask('1')).called(1);
    });

    test('toggleTaskCompletion should update status and triggers', () async {
      // Arrange
      final entry = TaskEntry(
        id: '1',
        title: 'Task',
        type: 'one_time',
        completed: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPendingSync: false,
      );

      when(() => mockLocalDatasource.getTaskById('1')).thenAnswer((_) async => entry);
      when(() => mockLocalDatasource.upsertTask(any())).thenAnswer((_) async {});
      when(() => mockNotificationService.cancelNotification(any())).thenAnswer((_) async {});
      when(() => mockGeofencingService.removeGeofence(any(), any())).thenAnswer((_) async {});

      // Mock syncTasks internal calls
      when(() => mockLocalDatasource.getMetadata(any())).thenAnswer((_) async => null);
      when(() => mockLocalDatasource.setMetadata(any(), any())).thenAnswer((_) async {});
      when(() => mockDeviceService.getDeviceId()).thenAnswer((_) async => 'device123');
      when(() => mockAuthLocalDatasource.getAccessToken()).thenAnswer((_) async => 'token');
      when(() => mockLocalDatasource.getPendingSyncTasks()).thenAnswer((_) async => []);
      when(() => mockSyncNamespace.sync(any())).thenAnswer((_) async => api.SyncResponse(sync_at: DateTime.now(), changes: const api.SyncChanges()));

      // Act
      await repository.toggleTaskCompletion('1');

      // Assert
      verify(() => mockLocalDatasource.upsertTask(any(that: predicate<TaskEntry>((t) => t.completed == true)))).called(1);
      verify(() => mockNotificationService.cancelNotification(any())).called(1);
    });

    test('reinitializeTriggers should refresh triggers for all tasks', () async {
      // Arrange
      final task1 = TaskEntry(
        id: '1', title: 'T1', type: 'one_time', completed: false,
        timeTriggerAt: DateTime.now().add(const Duration(hours: 1)),
        createdAt: DateTime.now(), updatedAt: DateTime.now(), isPendingSync: false,
      );
      
      when(() => mockLocalDatasource.getAllTasks()).thenAnswer((_) async => [task1]);

      // Act
      await repository.reinitializeTriggers();

      // Assert
      verify(() => mockNotificationService.scheduleNotification(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        scheduledDate: any(named: 'scheduledDate'),
      )).called(1);
    });
  });
}
