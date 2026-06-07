import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/services/permissions_service.dart';
import 'package:app/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:app/features/tasks/presentation/screens/tasks_screen.dart';
import 'package:app/features/tasks/presentation/widgets/add_time_task_sheet.dart';
import 'package:app/features/tasks/presentation/screens/map_picker_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TasksScreen(),
    const MapPickerScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Prośba o uprawnienia przy pierwszym wejściu po zalogowaniu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(permissionsServiceProvider).requestInitialPermissions();
    });
  }

  Future<void> _showAddTaskSheet(BuildContext context) async {
    if (_currentIndex == 0) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        builder: (context) => const AddTimeTaskSheet(),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Użyj przycisku na mapie, aby zatwierdzić strefę.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Zadania',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_rounded),
            label: 'Mapa',
          ),
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
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Wyloguj się'),
              onTap: () {
                ref.read(authStateProvider.notifier).logout();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 0 
        ? FloatingActionButton.extended(
            onPressed: () => _showAddTaskSheet(context),
            label: const Text('Zadanie czasowe'),
            icon: const Icon(Icons.add_alarm),
          )
        : null,
    );
  }
}
