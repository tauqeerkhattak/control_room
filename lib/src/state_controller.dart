import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../control_room.dart';

part 'state_listener.dart';

/// Base class for all state controllers in the Control Room architecture.
///
/// A [StateController] manages a piece of state of type [S]. It uses a
/// [StreamController] to broadcast state changes to listeners.
abstract class StateController<S> {
  /// Initializes the controller with an [initialState].
  ///
  /// The initial state is added to the stream in a post-frame callback
  /// to ensure that listeners are ready.
  StateController(S initialState) {
    _currentState = initialState;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _streamController.add(_currentState);
      onInit();
    });
  }

  final _streamController = StreamController<S>.broadcast();
  late S _currentState;

  /// Returns the current state.
  S get state => _currentState;

  /// Updates the state and notifies all listeners.
  set state(S newState) {
    _currentState = newState;
    _streamController.add(newState);
  }

  /// Called after the initial state is added to the stream.
  ///
  /// Override this method to perform initialization logic.
  @mustCallSuper
  void onInit() {
    log('INITIALIZING $runtimeType', name: 'CONTROL-ROOM');
  }

  /// Closes the state stream and performs cleanup.
  ///
  /// This is called automatically by [ControlRoom.remove] when the last
  /// listener is disposed.
  @mustCallSuper
  void dispose() {
    log('DISPOSING $runtimeType', name: 'CONTROL-ROOM');
    _streamController.close();
  }
}
