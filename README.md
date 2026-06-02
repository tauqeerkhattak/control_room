# Control Room

A lightweight and efficient state management solution for Flutter applications based on Streams and InheritedWidgets.

## Overview

Control Room provides a structured architecture for managing application state by decoupling business logic from the user interface. It leverages Streams for reactive updates and InheritedWidgets for high-performance dependency injection and scoping.

## Features

- **Decoupled Logic**: Business logic is encapsulated within `StateController` classes.
- **Reactive UI**: Automatic UI reconstruction via the `StateListener` widget.
- **Dependency Injection**: Seamless access to controllers across the widget tree using `ControlRoom`.
- **Resource Management**: Automatic initialization and disposal of controllers to prevent memory leaks.
- **Developer Friendly**: Minimal boilerplate and a clean, predictable API.

## Installation

Add `control_room` to your `pubspec.yaml` file:

```yaml
dependencies:
  control_room: ^0.0.1
```

## Core Concepts

### 1. StateController

The `StateController` is the base class for all business logic. It holds the current state and manages updates through a dedicated stream.

```dart
class CounterController extends StateController<int> {
  CounterController() : super(0);

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}
```

### 2. ControlRoom Widget

The `ControlRoom` widget serves as the provider for your controllers. It should be placed at the root of your application or at the top of a specific feature subtree.

```dart
void main() {
  runApp(
    ControlRoom(
      controllers: [
        () => CounterController(),
        () => SettingsController(),
      ],
      child: const MyApp(),
    ),
  );
}
```

### 3. StateListener

The `StateListener` widget listens to state changes from a specific `StateController` and rebuilds its subtree whenever the state is updated.

```dart
StateListener<CounterController, int>(
  builder: (context, count) {
    return Text(
      'Current Count: $count',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  },
)
```

### 4. Accessing Controllers

You can access any registered controller from the widget tree using the `ControlRoom.get<T>(context)` method.

```dart
final controller = ControlRoom.get<CounterController>(context);

// Trigger actions
controller.increment();
```

## Best Practices

- **Single Responsibility**: Each `StateController` should manage a specific piece of state or feature.
- **Granular Rebuilds**: Use `StateListener` as deep as possible in the widget tree to minimize the scope of rebuilds.
- **Method Calls**: Call controller methods from event handlers (e.g., `onPressed`) rather than during the `build` phase.

## Example

For a complete implementation including multi-page navigation and multiple controllers, please refer to the `example` directory in this repository.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
