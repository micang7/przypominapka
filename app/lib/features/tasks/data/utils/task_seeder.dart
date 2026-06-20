import 'package:app/features/tasks/domain/entities/task.dart';
import 'package:app/features/tasks/domain/repositories/task_repository_contract.dart';
import 'package:uuid/uuid.dart';

class TaskSeeder {
  static Future<void> seed(ITaskRepository repository) async {
    final now = DateTime.now();
    final uuid = const Uuid();

    final mockTasks = [
      Task(
        id: uuid.v4(),
        title: 'Kupić mleko i chleb',
        description: 'Pamiętaj o pełnoziarnistym!',
        type: TaskType.oneTime,
        completed: false,
        timeTriggerAt: now.add(const Duration(hours: 2)),
        version: 1,
        createdAt: now,
        updatedAt: now,
      ),
      Task(
        id: uuid.v4(),
        title: 'Trening na siłowni',
        description: 'Dzień nóg...',
        type: TaskType.oneTime,
        completed: false,
        timeTriggerAt: now.add(const Duration(hours: 5)),
        version: 1,
        createdAt: now,
        updatedAt: now,
      ),
      Task(
        id: uuid.v4(),
        title: 'Odebrać paczkę',
        description: 'Paczkomat WAW123 przy Biedronce',
        type: TaskType.oneTime,
        completed: false,
        geoTriggerLatitude: 52.2297,
        geoTriggerLongitude: 21.0122,
        geoTriggerRadius: 200,
        version: 1,
        createdAt: now,
        updatedAt: now,
      ),
      Task(
        id: uuid.v4(),
        title: 'Spotkanie z klientem',
        type: TaskType.oneTime,
        completed: false,
        timeTriggerAt: now.add(const Duration(days: 1)),
        version: 1,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (final task in mockTasks) {
      await repository.addTask(task);
    }
  }
}
