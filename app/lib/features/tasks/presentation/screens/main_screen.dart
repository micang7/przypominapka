import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:app/features/tasks/presentation/screens/tasks_screen.dart';
import 'package:app/features/tasks/presentation/widgets/add_time_task_sheet.dart';
import 'package:app/features/tasks/presentation/widgets/add_geo_task_sheet.dart';
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
    const MapPickerScreen(), // Używamy teraz właściwego ekranu mapy
  ];

  Future<void> _showAddTaskSheet(BuildContext context) async {
    if (_currentIndex == 0) {
      // Zakładka "Zadania" -> Dodaj zadanie czasowe
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
      // Zakładka "Mapa" -> Wyzwalacz dodawania regionalnego
      // Wyświetlamy prośbę o "Zatwierdzenie lokalizacji" za pomocą FAB, 
      // który już obsługuje MapPickerScreen (zwracając wynik przez Navigator.pop)
      
      // Uwaga: W tej architekturze FAB w MainScreen odpala akcję.
      // Skoro MapPicker jest w IndexedStack, musimy wymyślić jak przekazać sygnał "Zatwierdź".
      // Najprościej: MapPicker sam obsłuży swój przycisk "Zatwierdź" wewnątrz swojego kodu (już to robi).
      // Zatem w zakładce Mapa, FAB może służyć np. do wyśrodkowania na GPS.
      
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
      // FAB widoczny tylko w pierwszej zakładce, mapa ma własny przycisk wewnątrz
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
