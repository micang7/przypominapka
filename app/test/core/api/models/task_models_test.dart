import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/api/models/task_models.dart';

void main() {
  group('TaskDto', () {
    test('should correctly deserialize from JSON', () {
      final json = {
        'id': '1',
        'title': 'Test Task',
        'type': 'one_time',
        'completed': true,
        'version': 1,
        'createdAt': '2023-01-01T10:00:00.000Z',
        'updatedAt': '2023-01-01T11:00:00.000Z',
      };

      final dto = TaskDto.fromJson(json);

      expect(dto.id, '1');
      expect(dto.title, 'Test Task');
      expect(dto.type, 'one_time');
      expect(dto.completed, true);
      expect(dto.version, 1);
    });

    test('should correctly serialize to JSON', () {
      final dto = TaskDto(
        id: '1',
        title: 'Test Task',
        type: 'one_time',
        completed: false,
        version: 1,
        createdAt: DateTime.parse('2023-01-01T10:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-01T11:00:00.000Z'),
      );

      final json = dto.toJson();

      expect(json['id'], '1');
      expect(json['title'], 'Test Task');
      expect(json['completed'], false);
      expect(json['version'], 1);
    });
  });

  group('SyncRequest', () {
    test('should correctly serialize to JSON', () {
      final request = SyncRequest(
        lastSyncAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        deviceId: 'device123',
        changes: const SyncChanges(
          created: [
            TaskDto(
              id: '1', 
              title: 'New', 
              type: 'one_time',
              version: 1,
            )
          ],
        ),
      );

      final json = request.toJson();

      expect(json['deviceId'], 'device123');
      expect(json['changes']['created'], isNotEmpty);
      expect(json['changes']['created'][0]['version'], 1);
    });
  });
}
