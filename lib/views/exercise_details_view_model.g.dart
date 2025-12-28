// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_details_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exerciseDetailsViewModelHash() =>
    r'13be2bc05ae46728fa13b8ba113184b0545de04b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ExerciseDetailsViewModel
    extends BuildlessAutoDisposeAsyncNotifier<List<ExerciseHistoryItem>> {
  late final String exerciseName;

  FutureOr<List<ExerciseHistoryItem>> build(
    String exerciseName,
  );
}

/// See also [ExerciseDetailsViewModel].
@ProviderFor(ExerciseDetailsViewModel)
const exerciseDetailsViewModelProvider = ExerciseDetailsViewModelFamily();

/// See also [ExerciseDetailsViewModel].
class ExerciseDetailsViewModelFamily
    extends Family<AsyncValue<List<ExerciseHistoryItem>>> {
  /// See also [ExerciseDetailsViewModel].
  const ExerciseDetailsViewModelFamily();

  /// See also [ExerciseDetailsViewModel].
  ExerciseDetailsViewModelProvider call(
    String exerciseName,
  ) {
    return ExerciseDetailsViewModelProvider(
      exerciseName,
    );
  }

  @override
  ExerciseDetailsViewModelProvider getProviderOverride(
    covariant ExerciseDetailsViewModelProvider provider,
  ) {
    return call(
      provider.exerciseName,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'exerciseDetailsViewModelProvider';
}

/// See also [ExerciseDetailsViewModel].
class ExerciseDetailsViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ExerciseDetailsViewModel,
        List<ExerciseHistoryItem>> {
  /// See also [ExerciseDetailsViewModel].
  ExerciseDetailsViewModelProvider(
    String exerciseName,
  ) : this._internal(
          () => ExerciseDetailsViewModel()..exerciseName = exerciseName,
          from: exerciseDetailsViewModelProvider,
          name: r'exerciseDetailsViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$exerciseDetailsViewModelHash,
          dependencies: ExerciseDetailsViewModelFamily._dependencies,
          allTransitiveDependencies:
              ExerciseDetailsViewModelFamily._allTransitiveDependencies,
          exerciseName: exerciseName,
        );

  ExerciseDetailsViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.exerciseName,
  }) : super.internal();

  final String exerciseName;

  @override
  FutureOr<List<ExerciseHistoryItem>> runNotifierBuild(
    covariant ExerciseDetailsViewModel notifier,
  ) {
    return notifier.build(
      exerciseName,
    );
  }

  @override
  Override overrideWith(ExerciseDetailsViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ExerciseDetailsViewModelProvider._internal(
        () => create()..exerciseName = exerciseName,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        exerciseName: exerciseName,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ExerciseDetailsViewModel,
      List<ExerciseHistoryItem>> createElement() {
    return _ExerciseDetailsViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseDetailsViewModelProvider &&
        other.exerciseName == exerciseName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, exerciseName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExerciseDetailsViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<List<ExerciseHistoryItem>> {
  /// The parameter `exerciseName` of this provider.
  String get exerciseName;
}

class _ExerciseDetailsViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ExerciseDetailsViewModel,
        List<ExerciseHistoryItem>> with ExerciseDetailsViewModelRef {
  _ExerciseDetailsViewModelProviderElement(super.provider);

  @override
  String get exerciseName =>
      (origin as ExerciseDetailsViewModelProvider).exerciseName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
