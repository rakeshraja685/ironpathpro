// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_session_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeSessionViewModelHash() =>
    r'64dd67d34dd935e28c75370f4633ab6ded3f21b6';

/// See also [ActiveSessionViewModel].
@ProviderFor(ActiveSessionViewModel)
final activeSessionViewModelProvider = AutoDisposeNotifierProvider<
    ActiveSessionViewModel, WorkoutSession?>.internal(
  ActiveSessionViewModel.new,
  name: r'activeSessionViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeSessionViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ActiveSessionViewModel = AutoDisposeNotifier<WorkoutSession?>;
String _$sessionTimerHash() => r'6d0139dce136e57dfad95ad5964dbd06f390c13f';

/// See also [SessionTimer].
@ProviderFor(SessionTimer)
final sessionTimerProvider =
    AutoDisposeNotifierProvider<SessionTimer, int>.internal(
  SessionTimer.new,
  name: r'sessionTimerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$sessionTimerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SessionTimer = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
