// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_picker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MapPickerNotifier)
final mapPickerProvider = MapPickerNotifierProvider._();

final class MapPickerNotifierProvider
    extends $NotifierProvider<MapPickerNotifier, MapPickerState> {
  MapPickerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapPickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapPickerNotifierHash();

  @$internal
  @override
  MapPickerNotifier create() => MapPickerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapPickerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapPickerState>(value),
    );
  }
}

String _$mapPickerNotifierHash() => r'134163ab6295ad5cf7eab265644dc257cbb8a40e';

abstract class _$MapPickerNotifier extends $Notifier<MapPickerState> {
  MapPickerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MapPickerState, MapPickerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MapPickerState, MapPickerState>,
              MapPickerState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
