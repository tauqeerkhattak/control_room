import 'package:control_room/control_room.dart';
import 'package:flutter/material.dart';

import 'second_page.dart';

void main() {
  runApp(
    ControlRoom(
      controllers: {
        CounterController: () => CounterController(),
        ToggleController: () => ToggleController(),
      },
      child: const MyApp(),
    ),
  );
}

class CounterController extends StateController<int> {
  CounterController() : super(0);

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control Room Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Control Room Counter'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final controller = ControlRoom.get<CounterController>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            StateListener<CounterController, int>(
              builder: (context, count) {
                return Text(
                  '$count',
                  style: Theme.of(context).textTheme.headlineMedium,
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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SecondPage()),
            ),
            tooltip: 'Next page',
            child: const Icon(Icons.keyboard_double_arrow_right),
          ),
          const SizedBox(height: 8),
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
