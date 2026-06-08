import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/tasks/domain/entities/task.dart';

void main() {
  group('Task Entity', () {
    test('isTimeBased returns true when timeTriggerAt is not null', () {
      final task = Task(
        id: '1',
        title: 'Title',
        type: TaskType.oneTime,
        completed: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        timeTriggerAt: DateTime.now(),
      );
      
      expect(task.isTimeBased, isTrue);
      expect(task.isGeoBased, isFalse);
    });

    test('isGeoBased returns true when geo triggers are not null', () {
      final task = Task(
        id: '1',
        title: 'Title',
        type: TaskType.oneTime,
        completed: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        geoTriggerLatitude: 50.0,
        geoTriggerLongitude: 50.0,
      );
      
      expect(task.isGeoBased, isTrue);
      expect(task.isTimeBased, isFalse);
    });
  });
}
