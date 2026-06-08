import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/services/permissions_service.dart';
import 'package:app/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:app/features/tasks/presentation/screens/tasks_screen.dart';
import 'package:app/features/tasks/presentation/widgets/add_time_task_sheet.dart';
import 'package:app/features/tasks/presentation/screens/tasks_map_screen.dart';
import 'package:app/features/auth/presentation/widgets/change_password_sheet.dart';
import 'package:app/features/auth/data/repositories/auth_repository.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TasksScreen(),
    const TasksMapScreen(),
  ];

  Future<void> _confirmDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usuń konto'),
        content: const Text('Czy na pewno chcesz trwale usunąć konto? Wszystkie dane zostaną bezpowrotnie usunięte.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Anuluj')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Usuń'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(authRepositoryProvider).deleteAccount();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Błąd usuwania konta: $e')),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(permissionsServiceProvider).requestInitialPermissions();
      // Uruchom wyzwalacze dopiero po zapytaniu o uprawnienia
      await ref.read(taskRepositoryProvider).reinitializeTriggers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list_alt_rounded), label: 'Zadania'),
          NavigationDestination(icon: Icon(Icons.map_rounded), label: 'Mapa'),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person, size: 48, color: Colors.white),
                    SizedBox(height: 8),
                    Text('Użytkownik', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.password_rounded),
              title: const Text('Zmień hasło'),
              onTap: () {
                Navigator.pop(context); // Zamknij drawer
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
                  builder: (context) => const ChangePasswordSheet(),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_remove_rounded, color: Colors.red),
              title: const Text('Usuń konto', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context); // Zamknij drawer
                _confirmDeleteAccount();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Wyloguj się'),
              onTap: () => ref.read(authStateProvider.notifier).logout(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 0 
        ? FloatingActionButton.extended(
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => const AddTimeTaskSheet(),
            ),
            label: const Text('Zadanie czasowe'),
            icon: const Icon(Icons.add_alarm),
          )
        : FloatingActionButton.extended(
            onPressed: () => context.push('/map-picker'),
            label: const Text('Zadanie regionalne'),
            icon: const Icon(Icons.add_location_alt),
          ),
    );
  }
}
