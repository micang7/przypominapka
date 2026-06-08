import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/tasks/presentation/providers/map_picker_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  ProviderContainer createContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  test('MapPickerNotifier initializes with default Warsaw coordinates', () {
    final container = createContainer();
    final state = container.read(mapPickerProvider);
    
    expect(state.center.latitude, 52.2297);
    expect(state.center.longitude, 21.0122);
    expect(state.radius, 200);
  });

  test('updateCenter updates the state', () {
    final container = createContainer();
    const newCenter = LatLng(50.0, 20.0);
    
    container.read(mapPickerProvider.notifier).updateCenter(newCenter);
    
    final state = container.read(mapPickerProvider);
    expect(state.center, newCenter);
  });

  test('updateRadius updates the state', () {
    final container = createContainer();
    
    container.read(mapPickerProvider.notifier).updateRadius(500);
    
    final state = container.read(mapPickerProvider);
    expect(state.radius, 500);
  });

  test('MapPickerState copyWith works correctly', () {
    final state = MapPickerState(center: const LatLng(1, 1), radius: 100);
    
    final newState = state.copyWith(radius: 300);
    expect(newState.radius, 300);
    expect(newState.center, const LatLng(1, 1));
    
    final newState2 = state.copyWith(center: const LatLng(2, 2));
    expect(newState2.center, const LatLng(2, 2));
    expect(newState2.radius, 100);
  });
}
