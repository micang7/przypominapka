// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geofencing_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(geofencingService)
final geofencingServiceProvider = GeofencingServiceProvider._();

final class GeofencingServiceProvider
    extends
        $FunctionalProvider<
          GeofencingService,
          GeofencingService,
          GeofencingService
        >
    with $Provider<GeofencingService> {
  GeofencingServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geofencingServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geofencingServiceHash();

  @$internal
  @override
  $ProviderElement<GeofencingService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GeofencingService create(Ref ref) {
    return geofencingService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeofencingService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeofencingService>(value),
    );
  }
}

String _$geofencingServiceHash() => r'dba052cd148958b9e56231e7ce97e3234852bf31';
