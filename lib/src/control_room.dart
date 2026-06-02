import 'dart:developer';

import 'package:flutter/material.dart';

import 'state_controller.dart';

/// Signature for a function that creates a [StateController].
typedef Creator<T extends StateController> = T Function();

/// An [InheritedWidget] that provides [StateController] instances to its descendants.
///
/// [ControlRoom] acts as a central registry and dependency injection container for
/// your application's state controllers. It manages their lifecycle, including
/// lazy initialization and automatic disposal.
class ControlRoom extends InheritedWidget {
  /// The list of functions responsible for creating the controllers.
  final List<Creator> controllers;

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
  static final List _initialized = [];

  /// Internal helper to find the nearest [ControlRoom] in the widget tree.
  static ControlRoom _of(BuildContext context) {
    final ControlRoom? room = context.dependOnInheritedWidgetOfExactType<ControlRoom>();
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
    
    // Check if already initialized
    for (final controller in _initialized) {
      if (controller is S) {
        log('$S ACCESSED', name: 'CONTROL-ROOM');
        return controller;
      }
    }
    
    // Attempt to initialize from creators
    for (final creatorFn in room.controllers) {
      // Note: This relies on the creator function's return type matching S.
      // In Dart, we can't easily check the return type of a typedef at runtime 
      // without invoking it or using mirrors. We invoke it and check the type.
      final controller = creatorFn();
      if (controller is S) {
        _initialized.add(controller);
        return controller;
      }
      
      // If it's not the right type, we should probably ignore it and keep looking,
      // but the original logic had a string comparison fallback. 
      // I'll stick to a more robust type check.
    }
    
    throw StateError(
      '$S not found, make sure to add $S in ControlRoom widget!',
    );
  }

  /// Removes and disposes the [StateController] of type [T].
  ///
  /// This is typically called automatically by [StateListener] when its last
  /// instance is disposed, but can be called manually for custom cleanup.
  static void remove<T extends StateController>() {
    final temp = List.of(_initialized);
    for (final controller in temp) {
      if (controller is T) {
        controller.dispose();
        _initialized.remove(controller);
      }
    }
  }

  @override
  bool updateShouldNotify(covariant ControlRoom oldWidget) {
    return oldWidget.controllers != controllers;
  }
}
