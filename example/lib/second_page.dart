import 'package:control_room/control_room_plugin.dart';
import 'package:flutter/material.dart';

import './main.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ControlRoom.get<CounterController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Second Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            StateListener<CounterController, int>(
              builder: (_, count) {
                return Text(
                  '$count',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            const Divider(),
            StateListener<ToggleController, bool>(
              builder: (_, value) {
                return SwitchListTile(
                  value: value,
                  title: const Text('Toggle Controller Status'),
                  onChanged: (_) =>
                      ControlRoom.get<ToggleController>(context).toggle(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => controller.increment(),
            heroTag: 'inc2',
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => controller.decrement(),
            heroTag: 'dec2',
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class ToggleController extends StateController<bool> {
  ToggleController() : super(false);

  void toggle() {
    state = !state;
  }
}
