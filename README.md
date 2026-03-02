# Flutter Steps

The Flutter Steps package is a customizable widget that allows you to display a series of steps in a horizontal or vertical direction. This package can be used for creating step indicators for onboarding processes, progress tracking, or any other multi-step process in your Flutter application.

## Key Features

- **Flexible Direction**: Display steps horizontally or vertically based on your layout needs.
- **Customizable Appearance**: Adjust colors, fonts, and sizes for active and inactive steps, titles, and subtitles.
- **Step Line Options**: Show or hide the line connecting steps, with options for continuous or dashed lines.
- **Step Counters**: Optionally display counters for each step.
- **Interactive**: Supports showing subtitles and custom leading elements for active and inactive steps.
- **Navigation**: Built-in support for next/back navigation via `FlutterStepsController`, `currentStep` property, and `onStepTapped` callback.

<br/>
<p align="left">
  <img src="https://github.com/elrizwiraswara/flutter_steps/raw/main/1.png" alt="Image 1" height="500" style="margin-right: 10px;">
  <img src="https://github.com/elrizwiraswara/flutter_steps/raw/main/2.png" alt="Image 2" height="500" style="margin-right: 10px;">
  <img src="https://github.com/elrizwiraswara/flutter_steps/raw/main/3.png" alt="Image 2" height="500" style="margin-right: 10px;">
</p>

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter_steps: ^2.0.0
```

Then run `flutter pub get` to install the package.

## Usage

### Basic Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_steps/flutter_steps.dart';

List<Steps> basicSteps = [
  ...List.generate(
    5,
    (i) => Steps(
      title: 'Title ${i + 1}',
      subtitle: 'Subtitle',
      isActive: i < 2 ? true : false,
    ),
  )
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FlutterSteps(
          steps: basicSteps,
          titleFontSize: 12,
          showSubtitle: false,
        ),
      ),
    );
  }
}
```

### Navigation with Controller

Use `FlutterStepsController` for programmatic next/back navigation:

```dart
class MyStepperPage extends StatefulWidget {
  @override
  State<MyStepperPage> createState() => _MyStepperPageState();
}

class _MyStepperPageState extends State<MyStepperPage> {
  final _controller = FlutterStepsController(initialStep: 0);

  final steps = List.generate(
    5,
    (i) => Steps(title: 'Step ${i + 1}'),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlutterSteps(
          steps: steps,
          controller: _controller,
          onStepChanged: (step) => print('Now at step $step'),
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => _controller.back(),
              child: Text('Back'),
            ),
            ElevatedButton(
              onPressed: () => _controller.next(steps.length),
              child: Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}
```

### Navigation with currentStep

For simpler cases without a controller:

```dart
int _currentStep = 0;

FlutterSteps(
  steps: mySteps,
  currentStep: _currentStep, // All steps <= _currentStep are active
  onStepTapped: (index) {
    setState(() => _currentStep = index);
  },
)
```

### Tap Navigation

Make steps tappable by providing `onStepTapped`:

```dart
FlutterSteps(
  steps: mySteps,
  currentStep: _currentStep,
  onStepTapped: (index) {
    setState(() => _currentStep = index);
  },
)
```

## API Reference

### FlutterSteps

| Property | Type | Default | Description |
|---|---|---|---|
| `steps` | `List<Steps>` | required | The list of steps to display |
| `direction` | `Axis` | `Axis.horizontal` | Horizontal or vertical layout |
| `controller` | `FlutterStepsController?` | `null` | Controller for programmatic navigation |
| `currentStep` | `int?` | `null` | Current step index (all steps <= index are active) |
| `onStepTapped` | `ValueChanged<int>?` | `null` | Callback when a step is tapped |
| `onStepChanged` | `ValueChanged<int>?` | `null` | Callback when controller step changes |
| `showCounter` | `bool` | `true` | Show step numbers |
| `showSubtitle` | `bool` | `true` | Show subtitles |
| `showStepLine` | `bool` | `true` | Show connecting lines |
| `isStepLineDashed` | `bool` | `false` | Use dashed lines |
| `isStepLineContinuous` | `bool` | `true` | Continuous line connections |
| `hideInactiveLeading` | `bool` | `false` | Hide leading for inactive steps |
| `leadingSize` | `double` | `32` | Size of leading indicator |
| `leadingSizeFactor` | `double` | `2` | Size multiplier for leading |

### FlutterStepsController

| Method | Description |
|---|---|
| `next(int totalSteps)` | Move to the next step |
| `back()` | Move to the previous step |
| `jumpTo(int step, int totalSteps)` | Jump to a specific step |
| `currentStep` | Get the current step index |
| `isFirstStep` | Whether at the first step |
| `isLastStep(int totalSteps)` | Whether at the last step |

## Example
Check out the [example](example) directory for a complete sample app demonstrating the use of the `flutter_steps` package.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

<a href="https://trakteer.id/elrizwiraswara/tip" target="_blank"><img id="wse-buttons-preview" src="https://cdn.trakteer.id/images/embed/trbtn-red-6.png?date=18-11-2023" height="40" style="border:0px;height:40px;margin-top:14px" alt="Trakteer Saya"></a>
