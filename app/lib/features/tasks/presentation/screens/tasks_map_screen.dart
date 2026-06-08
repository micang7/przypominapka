import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app/features/tasks/domain/entities/task.dart';
import 'package:app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:app/features/tasks/presentation/widgets/edit_task_sheet.dart';
import 'package:app/core/utils/error_parser.dart';
import '../providers/task_list_provider.dart';

class TasksMapScreen extends ConsumerStatefulWidget {
  const TasksMapScreen({super.key});

  @override
  ConsumerState<TasksMapScreen> createState() => _TasksMapScreenState();
}

class _TasksMapScreenState extends ConsumerState<TasksMapScreen> {
  GoogleMapController? _mapController;
  LatLng _initialLocation = const LatLng(52.2297, 21.0122); // Warszawa jako default
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _showTaskDetails(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => EditTaskSheet(task: task),
    );
  }

  Future<void> _setInitialLocation() async {
    try {
      final position = await _determinePosition();
      if (mounted) {
        setState(() {
          _initialLocation = LatLng(position.latitude, position.longitude);
          _isLoading = false;
        });
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(_initialLocation, 14),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Błąd lokalizacji: $e')),
        );
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Usługi lokalizacji są wyłączone.');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Brak uprawnień do lokalizacji.');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Uprawnienia do lokalizacji są trwale zablokowane.');
    } 

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final geoTasks = ref.watch(geoTasksProvider);
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa zadań'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Synchronizuj',
            onPressed: () async {
              try {
                await ref.read(taskRepositoryProvider).syncTasks();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Zadania zsynchronizowane')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ErrorParser.parse(e))),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialLocation,
          zoom: 14,
        ),
        onMapCreated: (controller) => _mapController = controller,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        circles: geoTasks.map((task) {
          return Circle(
            circleId: CircleId(task.id),
            center: LatLng(task.geoTriggerLatitude!, task.geoTriggerLongitude!),
            radius: (task.geoTriggerRadius ?? 100).toDouble(),
            fillColor: (task.completed ? Colors.grey : theme.colorScheme.primary).withValues(alpha: 0.2),
            strokeColor: task.completed ? Colors.grey : theme.colorScheme.primary,
            strokeWidth: 2,
            consumeTapEvents: true,
            onTap: () => _showTaskDetails(task),
          );
        }).toSet(),
      ),
    );
  }
}
