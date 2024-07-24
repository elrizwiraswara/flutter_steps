import 'package:app_image/app_image.dart';
import 'package:example/sample_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_steps/flutter_steps.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const FlutterStepsSamplesView(),
    );
  }
}

class FlutterStepsSamplesView extends StatefulWidget {
  const FlutterStepsSamplesView({super.key});

  @override
  State<FlutterStepsSamplesView> createState() =>
      _FlutterStepsSamplesViewState();
}

class _FlutterStepsSamplesViewState extends State<FlutterStepsSamplesView> {
  List<Steps> basicSteps = [
    ...List.generate(
      5,
      (i) => Steps(
        title: 'Title ${i + 1}',
        subtitle: DateFormat('dd/MM/y').format(DateTime.now()),
        isActive: i < 2 ? true : false,
      ),
    )
  ];

  List<Steps> customSteps0 = [
    ...List.generate(
      5,
      (i) => Steps(
        title: 'Title ${i + 1}',
        subtitle: DateFormat('dd/MM/y').format(DateTime.now()),
        isActive: i < 2 ? true : false,
        leading: Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    )
  ];

  List<Steps> customSteps1 = [
    ...List.generate(
      5,
      (i) => Steps(
        title: 'Title ${i + 1}',
        subtitle: DateFormat('dd/MM/y').format(DateTime.now()),
        isActive: i < 2 ? true : false,
        leading: i == 0
            ? const Icon(
                Icons.location_on,
                color: Colors.green,
                size: 32,
              )
            : null,
      ),
    )
  ];

  List<Steps> customSteps2 = [
    Steps(
      title: 'Title 1',
      subtitle: DateFormat('dd/MM/y').format(DateTime.now()),
      isActive: true,
      leading: const Icon(
        Icons.location_on,
        color: Colors.blue,
        size: 32,
      ),
    ),
    Steps(
      title: 'Title 2',
      subtitle: DateFormat('dd/MM/y').format(DateTime.now()),
      isActive: true,
      leading: const Icon(
        Icons.person,
        color: Colors.blue,
        size: 32,
      ),
    ),
    Steps(
      title: 'Title 3',
      subtitle: DateFormat('dd/MM/y').format(DateTime.now()),
      isActive: false,
      leading: const Icon(
        Icons.local_shipping,
        color: Colors.black12,
        size: 32,
      ),
    ),
    Steps(
      title: 'Title 4',
      subtitle: DateFormat('dd/MM/y').format(DateTime.now()),
      isActive: false,
      leading: const Icon(
        Icons.house,
        color: Colors.black12,
        size: 32,
      ),
    ),
    Steps(
      title: 'Title 5',
      subtitle: DateFormat('dd/MM/y').format(DateTime.now()),
      isActive: false,
      leading: const Icon(
        Icons.card_giftcard_rounded,
        color: Colors.black12,
        size: 32,
      ),
    ),
  ];

  List<Steps> customSteps3 = [
    ...List.generate(
      5,
      (i) => Steps(
        title: 'Title ${i + 1}',
        subtitle: DateFormat('dd/MM/y').format(DateTime.now()),
        isActive: i < 2 ? true : false,
        leading: AppImage(
          image: randomImage,
          border: Border.all(
            width: 2,
            color: i < 2 ? Colors.blue : Colors.black12,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Steps Samples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            defaultHorizontalSteps(),
            defaultHorizontalStepsWithSubtitle(),
            defaultHorizontalStepsWithUncontinuousStepLine(),
            defaultHorizontalStepsWithoutStepline(),
            defaultHorizontalStepsCustomSize(),
            defaultHorizontalStepsWithDashedLine(),
            customHorizontalStepsLine(),
            customLeadingsAndStylesHorizontalStepsLineCustom(),
            defaultVerticalSteps(),
            defaultVerticalStepsCustomFirstLeading(),
            verticalStepsCustomLeadings(),
            verticalStepsCustomLeadingsAndStyles(),
          ],
        ),
      ),
    );
  }

  Widget defaultHorizontalSteps() {
    return SampleWrapper(
      title: 'Default Horizontal Steps',
      widget: FlutterSteps(
        steps: basicSteps,
        titleFontSize: 12,
        showSubtitle: false,
      ),
    );
  }

  Widget defaultHorizontalStepsWithSubtitle() {
    return SampleWrapper(
      title: 'Default Horizontal Steps With Subtitle',
      widget: FlutterSteps(
        steps: basicSteps,
        titleFontSize: 12,
        subtitleFontSize: 8,
      ),
    );
  }

  Widget defaultHorizontalStepsWithUncontinuousStepLine() {
    return SampleWrapper(
      title: 'Default Horizontal Steps With Uncontinuous Step Line',
      widget: FlutterSteps(
        steps: basicSteps,
        titleFontSize: 12,
        subtitleFontSize: 8,
        isStepLineContinuous: false,
      ),
    );
  }

  Widget defaultHorizontalStepsWithoutStepline() {
    return SampleWrapper(
      title: 'Default Horizontal Steps Without Step Line',
      widget: FlutterSteps(
        steps: basicSteps,
        titleFontSize: 12,
        subtitleFontSize: 8,
        showStepLine: false,
      ),
    );
  }

  Widget defaultHorizontalStepsCustomSize() {
    return SampleWrapper(
      title: 'Default Horizontal Steps With Custom Size',
      widget: FlutterSteps(
        steps: basicSteps,
        direction: Axis.horizontal,
        titleFontSize: 10,
        subtitleFontSize: 6,
        leadingSize: 24,
        stepLineHeight: 1,
      ),
    );
  }

  Widget defaultHorizontalStepsWithDashedLine() {
    return SampleWrapper(
      title: 'Default Horizontal Steps With Dashed Line',
      widget: FlutterSteps(
        steps: basicSteps,
        titleFontSize: 12,
        isStepLineDashed: true,
        dashFillRate: 0.5,
        subtitleFontSize: 6,
        leadingSizeFactor: 1.5,
      ),
    );
  }

  Widget customHorizontalStepsLine() {
    return SampleWrapper(
      title: 'Custom Horizontal Steps Line',
      widget: FlutterSteps(
        steps: customSteps0,
        showSubtitle: false,
        hideInactiveLeading: true,
        titleStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
      ),
    );
  }

  Widget customLeadingsAndStylesHorizontalStepsLineCustom() {
    return SampleWrapper(
      title: 'Custom Leadings & Styles Horizontal Steps',
      widget: FlutterSteps(
        steps: customSteps3,
        direction: Axis.horizontal,
        leadingSize: 40,
        leadingSizeFactor: 1,
        titleActiveColor: Theme.of(context).colorScheme.primary,
        subtitleActiveColor: Theme.of(context).colorScheme.primary,
        activeStepLineColor: Theme.of(context).colorScheme.primary,
        titleFontSize: 12,
        subtitleFontSize: 8,
        showSubtitle: false,
      ),
    );
  }

  Widget defaultVerticalSteps() {
    return SampleWrapper(
      title: 'Default Vertical Steps',
      widget: SizedBox(
        height: 400,
        child: FlutterSteps(
          steps: basicSteps,
          direction: Axis.vertical,
        ),
      ),
    );
  }

  Widget defaultVerticalStepsCustomFirstLeading() {
    return SampleWrapper(
      title: 'Default Vertical Steps Custom First Leading',
      widget: SizedBox(
        height: 400,
        child: FlutterSteps(
          steps: customSteps1,
          direction: Axis.vertical,
        ),
      ),
    );
  }

  Widget verticalStepsCustomLeadings() {
    return SampleWrapper(
      title: 'Default Vertical Steps Custom Leadings',
      widget: SizedBox(
        height: 400,
        child: FlutterSteps(
          steps: customSteps2,
          direction: Axis.vertical,
          isStepLineContinuous: false,
        ),
      ),
    );
  }

  Widget verticalStepsCustomLeadingsAndStyles() {
    return SampleWrapper(
      title: 'Vertical Steps Custom Leadings & Styles',
      widget: SizedBox(
        height: 400,
        child: FlutterSteps(
          steps: customSteps2,
          direction: Axis.vertical,
          titleActiveColor: Theme.of(context).colorScheme.primary,
          activeStepLineColor: Theme.of(context).colorScheme.primary,
          dashFillRate: 1,
          stepLineRadius: 0,
          isStepLineContinuous: false,
        ),
      ),
    );
  }
}
