import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/tasks/domain/entities/task.dart';
import 'package:app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:app/features/auth/presentation/providers/auth_state_provider.dart';
import '../providers/task_list_provider.dart';
import '../widgets/task_list_item.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  @override
  void initState() {
    super.initState();
    // Synchronizuj zadania po wejściu na ekran
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskRepositoryProvider).syncTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final timeTasks = ref.watch(timeTasksProvider);
    final geoTasks = ref.watch(geoTasksProvider);
    final allTasksAsync = ref.watch(allTasksProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            title: const Text('Twoje Zadania'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Synchronizuj',
                onPressed: () => ref.read(taskRepositoryProvider).syncTasks(),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Wyloguj',
                onPressed: () => ref.read(authStateProvider.notifier).logout(),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: (value) => ref.read(taskSearchQueryProvider.notifier).setQuery(value),
                  decoration: InputDecoration(
                    hintText: 'Szukaj zadań...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),
          // Logika ładowania i pustego stanu
          allTasksAsync.when(
            data: (tasks) {
              if (tasks.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_turned_in_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Brak zadań. Dodaj coś za pomocą przycisku +'),
                      ],
                    ),
                  ),
                );
              }

              return SliverMainAxisGroup(
                slivers: [
                  if (timeTasks.isNotEmpty) ...[
                    _SectionHeader(title: 'Zadania czasowe'),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => TaskListItem(task: timeTasks[index]),
                        childCount: timeTasks.length,
                      ),
                    ),
                  ],
                  if (geoTasks.isNotEmpty) ...[
                    _SectionHeader(title: 'Zadania regionalne'),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => TaskListItem(task: geoTasks[index]),
                        childCount: geoTasks.length,
                      ),
                    ),
                  ],
                ],
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Błąd: $error'),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 88)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
