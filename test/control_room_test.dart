import 'package:control_room/control_room_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestController extends StateController<int> {
  TestController() : super(0);

  void increment() => state++;
}

class AnotherTestController extends StateController<String> {
  AnotherTestController() : super('initial');
}

class DisposableController extends StateController<int> {
  final VoidCallback onDispose;
  DisposableController(this.onDispose) : super(0);

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }
}

void main() {
  group('StateController Tests', () {
    test('initial state is set correctly', () {
      final controller = TestController();
      expect(controller.state, 0);
    });

    test('state updates correctly', () {
      final controller = TestController();
      controller.increment();
      expect(controller.state, 1);
    });

    test('state stream emits updates', () async {
      final controller = TestController();
      final states = <int>[];

      controller.increment();

      // Wait for the stream to emit
      await Future.delayed(Duration.zero);

      expect(states.contains(1), true);
    });
  });

  group('ControlRoom and StateListener Widget Tests', () {
    testWidgets(
      'ControlRoom provides controller and StateListener reacts to changes',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ControlRoom(
              controllers: [() => TestController()],
              child: Scaffold(
                body: StateListener<TestController, int>(
                  builder: (context, state) {
                    return Text('Count: $state');
                  },
                ),
                floatingActionButton: Builder(
                  builder: (context) {
                    return FloatingActionButton(
                      onPressed: () {
                        ControlRoom.get<TestController>(context).increment();
                      },
                      child: const Icon(Icons.add),
                    );
                  },
                ),
              ),
            ),
          ),
        );

        // Note: StateController adds initial state to stream in a post-frame callback
        await tester.pump();
        expect(find.text('Count: 0'), findsOneWidget);

        // Tap the button to increment
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();

        // Verify updated state
        expect(find.text('Count: 1'), findsOneWidget);
      },
    );

    testWidgets(
      'ControlRoom provides multiple controllers and maintains singletons',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: ControlRoom(
              controllers: [
                () => TestController(),
                () => AnotherTestController(),
              ],
              child: const SizedBox(),
            ),
          ),
        );

        final context = tester.element(find.byType(SizedBox));

        final controller1 = ControlRoom.get<TestController>(context);
        final controller2 = ControlRoom.get<AnotherTestController>(context);
        final controller1Again = ControlRoom.get<TestController>(context);

        expect(controller1, isA<TestController>());
        expect(controller2, isA<AnotherTestController>());
        expect(controller1, same(controller1Again));
      },
    );

    testWidgets('ControlRoom.get throws error if not found', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SizedBox())),
      );

      final BuildContext context = tester.element(find.byType(Scaffold));

      expect(() => ControlRoom.get<TestController>(context), throwsStateError);
    });

    testWidgets('ControlRoom.remove disposes the controller', (
      WidgetTester tester,
    ) async {
      bool disposed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ControlRoom(
            controllers: [() => DisposableController(() => disposed = true)],
            child: Builder(
              builder: (context) {
                ControlRoom.get<DisposableController>(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      ControlRoom.remove<DisposableController>();
      expect(disposed, true);
    });
  });
}
