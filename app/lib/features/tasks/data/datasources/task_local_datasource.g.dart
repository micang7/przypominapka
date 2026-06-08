// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_local_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(taskLocalDatasource)
final taskLocalDatasourceProvider = TaskLocalDatasourceProvider._();

final class TaskLocalDatasourceProvider
    extends
        $FunctionalProvider<
          ITaskLocalDatasource,
          ITaskLocalDatasource,
          ITaskLocalDatasource
        >
    with $Provider<ITaskLocalDatasource> {
  TaskLocalDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskLocalDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskLocalDatasourceHash();

  @$internal
  @override
  $ProviderElement<ITaskLocalDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ITaskLocalDatasource create(Ref ref) {
    return taskLocalDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ITaskLocalDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ITaskLocalDatasource>(value),
    );
  }
}

String _$taskLocalDatasourceHash() =>
    r'fe5988ad3206125bdd757a471f5d6c0fcc2242e1';
