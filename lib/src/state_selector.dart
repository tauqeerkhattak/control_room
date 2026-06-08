part of 'state_controller.dart';

/// A widget that listens to specific state changes in a [StateController].
///
/// [StateSelector] rebuilds its subtree only when the value returned by
/// the [selector] function changes.
///
/// The [builder] function is called with the current selected value [V].
class StateSelector<T extends StateController, V> extends StatefulWidget {
  /// A function that selects a value [V] from the [StateController] [T].
  final V Function(T) selector;

  /// The [builder] is required and defines the UI to be built based on
  /// the selected value.
  final Widget Function(BuildContext, V) builder;

  /// Const constructor for [StateSelector].
  const StateSelector({
    super.key,
    required this.selector,
    required this.builder,
  });

  @override
  State<StateSelector<T, V>> createState() => _StateSelectorState<T, V>();
}

class _StateSelectorState<T extends StateController, V>
    extends State<StateSelector<T, V>> {
  late final T controller = ControlRoom.get<T>(context);

  // Create a distinct stream for the selected value to avoid unnecessary rebuilds.
  late final Stream<V> _stream = controller.stream
      .map((state) => widget.selector(controller))
      .distinct();

  @override
  void dispose() {
    // Follows the same disposal logic as StateListener
    if (!controller._streamController.hasListener) {
      ControlRoom.remove<T>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<V>(
      initialData: widget.selector(controller),
      stream: _stream,
      builder: (context, snapshot) {
        return widget.builder(context, snapshot.data as V);
      },
    );
  }
}
