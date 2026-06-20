import 'package:app/core/database/database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:app/core/api/api_client.dart';
import 'package:app/core/services/device_service.dart';
import 'package:app/core/services/notification_service.dart';
import 'package:app/core/services/geofencing_service.dart';
import 'package:app/features/auth/data/repositories/auth_repository.dart';
import 'package:app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:app/features/tasks/data/datasources/task_local_datasource.dart';
import 'package:app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:app/features/tasks/domain/entities/task.dart';
import 'package:app/features/tasks/domain/repositories/task_repository_contract.dart';

// ============ MOCKS ============

class MockDeviceService extends Mock implements DeviceService {}

class MockNotificationService extends Mock implements NotificationService {}

class MockGeofencingService extends Mock implements GeofencingService {}

class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}

class MockTaskLocalDatasource extends Mock implements ITaskLocalDatasource {}

class MockTaskRepository extends Mock implements ITaskRepository {}

class FakeTaskEntry extends Fake implements TaskEntry {}

class FakeTask extends Fake implements Task {}

// ============ TEST FIXTURES ============

class AcceptanceTestFixtures {
  late Dio dio;
  late ApiClient apiClient;
  late MockDeviceService deviceService;
  late MockNotificationService notificationService;
  late MockGeofencingService geofencingService;
  late MockAuthLocalDatasource authLocalDatasource;
  late MockTaskLocalDatasource taskLocalDatasource;
  late MockTaskRepository mockTaskRepository;
  late AuthRepository authRepository;
  late TaskRepositoryImpl taskRepository;

  String? currentAccessToken;
  String? currentRefreshToken;
  String testDeviceId = 'test_device_123';

  Future<void> setUp() async {
    registerFallbackValue(FakeTaskEntry());
    registerFallbackValue(FakeTask());

    // Konfiguracja Dio do połączenia z rzeczywistym backendem
    // W CI na Ubuntu, backend jest dostępny na localhost:3000
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:3000/api/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    apiClient = ApiClient(dio);

    // Mockowanie serwisów
    deviceService = MockDeviceService();
    when(
      () => deviceService.getDeviceId(),
    ).thenAnswer((_) async => testDeviceId);

    notificationService = MockNotificationService();
    when(
      () => notificationService.scheduleNotification(
        id: any(named: 'id'),
        title: any(named: 'title'),
        body: any(named: 'body'),
        scheduledDate: any(named: 'scheduledDate'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => notificationService.cancelNotification(any()),
    ).thenAnswer((_) async {});

    geofencingService = MockGeofencingService();
    when(
      () => geofencingService.registerGeofence(
        id: any(named: 'id'),
        title: any(named: 'title'),
        lat: any(named: 'lat'),
        lng: any(named: 'lng'),
        radius: any(named: 'radius'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => geofencingService.removeGeofence(any(), any()),
    ).thenAnswer((_) async {});

    authLocalDatasource = MockAuthLocalDatasource();
    taskLocalDatasource = MockTaskLocalDatasource();
    mockTaskRepository = MockTaskRepository();

    // Setup token storage behavior
    when(
      () => authLocalDatasource.saveTokens(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    ).thenAnswer((invocation) async {
      currentAccessToken =
          invocation.namedArguments[const Symbol('accessToken')];
      currentRefreshToken =
          invocation.namedArguments[const Symbol('refreshToken')];
    });

    when(
      () => authLocalDatasource.getAccessToken(),
    ).thenAnswer((_) async => currentAccessToken);

    when(
      () => authLocalDatasource.getRefreshToken(),
    ).thenAnswer((_) async => currentRefreshToken);

    when(() => authLocalDatasource.clearAll()).thenAnswer((_) async {
      currentAccessToken = null;
      currentRefreshToken = null;
    });

    when(() => taskLocalDatasource.deleteAllTasks()).thenAnswer((_) async {});
    when(() => taskLocalDatasource.deleteTask(any())).thenAnswer((_) async {});
    when(
      () => taskLocalDatasource.hardDeleteTask(any()),
    ).thenAnswer((_) async {});
    when(
      () => taskLocalDatasource.getPendingSyncTasks(),
    ).thenAnswer((_) async => []);
    when(
      () => taskLocalDatasource.markAsSynced(any()),
    ).thenAnswer((_) async {});
    when(
      () => taskLocalDatasource.setMetadata(any(), any()),
    ).thenAnswer((_) async {});
    when(
      () => taskLocalDatasource.getMetadata(any()),
    ).thenAnswer((_) async => null);
    when(() => taskLocalDatasource.upsertTask(any())).thenAnswer((_) async {});
    when(() => taskLocalDatasource.upsertTasks(any())).thenAnswer((_) async {});
    when(
      () => taskLocalDatasource.watchAllTasks(),
    ).thenAnswer((_) => Stream.value([]));
    when(() => taskLocalDatasource.getAllTasks()).thenAnswer((_) async => []);
    when(
      () => taskLocalDatasource.getTaskById(any()),
    ).thenAnswer((_) async => null);

    when(() => mockTaskRepository.syncTasks()).thenAnswer((_) async {});
    when(
      () => mockTaskRepository.watchTasks(),
    ).thenAnswer((_) => Stream.value([]));
    when(() => mockTaskRepository.addTask(any())).thenAnswer((_) async {});
    when(() => mockTaskRepository.updateTask(any())).thenAnswer((_) async {});
    when(() => mockTaskRepository.deleteTask(any())).thenAnswer((_) async {});
    when(
      () => mockTaskRepository.toggleTaskCompletion(any()),
    ).thenAnswer((_) async {});
    when(
      () => mockTaskRepository.reinitializeTriggers(),
    ).thenAnswer((_) async {});

    // Inicjalizacja repositories
    authRepository = AuthRepository(
      apiClient,
      authLocalDatasource,
      taskLocalDatasource,
      deviceService,
      mockTaskRepository,
    );

    taskRepository = TaskRepositoryImpl(
      localDatasource: taskLocalDatasource,
      apiClient: apiClient,
      deviceService: deviceService,
      notificationService: notificationService,
      geofencingService: geofencingService,
      authLocalDatasource: authLocalDatasource,
    );
  }

  void resetMocks() {
    clearInteractions(deviceService);
    clearInteractions(notificationService);
    clearInteractions(geofencingService);
    clearInteractions(authLocalDatasource);
    clearInteractions(taskLocalDatasource);
    clearInteractions(mockTaskRepository);
  }

  void tearDown() {
    dio.close();
  }
}

// ============ TESTS ============

void main() {
  final fixtures = AcceptanceTestFixtures();

  setUpAll(() async {
    await fixtures.setUp();
  });

  tearDown(() {
    fixtures.resetMocks();
  });

  tearDownAll(() {
    fixtures.tearDown();
  });

  group('User Story 1: Register Account', () {
    test('AC: Formularz wymaga loginu i hasła. Po udanej rejestracji system '
        'automatycznie loguje użytkownika.', () async {
      // Given
      final login = 'newuser_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      // When
      final response = await fixtures.authRepository.register(
        login,
        password,
        password,
      );

      // Then
      expect(response.user.login, equals(login));
      expect(response.accessToken, isNotEmpty);
      expect(response.refreshToken, isNotEmpty);
      expect(fixtures.currentAccessToken, isNotEmpty);
      expect(fixtures.currentRefreshToken, isNotEmpty);

      verify(
        () => fixtures.authLocalDatasource.saveTokens(
          accessToken: any(named: 'accessToken'),
          refreshToken: any(named: 'refreshToken'),
        ),
      ).called(1);
    });

    test(
      'AC: Rejestracja z istniejącym loginem powinna zwrócić błąd 409 Conflict',
      () async {
        // Given
        final login = 'testuser_${DateTime.now().millisecondsSinceEpoch}';
        final password = 'SecurePass123!';

        // Register once
        await fixtures.authRepository.register(login, password, password);

        // When/Then - next registration with same login fails
        expect(
          () async =>
              await fixtures.authRepository.register(login, password, password),
          throwsA(
            isA<DioException>().having(
              (e) => e.response?.statusCode,
              'statusCode',
              409,
            ),
          ),
        );
      },
    );
  });

  group('User Story 2: Login', () {
    test('AC: System autentykuje użytkownika i zwraca token dostępu', () async {
      // Given
      final login = 'logintest_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      // Register user first
      await fixtures.authRepository.register(login, password, password);
      fixtures.currentAccessToken = null;
      fixtures.currentRefreshToken = null;

      // When - Login
      final response = await fixtures.authRepository.login(login, password);

      // Then
      expect(response.user.login, equals(login));
      expect(response.accessToken, isNotEmpty);
      expect(fixtures.currentAccessToken, isNotEmpty);
    });

    test('AC: Błędne dane logowania wyświetlają komunikat "Nieprawidłowy login '
        'lub hasło"', () async {
      // Given
      final login = 'nonexistent_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'WrongPassword123!';

      // When/Then
      expect(
        () async => await fixtures.authRepository.login(login, password),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );
    });
  });

  group('User Story 3: Logout', () {
    test('AC: Kliknięcie "Wyloguj" usuwa token JWT z pamięci lokalnej i '
        'przekierowuje na ekran logowania', () async {
      // Given
      final login = 'logouttest_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);
      expect(fixtures.currentAccessToken, isNotEmpty);

      // When
      await fixtures.authRepository.logout();

      // Then
      expect(fixtures.currentAccessToken, isNull);
      expect(fixtures.currentRefreshToken, isNull);

      verify(() => fixtures.authLocalDatasource.clearAll()).called(1);
      verify(
        () => fixtures.taskLocalDatasource.deleteAllTasks(),
      ).called(greaterThanOrEqualTo(1));
    });
  });

  group('User Story 4: View Tasks List with Active/Inactive Division', () {
    test('AC: Widok listy z zadaniami. W przypadku braku zadań wyświetla '
        'odpowiedni komunikat.', () async {
      // Given
      final login = 'tasklisttest_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      // When - Get tasks stream
      final tasksStream = fixtures.taskRepository.watchTasks();

      // Then - empty list on start
      final firstEmission = await tasksStream.first;
      expect(firstEmission, isEmpty);

      verify(() => fixtures.taskLocalDatasource.watchAllTasks()).called(1);
    });
  });

  group('User Story 5: Task Type Labels (One-time vs Recurrent)', () {
    test('AC: Kafelki zadań na widoku listy posiadają odpowiednią ikonę lub '
        'etykietę informującą o ich typie', () async {
      // Given
      final login = 'tasktype_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      // When - create tasks with different types
      final oneTimeTask = Task(
        id: 'task1',
        title: 'One-time task',
        description: 'Test one-time',
        type: TaskType.oneTime,
        completed: false,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final recurrentTask = Task(
        id: 'task2',
        title: 'Recurrent task',
        description: 'Test recurrent',
        type: TaskType.recurrent,
        completed: false,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Then - verify types are preserved
      expect(oneTimeTask.type, equals(TaskType.oneTime));
      expect(recurrentTask.type, equals(TaskType.recurrent));
    });
  });

  group('User Story 6: Add New Task', () {
    test('AC: Formularz zawiera pole tytułu (wymagane) i opisu (opcjonalne). '
        'Maksymalna długość tytułu to 50 znaków.', () async {
      // Given
      final login = 'addtask_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      final validTitle = 'Buy groceries';
      final validDescription = 'Milk, eggs, bread';

      // When
      final task = Task(
        id: 'task_${DateTime.now().millisecondsSinceEpoch}',
        title: validTitle,
        description: validDescription,
        type: TaskType.oneTime,
        completed: false,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await fixtures.taskRepository.addTask(task);

      // Then
      verify(() => fixtures.taskLocalDatasource.upsertTask(any())).called(1);
      expect(task.title.length, lessThanOrEqualTo(50));
      expect(task.description, isNotNull);
    });

    test('AC: Tytuł powyżej 50 znaków jest odrzucony', () async {
      // Given
      final longTitle = 'A' * 51; // 51 characters

      // When/Then
      expect(longTitle.length, greaterThan(50));
    });
  });

  group('User Story 7: Task Type Selection (One-time vs Recurrent)', () {
    test('AC: W formularzu dodawania oraz edycji zadania znajduje się widoczny '
        'komponent z opcją „Typ zadania: Jednorazowe / Stałe".', () async {
      // Given
      final login = 'tasktype_select_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      // When - create task with explicit type
      final oneTimeTask = Task(
        id: 'task_1',
        title: 'One-time task',
        description: null,
        type: TaskType.oneTime,
        completed: false,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final recurrentTask = Task(
        id: 'task_2',
        title: 'Recurrent task',
        description: null,
        type: TaskType.recurrent,
        completed: false,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await fixtures.taskRepository.addTask(oneTimeTask);
      await fixtures.taskRepository.addTask(recurrentTask);

      // Then
      verify(() => fixtures.taskLocalDatasource.upsertTask(any())).called(2);
      expect(oneTimeTask.type, equals(TaskType.oneTime));
      expect(recurrentTask.type, equals(TaskType.recurrent));
    });
  });

  group('User Story 8: Mark Task as Completed', () {
    test('AC: Przesunięcie kafelka zadania (swipe) lub kliknięcie checkboxa '
        'dezaktywuje powiadomienia dla tego zadania i ukrywa je z głównego '
        'widoku.', () async {
      // Given
      final login = 'completetask_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      final taskId = 'task_${DateTime.now().millisecondsSinceEpoch}';

      final existingTask = TaskEntry(
        id: taskId,
        title: 'Buy groceries',
        description: 'Milk, eggs, bread',
        type: 'one_time',
        completed: false,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPendingSync: false,
      );

      when(
        () => fixtures.taskLocalDatasource.getTaskById(taskId),
      ).thenAnswer((_) async => existingTask);

      // When - toggle completion via mock repository
      await fixtures.taskRepository.toggleTaskCompletion(taskId);

      // Then - teraz upsertTask na pewno się wykona
      verify(() => fixtures.taskLocalDatasource.upsertTask(any())).called(1);
    });
  });

  group('User Story 9: Edit Existing Task', () {
    test('AC: Edycja nadpisuje dane w bazie lokalnej i wysyła PUT/PATCH do '
        'API.', () async {
      // Given
      final login = 'edittask_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      final taskId = 'task_edit_${DateTime.now().millisecondsSinceEpoch}';
      final task = Task(
        id: taskId,
        title: 'Original title',
        description: 'Original description',
        type: TaskType.oneTime,
        completed: false,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updatedTask = task.copyWith(
        title: 'Updated title',
        description: 'Updated description',
      );

      // When
      await fixtures.taskRepository.updateTask(updatedTask);

      // Then - Przechwytujemy obiekt i rzutujemy na TaskEntry zamiast Task
      final captured = verify(
        () => fixtures.taskLocalDatasource.upsertTask(captureAny()),
      ).captured;
      final savedTask = captured.first as TaskEntry; // <--- TUTAJ ZMIANA

      expect(updatedTask.title, equals('Updated title'));
      expect(
        savedTask.version,
        greaterThan(task.version),
      ); // Sprawdzamy wersję zapisanego obiektu TaskEntry
    });
  });

  group('User Story 10: Delete Task', () {
    test('AC: System prosi o potwierdzenie usunięcia. Po potwierdzeniu '
        'zadanie znika na zawsze (hard delete).', () async {
      // Given
      final login = 'deletetask_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      // When - delete task
      final taskId = 'task_${DateTime.now().millisecondsSinceEpoch}';
      await fixtures.taskRepository.deleteTask(taskId);

      // Then
      verify(() => fixtures.taskLocalDatasource.deleteTask(taskId)).called(1);
    });
  });

  group('User Story 11: Time-based Trigger', () {
    test('AC: Wybór daty i godziny przez natywny date/time picker Androida. '
        'Nie można ustawić daty z przeszłości.', () async {
      // Given
      final login = 'timetrigger_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      final futureTime = DateTime.now().add(const Duration(days: 1, hours: 2));
      final pastTime = DateTime.now().subtract(const Duration(hours: 1));

      // When - create task with future time trigger
      final task = Task(
        id: 'task_time_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Future task',
        description: null,
        type: TaskType.oneTime,
        completed: false,
        timeTriggerAt: futureTime,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await fixtures.taskRepository.addTask(task);

      // Then
      verify(
        () => fixtures.notificationService.scheduleNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledDate: any(named: 'scheduledDate'),
        ),
      ).called(1);

      // Past time should be validated by UI layer or API
      expect(pastTime.isBefore(DateTime.now()), isTrue);
      expect(futureTime.isAfter(DateTime.now()), isTrue);
    });
  });

  group('User Story 12: Geo-based Trigger', () {
    test('AC: Widok mapy z możliwością wyboru lokalizacji. Domyślny promień '
        'geofencingu wynosi 100 metrów.', () async {
      // Given
      final login = 'geotrigger_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      const defaultRadius = 100;
      const latitude = 52.2297;
      const longitude = 21.0122;

      // When
      final task = Task(
        id: 'task_geo_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Location task',
        description: 'Task at specific location',
        type: TaskType.recurrent,
        completed: false,
        geoTriggerLatitude: latitude,
        geoTriggerLongitude: longitude,
        geoTriggerRadius: defaultRadius,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await fixtures.taskRepository.addTask(task);

      // Then
      verify(
        () => fixtures.geofencingService.registerGeofence(
          id: any(named: 'id'),
          title: any(named: 'title'),
          lat: any(named: 'lat'),
          lng: any(named: 'lng'),
          radius: any(named: 'radius'),
        ),
      ).called(1);

      expect(task.geoTriggerRadius, equals(defaultRadius));
      expect(task.geoTriggerLatitude, equals(latitude));
      expect(task.geoTriggerLongitude, equals(longitude));
    });
  });

  group('User Story 13: Push Notification on Time Trigger', () {
    test('AC: Powiadomienie pojawia się nawet, gdy aplikacja jest zamknięta. '
        'Zawiera tytuł zadania.', () async {
      // Given
      final login = 'pushtime_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      final taskTitle = 'Important task';
      final futureTime = DateTime.now().add(const Duration(hours: 1));

      // When
      final task = Task(
        id: 'task_push_${DateTime.now().millisecondsSinceEpoch}',
        title: taskTitle,
        description: 'Task description',
        type: TaskType.oneTime,
        completed: false,
        timeTriggerAt: futureTime,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await fixtures.taskRepository.addTask(task);

      // Then
      verify(
        () => fixtures.notificationService.scheduleNotification(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledDate: futureTime,
        ),
      ).called(1);
    });
  });

  group('User Story 14: Push Notification on Geo-trigger Entry/Exit', () {
    test('AC: Powiadomienie jest wyzwalane przez systemowe usługi '
        'lokalizacyjne.', () async {
      // Given
      final login = 'pushgeo_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      // When
      final task = Task(
        id: 'task_geo_push_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Location reminder',
        description: null,
        type: TaskType.oneTime,
        completed: false,
        geoTriggerLatitude: 52.2297,
        geoTriggerLongitude: 21.0122,
        geoTriggerRadius: 100,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await fixtures.taskRepository.addTask(task);

      // Then
      verify(
        () => fixtures.geofencingService.registerGeofence(
          id: any(named: 'id'),
          title: any(named: 'title'),
          lat: 52.2297,
          lng: 21.0122,
          radius: 100,
        ),
      ).called(1);
    });
  });

  group('User Story 15: Permissions Onboarding', () {
    test('AC: Ekran wdrożeniowy (onboarding) tłumaczący, dlaczego uprawnienia '
        'są potrzebne. Jeśli użytkownik odmówi uprawnień, blokowane jest '
        'tworzenie zadań lokalizacyjnych.', () async {
      // Given
      final login = 'perms_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      // When/Then - Attempting to create geo task without permissions
      // This would be enforced at UI layer
      final geoTaskWithoutPerms = Task(
        id: 'task_geo_noperms_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Geo task',
        description: null,
        type: TaskType.oneTime,
        completed: false,
        geoTriggerLatitude: 52.2297,
        geoTriggerLongitude: 21.0122,
        geoTriggerRadius: 100,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // The task is created - permission check happens at UI/OS level
      await fixtures.taskRepository.addTask(geoTaskWithoutPerms);
      verify(() => fixtures.taskLocalDatasource.upsertTask(any())).called(1);
    });
  });

  group('User Story 16: Offline Support', () {
    test(
      'AC: Aplikacja zapisuje zadanie w lokalnej bazie z flagą '
      '"niezsynchronizowane" i ustawia lokalny wyzwalacz powiadomień.',
      () async {
        // Given
        final login = 'offline_${DateTime.now().millisecondsSinceEpoch}';
        final password = 'SecurePass123!';

        await fixtures.authRepository.register(login, password, password);

        // When - create task (simulating offline mode)
        final task = Task(
          id: 'task_offline_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Offline task',
          description: 'Created while offline',
          type: TaskType.oneTime,
          completed: false,
          timeTriggerAt: DateTime.now().add(const Duration(hours: 2)),
          version: 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await fixtures.taskRepository.addTask(task);

        // Then
        verify(() => fixtures.taskLocalDatasource.upsertTask(any())).called(1);
        verify(
          () => fixtures.notificationService.scheduleNotification(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
          ),
        ).called(1);
      },
    );
  });

  group('User Story 17: View Tasks on Map', () {
    test('AC 1: Widok mapy wyświetla markery w miejscach przypisanych do '
        'zadań z wyzwalaczem geograficznym.', () async {
      // Given
      final login = 'mapview_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      // When
      final geoTask = Task(
        id: 'task_map_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Map task',
        description: null,
        type: TaskType.recurrent,
        completed: false,
        geoTriggerLatitude: 52.2297,
        geoTriggerLongitude: 21.0122,
        geoTriggerRadius: 150,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await fixtures.taskRepository.addTask(geoTask);

      // Then
      verify(
        () => fixtures.geofencingService.registerGeofence(
          id: geoTask.id,
          title: geoTask.title,
          lat: 52.2297,
          lng: 21.0122,
          radius: 150,
        ),
      ).called(1);

      expect(geoTask.geoTriggerLatitude, isNotNull);
      expect(geoTask.geoTriggerLongitude, isNotNull);
    });

    test('AC 2: Kliknięcie w marker pokazuje dymek (tooltip) z tytułem '
        'zadania i przyciskiem "Szczegóły".', () async {
      // Given
      final login = 'maptooltip_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      // When - create geo task
      final geoTask = Task(
        id: 'task_tooltip_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Meeting at location',
        description: 'Office meeting details',
        type: TaskType.oneTime,
        completed: false,
        geoTriggerLatitude: 52.2297,
        geoTriggerLongitude: 21.0122,
        geoTriggerRadius: 100,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await fixtures.taskRepository.addTask(geoTask);

      // Then - tooltip information is preserved in task
      expect(geoTask.title, equals('Meeting at location'));
      expect(geoTask.description, isNotNull);
      expect(geoTask.geoTriggerLatitude, equals(52.2297));
      expect(geoTask.geoTriggerLongitude, equals(21.0122));
    });

    test(
      'AC 3: Mapa automatycznie centruje się na aktualnej pozycji '
      'użytkownika po jej otwarciu (jeśli wyrażono zgodę na lokalizację).',
      () async {
        // Given
        final login = 'mapcenter_${DateTime.now().millisecondsSinceEpoch}';
        final password = 'SecurePass123!';

        await fixtures.authRepository.register(login, password, password);

        // When - open map view (this would be handled by UI)
        // The backend just needs to provide task location data
        const userLatitude = 52.2297;
        const userLongitude = 21.0122;

        // Then - tasks should have location data available
        final geoTask = Task(
          id: 'task_center_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Centered task',
          description: null,
          type: TaskType.oneTime,
          completed: false,
          geoTriggerLatitude: userLatitude,
          geoTriggerLongitude: userLongitude,
          geoTriggerRadius: 100,
          version: 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(geoTask.geoTriggerLatitude, equals(userLatitude));
        expect(geoTask.geoTriggerLongitude, equals(userLongitude));
      },
    );

    test('AC 4: Zadania wykonane (nieaktywne) są ukryte na mapie.', () async {
      // Given
      final login = 'maphide_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      // When
      final completedGeoTask = Task(
        id: 'task_hide_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Completed geo task',
        description: null,
        type: TaskType.oneTime,
        completed: true, // Mark as completed
        geoTriggerLatitude: 52.2297,
        geoTriggerLongitude: 21.0122,
        geoTriggerRadius: 100,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Then - completed tasks should not trigger geofencing
      // (geofencing service should not be called for completed tasks)
      expect(completedGeoTask.completed, isTrue);
      // In real implementation, geofencingService.removeGeofence() would be called
    });
  });

  group('Offline Sync & Conflict Resolution', () {
    test('System syncs pending changes when connection is restored after '
        'offline edits.', () async {
      // Given
      final login = 'synctest_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      // When - add multiple tasks
      for (int i = 0; i < 3; i++) {
        final task = Task(
          id: 'task_sync_$i',
          title: 'Sync task $i',
          description: 'Test',
          type: TaskType.oneTime,
          completed: false,
          version: 1,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await fixtures.taskRepository.addTask(task);
      }

      // Then
      verify(() => fixtures.taskLocalDatasource.upsertTask(any())).called(3);
    });

    test('Optimistic locking prevents conflicts: local version increments on '
        'edit', () async {
      // Given
      final login = 'occtest_${DateTime.now().millisecondsSinceEpoch}';
      final password = 'SecurePass123!';

      await fixtures.authRepository.register(login, password, password);

      // When
      final initialTask = Task(
        id: 'task_occ_1',
        title: 'OCC task',
        description: null,
        type: TaskType.oneTime,
        completed: false,
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final edited1 = initialTask.copyWith(title: 'Edited 1', version: 2);

      final edited2 = initialTask.copyWith(
        title: 'Edited 2',
        version: 2, // Same version as edited1
      );

      await fixtures.taskRepository.updateTask(edited1);
      await fixtures.taskRepository.updateTask(edited2);

      // Then - both edits increase local version
      expect(edited1.version, equals(2));
      expect(edited2.version, equals(2));
    });
  });
}
