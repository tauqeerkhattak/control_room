import 'dart:developer';

import 'package:control_room/control_room.dart';
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
            StateSelector<ThemeController, ThemeMode>(
              selector: (controller) => controller.state.themeMode,
              builder: (_, value) {
                log('Toggle Dark Mode Rebuilt!');
                return SwitchListTile(
                  value: value.isDark,
                  title: const Text('Toggle Dark Mode'),
                  onChanged: (_) {
                    final themeMode = value.isDark
                        ? ThemeMode.light
                        : ThemeMode.dark;
                    ControlRoom.get<ThemeController>(
                      context,
                    ).changeThemeMode(themeMode);
                  },
                );
              },
            ),
            const Divider(),
            StateSelector<ThemeController, bool>(
              selector: (controller) => controller.state.useMaterial3,
              builder: (_, value) {
                log('Use Material 3 Rebuilt!');
                return SwitchListTile(
                  value: value,
                  title: const Text('Toggle Material3'),
                  onChanged: (_) {
                    ControlRoom.get<ThemeController>(context).toggleMaterial3();
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: .end,
        children: [
          FloatingActionButton(
            onPressed: () => controller.increment(),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () => controller.decrement(),
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class ThemeController extends StateController<ThemeState> {
  ThemeController() : super(const ThemeState());

  void toggleMaterial3() {
    state = state.copyWith(useMaterial3: !state.useMaterial3);
  }

  void changeThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
  }
}

class ThemeState {
  final ThemeMode themeMode;
  final bool useMaterial3;

  const ThemeState({this.themeMode = ThemeMode.dark, this.useMaterial3 = true});

  ThemeState copyWith({ThemeMode? themeMode, bool? useMaterial3}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
    );
  }
}
