import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_steps/flutter_steps.dart';

/// Wraps a widget in MaterialApp for testing.
Widget buildTestWidget(Widget child, {Size size = const Size(800, 600)}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: child,
      ),
    ),
  );
}

List<Steps> createBasicSteps({int count = 3, int activeCount = 1}) {
  return List.generate(
    count,
    (i) => Steps(
      title: 'Step ${i + 1}',
      subtitle: 'Subtitle ${i + 1}',
      isActive: i < activeCount,
    ),
  );
}

void main() {
  group('Steps model', () {
    test('creates with default values', () {
      final step = Steps();
      expect(step.title, isNull);
      expect(step.subtitle, isNull);
      expect(step.leading, isNull);
      expect(step.isActive, false);
    });

    test('creates with custom values', () {
      final step = Steps(
        title: 'Test',
        subtitle: 'Sub',
        isActive: true,
        leading: const Icon(Icons.check),
      );
      expect(step.title, 'Test');
      expect(step.subtitle, 'Sub');
      expect(step.isActive, true);
      expect(step.leading, isA<Icon>());
    });
  });

  group('FlutterStepsController', () {
    late FlutterStepsController controller;

    setUp(() {
      controller = FlutterStepsController(initialStep: 0);
    });

    tearDown(() {
      controller.dispose();
    });

    test('initializes with default step 0', () {
      final c = FlutterStepsController();
      expect(c.currentStep, 0);
      c.dispose();
    });

    test('initializes with custom initial step', () {
      final c = FlutterStepsController(initialStep: 2);
      expect(c.currentStep, 2);
      c.dispose();
    });

    test('next() increments current step', () {
      controller.next(5);
      expect(controller.currentStep, 1);
    });

    test('next() does not exceed total steps', () {
      controller = FlutterStepsController(initialStep: 4);
      controller.next(5);
      expect(controller.currentStep, 4);
    });

    test('back() decrements current step', () {
      controller = FlutterStepsController(initialStep: 2);
      controller.back();
      expect(controller.currentStep, 1);
    });

    test('back() does not go below 0', () {
      controller.back();
      expect(controller.currentStep, 0);
    });

    test('jumpTo() sets current step', () {
      controller.jumpTo(3, 5);
      expect(controller.currentStep, 3);
    });

    test('jumpTo() ignores out-of-bounds values', () {
      controller.jumpTo(-1, 5);
      expect(controller.currentStep, 0);

      controller.jumpTo(5, 5);
      expect(controller.currentStep, 0);
    });

    test('jumpTo() ignores same step', () {
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller.jumpTo(0, 5);
      expect(notifyCount, 0);
    });

    test('isFirstStep returns true when at step 0', () {
      expect(controller.isFirstStep, true);
      controller.next(5);
      expect(controller.isFirstStep, false);
    });

    test('isLastStep returns true when at last step', () {
      expect(controller.isLastStep(5), false);
      controller = FlutterStepsController(initialStep: 4);
      expect(controller.isLastStep(5), true);
    });

    test('notifies listeners on next()', () {
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller.next(5);
      expect(notifyCount, 1);
    });

    test('notifies listeners on back()', () {
      controller = FlutterStepsController(initialStep: 2);
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller.back();
      expect(notifyCount, 1);
    });

    test('notifies listeners on jumpTo()', () {
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller.jumpTo(3, 5);
      expect(notifyCount, 1);
    });

    test('does not notify when next() at boundary', () {
      controller = FlutterStepsController(initialStep: 4);
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller.next(5);
      expect(notifyCount, 0);
    });

    test('does not notify when back() at boundary', () {
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller.back();
      expect(notifyCount, 0);
    });
  });

  group('FlutterSteps widget - horizontal', () {
    testWidgets('renders all step titles', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(steps: createBasicSteps()),
      ));

      expect(find.text('Step 1'), findsOneWidget);
      expect(find.text('Step 2'), findsOneWidget);
      expect(find.text('Step 3'), findsOneWidget);
    });

    testWidgets('renders subtitles when showSubtitle is true', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(steps: createBasicSteps()),
      ));

      expect(find.text('Subtitle 1'), findsOneWidget);
      expect(find.text('Subtitle 2'), findsOneWidget);
      expect(find.text('Subtitle 3'), findsOneWidget);
    });

    testWidgets('hides subtitles when showSubtitle is false', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(steps: createBasicSteps(), showSubtitle: false),
      ));

      expect(find.text('Subtitle 1'), findsNothing);
      expect(find.text('Subtitle 2'), findsNothing);
    });

    testWidgets('shows step counter numbers', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(steps: createBasicSteps()),
      ));

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('hides counter when showCounter is false', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(steps: createBasicSteps(), showCounter: false),
      ));

      expect(find.text('1'), findsNothing);
      expect(find.text('2'), findsNothing);
      expect(find.text('3'), findsNothing);
    });

    testWidgets('renders with custom leading widgets', (tester) async {
      final steps = [
        Steps(title: 'A', leading: const Icon(Icons.check)),
        Steps(title: 'B', leading: const Icon(Icons.close)),
      ];

      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(steps: steps),
      ));

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('renders without step titles', (tester) async {
      final steps = [
        Steps(isActive: true),
        Steps(),
      ];

      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(steps: steps),
      ));

      // Should render without errors
      expect(find.byType(FlutterSteps), findsOneWidget);
    });
  });

  group('FlutterSteps widget - vertical', () {
    testWidgets('renders in vertical direction', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(),
          direction: Axis.vertical,
        ),
      ));

      expect(find.text('Step 1'), findsOneWidget);
      expect(find.text('Step 2'), findsOneWidget);
      expect(find.text('Step 3'), findsOneWidget);
    });

    testWidgets('renders subtitles in vertical mode', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(),
          direction: Axis.vertical,
        ),
      ));

      expect(find.text('Subtitle 1'), findsOneWidget);
    });
  });

  group('FlutterSteps widget - step line options', () {
    testWidgets('hides step line when showStepLine is false', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(),
          showStepLine: false,
        ),
      ));

      expect(find.byType(FlutterSteps), findsOneWidget);
    });

    testWidgets('renders with dashed line', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(),
          isStepLineDashed: true,
        ),
      ));

      expect(find.byType(FlutterSteps), findsOneWidget);
    });

    testWidgets('renders with non-continuous step line', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(),
          isStepLineContinuous: false,
        ),
      ));

      expect(find.byType(FlutterSteps), findsOneWidget);
    });
  });

  group('FlutterSteps widget - currentStep property', () {
    testWidgets('currentStep overrides Steps.isActive', (tester) async {
      // All steps have isActive: false, but currentStep=1 should make
      // steps 0 and 1 active
      final steps = [
        Steps(title: 'Step 1', isActive: false),
        Steps(title: 'Step 2', isActive: false),
        Steps(title: 'Step 3', isActive: false),
      ];

      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(steps: steps, currentStep: 1),
      ));

      expect(find.byType(FlutterSteps), findsOneWidget);
    });

    testWidgets('rebuilds when currentStep changes', (tester) async {
      int currentStep = 0;

      await tester.pumpWidget(buildTestWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                Expanded(
                  child: FlutterSteps(
                    steps: createBasicSteps(activeCount: 0),
                    currentStep: currentStep,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => currentStep = 2),
                  child: const Text('Go to 2'),
                ),
              ],
            );
          },
        ),
      ));

      await tester.tap(find.text('Go to 2'));
      await tester.pump();

      expect(find.byType(FlutterSteps), findsOneWidget);
    });
  });

  group('FlutterSteps widget - controller', () {
    testWidgets('controller determines active steps', (tester) async {
      final controller = FlutterStepsController(initialStep: 1);

      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(activeCount: 0),
          controller: controller,
        ),
      ));

      expect(find.byType(FlutterSteps), findsOneWidget);

      controller.dispose();
    });

    testWidgets('widget rebuilds when controller changes', (tester) async {
      final controller = FlutterStepsController(initialStep: 0);

      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(count: 5, activeCount: 0),
          controller: controller,
        ),
      ));

      controller.next(5);
      await tester.pump();

      expect(controller.currentStep, 1);

      controller.dispose();
    });

    testWidgets('onStepChanged fires when controller navigates',
        (tester) async {
      final controller = FlutterStepsController(initialStep: 0);
      int? changedTo;

      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(count: 5, activeCount: 0),
          controller: controller,
          onStepChanged: (step) => changedTo = step,
        ),
      ));

      controller.next(5);
      await tester.pump();

      expect(changedTo, 1);

      controller.back();
      await tester.pump();

      expect(changedTo, 0);

      controller.dispose();
    });

    testWidgets('controller takes priority over currentStep', (tester) async {
      final controller = FlutterStepsController(initialStep: 0);

      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(count: 5, activeCount: 0),
          controller: controller,
          currentStep: 3, // Should be ignored
        ),
      ));

      // Controller is at 0, so only step 0 should be active
      // (controller priority over currentStep)
      expect(controller.currentStep, 0);

      controller.dispose();
    });

    testWidgets('disposes listener when widget is removed', (tester) async {
      final controller = FlutterStepsController(initialStep: 0);

      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(),
          controller: controller,
        ),
      ));

      // Remove the widget
      await tester.pumpWidget(buildTestWidget(const SizedBox()));

      // Should not throw when controller changes after widget disposal
      controller.next(3);
      expect(controller.currentStep, 1);

      controller.dispose();
    });

    testWidgets('handles controller swap via didUpdateWidget', (tester) async {
      final controller1 = FlutterStepsController(initialStep: 0);
      final controller2 = FlutterStepsController(initialStep: 2);

      FlutterStepsController activeController = controller1;

      await tester.pumpWidget(buildTestWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                Expanded(
                  child: FlutterSteps(
                    steps: createBasicSteps(count: 5, activeCount: 0),
                    controller: activeController,
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      setState(() => activeController = controller2),
                  child: const Text('Swap'),
                ),
              ],
            );
          },
        ),
      ));

      await tester.tap(find.text('Swap'));
      await tester.pump();

      // After swap, controller2 is active
      expect(find.byType(FlutterSteps), findsOneWidget);

      controller1.dispose();
      controller2.dispose();
    });
  });

  group('FlutterSteps widget - onStepTapped', () {
    testWidgets('onStepTapped fires when step is tapped', (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(),
          onStepTapped: (index) => tappedIndex = index,
        ),
      ));

      // Tap on the first step counter text
      await tester.tap(find.text('1'));
      expect(tappedIndex, 0);

      await tester.tap(find.text('2'));
      expect(tappedIndex, 1);

      await tester.tap(find.text('3'));
      expect(tappedIndex, 2);
    });

    testWidgets('steps are not tappable without onStepTapped', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(steps: createBasicSteps()),
      ));

      // GestureDetector should not be wrapping step indicators
      // The step counter text should exist but not be tappable via GestureDetector
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('onStepTapped works in vertical mode', (tester) async {
      int? tappedIndex;

      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(),
          direction: Axis.vertical,
          onStepTapped: (index) => tappedIndex = index,
        ),
      ));

      await tester.tap(find.text('1'));
      expect(tappedIndex, 0);
    });
  });

  group('FlutterSteps widget - customization', () {
    testWidgets('applies custom colors', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(),
          activeColor: Colors.red,
          inactiveColor: Colors.grey,
          titleActiveColor: Colors.red,
          titleInactiveColor: Colors.grey,
          subtitleActiveColor: Colors.redAccent,
          subtitleInactiveColor: Colors.grey,
          activeStepLineColor: Colors.red,
          inactiveStepLineColor: Colors.grey,
        ),
      ));

      expect(find.byType(FlutterSteps), findsOneWidget);
    });

    testWidgets('applies custom sizes', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(),
          leadingSize: 48,
          leadingSizeFactor: 1.5,
          titleFontSize: 14,
          subtitleFontSize: 10,
          stepLineHeight: 3,
          stepLineWidth: 3,
        ),
      ));

      expect(find.byType(FlutterSteps), findsOneWidget);
    });

    testWidgets('applies custom text styles', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(),
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          subtitleStyle: const TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ));

      expect(find.byType(FlutterSteps), findsOneWidget);
    });

    testWidgets('hideInactiveLeading hides inactive custom leadings',
        (tester) async {
      final steps = [
        Steps(
          title: 'A',
          isActive: true,
          leading: const Icon(Icons.check),
        ),
        Steps(
          title: 'B',
          isActive: false,
          leading: const Icon(Icons.close),
        ),
      ];

      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: steps,
          hideInactiveLeading: true,
        ),
      ));

      // Active step's leading should be visible
      expect(find.byIcon(Icons.check), findsOneWidget);
      // Inactive step's leading should be hidden (replaced with circle)
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('renders dashed line with custom dashFillRate', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(),
          isStepLineDashed: true,
          dashFillRate: 0.5,
        ),
      ));

      expect(find.byType(FlutterSteps), findsOneWidget);
    });

    testWidgets('renders with custom stepLineRadius', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(),
          isStepLineDashed: true,
          stepLineRadius: 0,
        ),
      ));

      expect(find.byType(FlutterSteps), findsOneWidget);
    });
  });

  group('FlutterSteps widget - edge cases', () {
    testWidgets('renders with single step', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: [Steps(title: 'Only', isActive: true)],
        ),
      ));

      expect(find.text('Only'), findsOneWidget);
    });

    testWidgets('renders with many steps', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(steps: createBasicSteps(count: 10, activeCount: 5)),
      ));

      expect(find.byType(FlutterSteps), findsOneWidget);
    });

    testWidgets('renders vertical with dashed non-continuous line',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(),
          direction: Axis.vertical,
          isStepLineDashed: true,
          isStepLineContinuous: false,
        ),
      ));

      expect(find.byType(FlutterSteps), findsOneWidget);
    });

    testWidgets('renders vertical with dashed continuous line',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        FlutterSteps(
          steps: createBasicSteps(),
          direction: Axis.vertical,
          isStepLineDashed: true,
          isStepLineContinuous: true,
        ),
      ));

      expect(find.byType(FlutterSteps), findsOneWidget);
    });
  });
}
