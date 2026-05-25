// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TaskSearchQuery)
final taskSearchQueryProvider = TaskSearchQueryProvider._();

final class TaskSearchQueryProvider
    extends $NotifierProvider<TaskSearchQuery, String> {
  TaskSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskSearchQueryHash();

  @$internal
  @override
  TaskSearchQuery create() => TaskSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$taskSearchQueryHash() => r'25146e733180fee73f9c58890d815c6a6745e363';

abstract class _$TaskSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(refreshTaskList)
final refreshTaskListProvider = RefreshTaskListProvider._();

final class RefreshTaskListProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  RefreshTaskListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refreshTaskListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refreshTaskListHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return refreshTaskList(ref);
  }
}

String _$refreshTaskListHash() => r'27321ed84c5a640013cc138a68bd32afa4419e1a';

@ProviderFor(allTasks)
final allTasksProvider = AllTasksProvider._();

final class AllTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  AllTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allTasksHash();

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    return allTasks(ref);
  }
}

String _$allTasksHash() => r'd791e541e787e55fdc9926bd92a85339ebe744bf';

@ProviderFor(filteredTasks)
final filteredTasksProvider = FilteredTasksProvider._();

final class FilteredTasksProvider
    extends $FunctionalProvider<List<Task>, List<Task>, List<Task>>
    with $Provider<List<Task>> {
  FilteredTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredTasksHash();

  @$internal
  @override
  $ProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Task> create(Ref ref) {
    return filteredTasks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Task> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Task>>(value),
    );
  }
}

String _$filteredTasksHash() => r'76cad33f956f4c6df73bfe1d1dd5d87a839f975a';

@ProviderFor(timeTasks)
final timeTasksProvider = TimeTasksProvider._();

final class TimeTasksProvider
    extends $FunctionalProvider<List<Task>, List<Task>, List<Task>>
    with $Provider<List<Task>> {
  TimeTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timeTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timeTasksHash();

  @$internal
  @override
  $ProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Task> create(Ref ref) {
    return timeTasks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Task> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Task>>(value),
    );
  }
}

String _$timeTasksHash() => r'a0bffbac50b70225d868eb85af74e204829e4b86';

@ProviderFor(geoTasks)
final geoTasksProvider = GeoTasksProvider._();

final class GeoTasksProvider
    extends $FunctionalProvider<List<Task>, List<Task>, List<Task>>
    with $Provider<List<Task>> {
  GeoTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geoTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geoTasksHash();

  @$internal
  @override
  $ProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Task> create(Ref ref) {
    return geoTasks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Task> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Task>>(value),
    );
  }
}

String _$geoTasksHash() => r'9acf3661a60ab5151d7dd9caaa74d9a03da99aed';
