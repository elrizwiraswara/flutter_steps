import 'package:flutter/material.dart';
import 'package:flutter_steps/src/flutter_steps_controller.dart';
import 'package:flutter_steps/src/steps.dart';

/// A widget that displays a series of steps with various customization options.
///
/// Supports both horizontal and vertical layouts, with optional navigation
/// via [controller], [currentStep], and [onStepTapped].
class FlutterSteps extends StatefulWidget {
  /// The list of steps to display.
  final List<Steps> steps;

  /// The direction of the steps, either horizontal or vertical.
  final Axis direction;

  /// How the steps are aligned along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// Whether to show a counter for the steps.
  final bool showCounter;

  /// Whether to show subtitles for the steps.
  final bool showSubtitle;

  /// Whether to show a line connecting the steps.
  final bool showStepLine;

  /// Whether to hide the leading element for inactive steps.
  final bool hideInactiveLeading;

  /// Whether the step line should be dashed.
  final bool isStepLineDashed;

  /// Whether the step line should be continuous.
  final bool isStepLineContinuous;

  /// The color for active steps.
  final Color? activeColor;

  /// The color for inactive steps.
  final Color? inactiveColor;

  /// The color for the title of active steps.
  final Color? titleActiveColor;

  /// The color for the title of inactive steps.
  final Color? titleInactiveColor;

  /// The color for the subtitle of active steps.
  final Color? subtitleActiveColor;

  /// The color for the subtitle of inactive steps.
  final Color? subtitleInactiveColor;

  /// The color for the step line of active steps.
  final Color? activeStepLineColor;

  /// The color for the step line of inactive steps.
  final Color? inactiveStepLineColor;

  /// The size of the leading element.
  final double leadingSize;

  /// The size factor for the leading element.
  final double leadingSizeFactor;

  /// The font size for the title.
  final double? titleFontSize;

  /// The font size for the subtitle.
  final double? subtitleFontSize;

  /// The text style for the title.
  final TextStyle? titleStyle;

  /// The text style for the subtitle.
  final TextStyle? subtitleStyle;

  /// The height of the step line.
  final double stepLineHeight;

  /// The width of the step line.
  final double stepLineWidth;

  /// The fill rate for the dash pattern of the step line.
  final double dashFillRate;

  /// The radius for the step line's corners.
  final double stepLineRadius;

  /// A controller for programmatic navigation between steps.
  ///
  /// When provided, the controller's [FlutterStepsController.currentStep]
  /// determines which steps are active (all steps <= currentStep).
  /// This overrides individual [Steps.isActive] flags.
  final FlutterStepsController? controller;

  /// The current step index. All steps with index <= [currentStep] are active.
  ///
  /// This is a simpler alternative to [controller] for cases where you don't
  /// need programmatic next/back methods.
  /// Overrides individual [Steps.isActive] flags.
  /// If [controller] is also provided, [controller] takes priority.
  final int? currentStep;

  /// Called when a step indicator is tapped.
  ///
  /// The callback receives the index of the tapped step.
  /// Step indicators become tappable only when this callback is provided.
  final ValueChanged<int>? onStepTapped;

  /// Called when the current step changes via the [controller].
  final ValueChanged<int>? onStepChanged;

  /// Creates a [FlutterSteps] widget.
  const FlutterSteps({
    super.key,
    required this.steps,
    this.direction = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.showCounter = true,
    this.showSubtitle = true,
    this.hideInactiveLeading = false,
    this.isStepLineDashed = false,
    this.showStepLine = true,
    this.isStepLineContinuous = true,
    this.activeColor,
    this.inactiveColor,
    this.titleActiveColor,
    this.titleInactiveColor,
    this.subtitleActiveColor,
    this.subtitleInactiveColor,
    this.activeStepLineColor,
    this.inactiveStepLineColor,
    this.leadingSize = 32,
    this.leadingSizeFactor = 2,
    this.titleFontSize,
    this.subtitleFontSize,
    this.titleStyle,
    this.subtitleStyle,
    this.stepLineHeight = 2,
    this.stepLineWidth = 2,
    this.dashFillRate = 0.7,
    this.stepLineRadius = 100,
    this.controller,
    this.currentStep,
    this.onStepTapped,
    this.onStepChanged,
  });

  @override
  State<FlutterSteps> createState() => _FlutterStepsState();
}

class _FlutterStepsState extends State<FlutterSteps> {
  late Color _activeColor;
  late Color _inactiveColor;
  late Color _titleActiveColor;
  late Color _titleInactiveColor;
  late Color _subtitleActiveColor;
  late Color _subtitleInactiveColor;
  late Color _activeStepLineColor;
  late Color _inactiveStepLineColor;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant FlutterSteps oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
    widget.onStepChanged?.call(widget.controller!.currentStep);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveColors();
  }

  void _resolveColors() {
    final colorScheme = Theme.of(context).colorScheme;
    _activeColor = widget.activeColor ?? colorScheme.primary;
    _inactiveColor = widget.inactiveColor ?? colorScheme.outline;
    _titleActiveColor = widget.titleActiveColor ?? colorScheme.primary;
    _titleInactiveColor = widget.titleInactiveColor ?? colorScheme.outline;
    _subtitleActiveColor = widget.subtitleActiveColor ?? colorScheme.secondary;
    _subtitleInactiveColor =
        widget.subtitleInactiveColor ?? colorScheme.outline;
    _activeStepLineColor = widget.activeStepLineColor ?? colorScheme.primary;
    _inactiveStepLineColor =
        widget.inactiveStepLineColor ?? colorScheme.outline;
  }

  /// Determines if a step at [index] is active.
  ///
  /// Priority: controller > currentStep property > Steps.isActive flag.
  bool _isStepActive(int index) {
    if (widget.controller != null) {
      return index <= widget.controller!.currentStep;
    }
    if (widget.currentStep != null) {
      return index <= widget.currentStep!;
    }
    return widget.steps[index].isActive;
  }

  @override
  Widget build(BuildContext context) {
    // Re-resolve colors if widget properties changed
    _resolveColors();

    return widget.direction == Axis.horizontal
        ? _horizontalSteps()
        : _verticalSteps();
  }

  Widget _horizontalSteps() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        widget.steps.length,
        (i) => i == (widget.steps.length - 1)
            ? _stepWidgetHorizontal(widget.steps[i], i)
            : Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _stepWidgetHorizontal(widget.steps[i], i),
                    _stepLine(widget.steps[i], i),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _verticalSteps() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.steps.length,
        (i) => i == (widget.steps.length - 1)
            ? _stepWidgetVertical(widget.steps[i], i)
            : Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _stepWidgetVertical(widget.steps[i], i),
                    _stepLine(widget.steps[i], i),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _stepLine(Steps step, int i) {
    if (!widget.showStepLine) {
      return const SizedBox.shrink();
    }

    bool isActive = i == 0 ? _isStepActive(i) : _isStepActive(i + 1);

    if (widget.isStepLineDashed) {
      return _dashedLine(isActive);
    } else {
      return _solidLine(isActive);
    }
  }

  Widget _dashedLine(bool isActive) {
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final boxSize = widget.direction == Axis.horizontal
            ? constraints.constrainWidth()
            : constraints.constrainHeight();

        final dCount =
            (boxSize * widget.dashFillRate / widget.stepLineWidth).floor();

        return SizedBox(
          width: widget.direction == Axis.horizontal
              ? boxSize
              : widget.leadingSize,
          height: widget.direction == Axis.horizontal
              ? widget.leadingSize
              : boxSize,
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: widget.direction,
            children: List.generate(dCount, (_) {
              return SizedBox(
                width: widget.direction == Axis.horizontal
                    ? widget.stepLineWidth
                    : widget.stepLineHeight,
                height: widget.direction == Axis.horizontal
                    ? widget.stepLineHeight
                    : widget.stepLineWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isActive
                        ? _activeStepLineColor
                        : _inactiveStepLineColor,
                    borderRadius: BorderRadius.circular(
                      widget.stepLineRadius,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _solidLine(bool isActive) {
    return Expanded(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxSize = widget.direction == Axis.horizontal
              ? constraints.constrainWidth()
              : constraints.constrainHeight();

          return Container(
            alignment: Alignment.center,
            width: widget.direction == Axis.horizontal
                ? boxSize
                : widget.leadingSize,
            height: widget.direction == Axis.horizontal
                ? widget.leadingSize
                : boxSize,
            child: SizedBox(
              width: widget.direction == Axis.horizontal
                  ? boxSize
                  : widget.stepLineHeight,
              height: widget.direction == Axis.horizontal
                  ? widget.stepLineHeight
                  : boxSize,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      isActive ? _activeStepLineColor : _inactiveStepLineColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Line that connects leading widget with step line widget
  Widget _continuousStepLine(Steps step, int i) {
    if (!widget.showStepLine || !widget.isStepLineContinuous) {
      return const SizedBox.shrink();
    }

    bool firstIsActive = _isStepActive(i);
    bool nextIsActive =
        i < widget.steps.length - 1 ? _isStepActive(i + 1) : _isStepActive(i);

    return SizedBox(
      width: widget.direction == Axis.horizontal
          ? widget.leadingSize * widget.leadingSizeFactor
          : widget.leadingSize,
      height: widget.direction == Axis.horizontal
          ? widget.leadingSize
          : widget.leadingSize * widget.leadingSizeFactor,
      child: widget.isStepLineDashed
          ? _continuousStepLineDashed(firstIsActive, nextIsActive, i)
          : _continuousStepLineSolid(firstIsActive, nextIsActive, i),
    );
  }

  Widget _buildDashedSegment({
    required bool isActive,
    required bool isHidden,
  }) {
    return Expanded(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxSize = widget.direction == Axis.horizontal
              ? constraints.constrainWidth()
              : constraints.constrainHeight();

          final dCount = (boxSize *
                  (widget.dashFillRate == 1
                      ? widget.dashFillRate
                      : widget.dashFillRate / 2) /
                  widget.stepLineWidth)
              .ceil();

          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            direction: widget.direction,
            children: List.generate(dCount, (_) {
              return SizedBox(
                width: widget.direction == Axis.horizontal
                    ? widget.stepLineWidth
                    : widget.stepLineHeight,
                height: widget.direction == Axis.horizontal
                    ? widget.stepLineHeight
                    : widget.stepLineWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isHidden
                        ? Colors.transparent
                        : (isActive
                            ? _activeStepLineColor
                            : _inactiveStepLineColor),
                    borderRadius: BorderRadius.circular(widget.stepLineRadius),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _continuousStepLineDashed(
    bool firstIsActive,
    bool nextIsActive,
    int i,
  ) {
    final children = [
      _buildDashedSegment(
        isActive: firstIsActive,
        isHidden: i == 0,
      ),
      _buildDashedSegment(
        isActive: nextIsActive,
        isHidden: i == widget.steps.length - 1,
      ),
    ];

    return widget.direction == Axis.horizontal
        ? Row(children: children)
        : Column(children: children);
  }

  Widget _buildSolidSegment({
    required bool isActive,
    required bool isHidden,
  }) {
    return Expanded(
      child: Container(
        color: isHidden
            ? Colors.transparent
            : (isActive ? _activeStepLineColor : _inactiveStepLineColor),
        width: widget.direction == Axis.horizontal
            ? widget.stepLineWidth
            : widget.stepLineHeight,
        height: widget.direction == Axis.horizontal
            ? widget.stepLineHeight
            : widget.stepLineWidth,
      ),
    );
  }

  Widget _continuousStepLineSolid(
    bool firstIsActive,
    bool nextIsActive,
    int i,
  ) {
    final children = [
      _buildSolidSegment(
        isActive: firstIsActive,
        isHidden: i == 0,
      ),
      _buildSolidSegment(
        isActive: nextIsActive,
        isHidden: i == widget.steps.length - 1,
      ),
    ];

    return widget.direction == Axis.horizontal
        ? Row(children: children)
        : Column(children: children);
  }

  Widget _stepWidgetHorizontal(Steps step, int i) {
    return SizedBox(
      width: widget.leadingSize * widget.leadingSizeFactor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _leadingWidget(step, i),
          _titleWidgetStepHorizontal(step, i),
          _subtitleWidgetStepHorizontal(step, i),
        ],
      ),
    );
  }

  Widget _titleWidgetStepHorizontal(Steps step, int i) {
    if (step.title == null) {
      return const SizedBox.shrink();
    }

    final isActive = _isStepActive(i);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 8),
      child: Text(
        step.title!,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: widget.titleStyle ??
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: widget.titleFontSize ?? widget.leadingSize / 2,
                  color: isActive ? _titleActiveColor : _titleInactiveColor,
                ),
      ),
    );
  }

  Widget _subtitleWidgetStepHorizontal(Steps step, int i) {
    if (!widget.showSubtitle || step.subtitle == null) {
      return const SizedBox.shrink();
    }

    final isActive = _isStepActive(i);

    return Text(
      step.subtitle!,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: widget.subtitleStyle ??
          Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: widget.subtitleFontSize ?? widget.leadingSize / 2.6,
                color: isActive ? _subtitleActiveColor : _subtitleInactiveColor,
              ),
    );
  }

  Widget _stepWidgetVertical(Steps step, int i) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _leadingWidget(step, i),
        step.title == null && step.subtitle == null
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleWidgetStepVertical(step, i),
                    _subtitleWidgetStepVertical(step, i),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _titleWidgetStepVertical(Steps step, int i) {
    if (step.title == null) {
      return const SizedBox.shrink();
    }

    final isActive = _isStepActive(i);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        step.title!,
        style: widget.titleStyle ??
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: widget.titleFontSize ?? widget.leadingSize / 2,
                  color: isActive ? _titleActiveColor : _titleInactiveColor,
                ),
      ),
    );
  }

  Widget _subtitleWidgetStepVertical(Steps step, int i) {
    if (!widget.showSubtitle || step.subtitle == null) {
      return const SizedBox.shrink();
    }

    final isActive = _isStepActive(i);

    return Text(
      step.subtitle!,
      style: widget.subtitleStyle ??
          Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: widget.subtitleFontSize ?? widget.leadingSize / 2.6,
                color: isActive ? _subtitleActiveColor : _subtitleInactiveColor,
              ),
    );
  }

  Widget _leadingWidget(Steps step, int i) {
    final isActive = _isStepActive(i);

    Widget leading = SizedBox(
      width: widget.direction == Axis.horizontal
          ? widget.leadingSize * widget.leadingSizeFactor
          : widget.leadingSize,
      height: widget.direction == Axis.horizontal
          ? widget.leadingSize
          : widget.leadingSize * widget.leadingSizeFactor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Line that connects leading widget with step line widget
          _continuousStepLine(step, i),
          if (step.leading != null)
            // Custom leading
            Center(
              child: widget.hideInactiveLeading
                  ? isActive
                      ? SizedBox(
                          width: widget.leadingSize,
                          height: widget.leadingSize,
                          child: step.leading,
                        )
                      : Container(
                          width: widget.leadingSize / 1.5,
                          height: widget.leadingSize / 1.5,
                          decoration: BoxDecoration(
                            color: _inactiveColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        )
                  : SizedBox(
                      width: widget.leadingSize,
                      height: widget.leadingSize,
                      child: step.leading,
                    ),
            )
          else
            // Default leading
            Container(
              width: widget.leadingSize,
              height: widget.leadingSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                  width: widget.leadingSize / 12,
                  color: isActive ? _activeColor : _inactiveColor,
                ),
              ),
              child: Container(
                width: widget.leadingSize / (widget.showCounter ? 0 : 2),
                height: widget.leadingSize / (widget.showCounter ? 0 : 2),
                decoration: BoxDecoration(
                  color: isActive ? _activeColor : _inactiveColor,
                  shape: BoxShape.circle,
                ),
                child: widget.showCounter
                    ? Center(
                        child: Text(
                          '${i + 1}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: widget.leadingSize / 2.5,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            )
        ],
      ),
    );

    if (widget.onStepTapped != null) {
      leading = GestureDetector(
        onTap: () => widget.onStepTapped!(i),
        child: leading,
      );
    }

    return leading;
  }
}
