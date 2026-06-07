import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/map_picker_provider.dart';
import '../widgets/add_geo_task_sheet.dart';

class MapPickerScreen extends ConsumerStatefulWidget {
  const MapPickerScreen({super.key});

  @override
  ConsumerState<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends ConsumerState<MapPickerScreen> {
  GoogleMapController? _mapController;
  bool _isLocating = false;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _confirmSelection(LatLng center, double radius) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => AddGeoTaskSheet(
        lat: center.latitude,
        lng: center.longitude,
        radius: radius,
      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    setState(() => _isLocating = true);
    try {
      final position = await _determinePosition();
      final latLng = LatLng(position.latitude, position.longitude);
      
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 15),
      );
      
      ref.read(mapPickerProvider.notifier).updateCenter(latLng);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Błąd lokalizacji: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Usługi lokalizacji są wyłączone.');

    permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return Future.error('Brak uprawnień do lokalizacji. Sprawdź ustawienia aplikacji.');
    } 

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final pickerState = ref.watch(mapPickerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wybierz strefę'),
        actions: [
          IconButton(
            icon: _isLocating 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.my_location),
            onPressed: _isLocating ? null : _goToCurrentLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: pickerState.center,
              zoom: 14,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onCameraMove: (position) {
              ref.read(mapPickerProvider.notifier).updateCenter(position.target);
            },
            circles: {
              Circle(
                circleId: const CircleId('picker_radius'),
                center: pickerState.center,
                radius: pickerState.radius,
                fillColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                strokeColor: theme.colorScheme.primary,
                strokeWidth: 2,
              ),
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 36),
              child: Icon(
                Icons.location_on,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.radar, color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          'Promień strefy: ${pickerState.radius.round()}m',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Slider(
                      value: pickerState.radius,
                      min: 50,
                      max: 2000,
                      divisions: 39,
                      label: '${pickerState.radius.round()}m',
                      onChanged: (val) {
                        ref.read(mapPickerProvider.notifier).updateRadius(val);
                      },
                    ),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      onPressed: () => _confirmSelection(pickerState.center, pickerState.radius),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Zatwierdź tę lokalizację'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
