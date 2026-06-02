part of 'state_controller.dart';

/// A widget that listens to state changes in a [StateController].
///
/// [StateListener] rebuilds its subtree whenever the state of the
/// [StateController] of type [T] changes.
///
/// The [builder] function is called with the current state [S].
class StateListener<T extends StateController<S>, S> extends StatefulWidget {
  /// Creates a [StateListener].
  ///
  /// The [builder] is required and defines the UI to be built based on
  /// the state.
  final Widget Function(BuildContext, S) builder;

  /// Const constructor for [StateListener].
  const StateListener({super.key, required this.builder});

  @override
  State<StateListener> createState() => _StateListenerState<T, S>();
}

class _StateListenerState<T extends StateController<S>, S>
    extends State<StateListener<T, S>> {
  late final controller = ControlRoom.get<T>(context);

  @override
  void dispose() {
    if (!controller._streamController.hasListener) {
      ControlRoom.remove<T>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      stream: controller._streamController.stream,
      builder: (context, _) {
        return widget.builder(context, controller.state);
      },
    );
  }
}
