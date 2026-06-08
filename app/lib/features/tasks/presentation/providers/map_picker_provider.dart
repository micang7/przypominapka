import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_picker_provider.g.dart';

class MapPickerState {
  final LatLng center;
  final double radius; // w metrach

  MapPickerState({
    required this.center,
    this.radius = 200,
  });

  MapPickerState copyWith({
    LatLng? center,
    double? radius,
  }) {
    return MapPickerState(
      center: center ?? this.center,
      radius: radius ?? this.radius,
    );
  }
}

@riverpod
class MapPickerNotifier extends _$MapPickerNotifier {
  @override
  MapPickerState build() {
    // Domyślnie Warszawa
    return MapPickerState(center: const LatLng(52.2297, 21.0122));
  }

  void updateCenter(LatLng newCenter) {
    state = state.copyWith(center: newCenter);
  }

  void updateRadius(double newRadius) {
    state = state.copyWith(radius: newRadius);
  }
}
