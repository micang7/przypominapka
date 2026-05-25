import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:app/features/tasks/domain/entities/task.dart';
import '../providers/tasks_providers.dart';
import '../providers/task_list_provider.dart';

class AddGeoTaskSheet extends ConsumerStatefulWidget {
  final double lat;
  final double lng;
  final double radius;

  const AddGeoTaskSheet({
    super.key,
    required this.lat,
    required this.lng,
    required this.radius,
  });

  @override
  ConsumerState<AddGeoTaskSheet> createState() => _AddGeoTaskSheetState();
}

class _AddGeoTaskSheetState extends ConsumerState<AddGeoTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        type: TaskType.oneTime,
        completed: false,
        geoTriggerLatitude: widget.lat,
        geoTriggerLongitude: widget.lng,
        geoTriggerRadius: widget.radius.round(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        // Dodajemy task i czekamy na dodanie do bazy
        await ref.read(taskRepositoryProvider).addTask(newTask);
        
        // Refresh list po dodaniu - wymusza reload streamów
        ref.invalidate(allTasksProvider);
        
        // Pop dialog
        if (mounted && context.mounted) {
          Navigator.pop(context);
          
          // Pokaż success snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Zadanie regionalne zostało dodane')),
          );
        }
      } catch (e) {
        // Obsługa błędu
        if (mounted && context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Błąd przy dodawaniu: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(24, 8, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Szczegóły przypomnienia',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Lokalizacja została wybrana. Teraz nazwij swoje zadanie.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _titleController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Tytuł zadania',
                hintText: 'Np. Kupić mleko w tym sklepie',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Podaj tytuł zadania' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Opis (opcjonalnie)',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Zapisz zadanie'),
            ),
          ],
        ),
      ),
    );
  }
}
