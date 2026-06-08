import 'dart:developer';

import 'package:flutter/material.dart';

import 'src/state_controller.dart';

export 'src/state_controller.dart';

/// Signature for a function that creates a [StateController].
typedef Creator<T extends StateController> = T Function();

/// An [InheritedWidget] that provides [StateController] instances to its descendants.
///
/// [ControlRoom] acts as a central registry and dependency injection container for
/// your application's state controllers. It manages their lifecycle, including
/// lazy initialization and automatic disposal.
class ControlRoom extends InheritedWidget {
  /// The map of functions responsible for creating the controllers.
  final Map<Type, Creator> controllers;

  /// Creates a [ControlRoom].
  ///
  /// The [controllers] list defines which [StateController]s are available
  /// to the widget tree below this widget.
  const ControlRoom({
    super.key,
    required this.controllers,
    required super.child,
  });

  /// Internal registry of initialized controllers.
  static final Map<Type, StateController> _initialized = {};

  /// Internal helper to find the nearest [ControlRoom] in the widget tree.
  static ControlRoom _of(BuildContext context) {
    final ControlRoom? room = context
        .dependOnInheritedWidgetOfExactType<ControlRoom>();
    if (room == null) {
      throw StateError(
        'No Control Room widget found!, make sure to add one in the root of your app!',
      );
    }
    return room;
  }

  /// Retrieves a [StateController] of type [S] from the nearest [ControlRoom].
  ///
  /// If the controller has not been initialized yet, it will be created using
  /// the corresponding [Creator] provided in the [ControlRoom] constructor.
  /// Subsequent calls will return the same instance.
  ///
  /// Throws a [StateError] if no [Creator] for type [S] is found.
  static S get<S extends StateController>(BuildContext context) {
    final room = _of(context);
    final controller = _initialized[S];
    if (controller != null) {
      log('$S ACCESSED', name: 'CONTROL-ROOM');
      return controller as S;
    }
    if (room.controllers.containsKey(S)) {
      final controller = room.controllers[S]!();
      _initialized[S] = controller;
      return controller as S;
    }
    throw StateError(
      '$S not found, make sure to add $S in ControlRoom widget!',
    );
  }

  /// Removes and disposes the [StateController] of type [T].
  ///
  /// This is typically called automatically by [StateListener] or [StateSelector]
  /// when its last instance is disposed, but can be called manually for custom cleanup.
  static void remove<T extends StateController>() {
    final controller = _initialized[T] as T?;
    if (controller != null) {
      controller.dispose();
      _initialized.remove(T);
    }
  }

  /// Internal helper to clear the registry. (Used for testing)
  @visibleForTesting
  static void clearRegistry() {
    for (final controller in _initialized.values) {
      controller.dispose();
    }
    _initialized.clear();
  }

  @override
  bool updateShouldNotify(covariant ControlRoom oldWidget) {
    return oldWidget.controllers != controllers;
  }
}
