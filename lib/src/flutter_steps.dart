import 'package:flutter/material.dart';
import 'package:flutter_steps/src/steps.dart';

/// A widget that displays a series of steps with various customization options.
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

  /// Creates a [FlutterSteps] widget.
  const FlutterSteps({
    super.key,
    required this.steps, // List of steps to be displayed.
    this.direction = Axis.horizontal, // Direction of the steps.
    this.crossAxisAlignment = CrossAxisAlignment.center, // Alignment of the steps along the cross axis.
    this.showCounter = true, // Whether to show a counter for the steps.
    this.showSubtitle = true, // Whether to show subtitles for the steps.
    this.hideInactiveLeading = false, // Whether to hide the leading element for inactive steps.
    this.isStepLineDashed = false, // Whether the step line should be dashed.
    this.showStepLine = true, // Whether to show a line connecting the steps.
    this.isStepLineContinuous = true, // Whether the step line should be continuous.
    this.activeColor, // The color for active steps.
    this.inactiveColor, // The color for inactive steps.
    this.titleActiveColor, // The color for the title of active steps.
    this.titleInactiveColor, // The color for the title of inactive steps.
    this.subtitleActiveColor, // The color for the subtitle of active steps.
    this.subtitleInactiveColor, // The color for the subtitle of inactive steps.
    this.activeStepLineColor, // The color for the step line of active steps.
    this.inactiveStepLineColor, // The color for the step line of inactive steps.
    this.leadingSize = 32, // The size of the leading element.
    this.leadingSizeFactor = 2, // The size factor for the leading element.
    this.titleFontSize, // The font size for the title.
    this.subtitleFontSize, // The font size for the subtitle.
    this.titleStyle, // The text style for the title.
    this.subtitleStyle, // The text style for the subtitle.
    this.stepLineHeight = 2, // The height of the step line.
    this.stepLineWidth = 2, // The width of the step line.
    this.dashFillRate = 0.7, // The fill rate for the dash pattern of the step line.
    this.stepLineRadius = 100, // The radius for the step line's corners.
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
  Widget build(BuildContext context) {
    _activeColor = widget.activeColor ?? Theme.of(context).colorScheme.primary;
    _inactiveColor = widget.inactiveColor ?? Theme.of(context).colorScheme.outline;
    _titleActiveColor = widget.titleActiveColor ?? Theme.of(context).colorScheme.primary;
    _titleInactiveColor = widget.titleInactiveColor ?? Theme.of(context).colorScheme.outline;
    _subtitleActiveColor = widget.subtitleActiveColor ?? Theme.of(context).colorScheme.secondary;
    _subtitleInactiveColor = widget.subtitleInactiveColor ?? Theme.of(context).colorScheme.outline;
    _activeStepLineColor = widget.activeStepLineColor ?? Theme.of(context).colorScheme.primary;
    _inactiveStepLineColor = widget.inactiveStepLineColor ?? Theme.of(context).colorScheme.outline;

    return widget.direction == Axis.horizontal ? _horizontalSteps() : _verticalSteps();
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

    bool isActve = i == 0 ? widget.steps[i].isActive : widget.steps[i + 1].isActive;

    if (widget.isStepLineDashed) {
      return _dashedLine(isActve);
    } else {
      return _solidLine(isActve);
    }
  }

  Widget _dashedLine(bool isActive) {
    return Expanded(
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        final boxSize =
            widget.direction == Axis.horizontal ? constraints.constrainWidth() : constraints.constrainHeight();

        final dCount = (boxSize * widget.dashFillRate / widget.stepLineWidth).floor();

        return SizedBox(
          width: widget.direction == Axis.horizontal ? boxSize : widget.leadingSize,
          height: widget.direction == Axis.horizontal ? widget.leadingSize : boxSize,
          child: Flex(
            // spaceBetween: the opposite of spaceAround on continuousStepLineDashed widget
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: widget.direction,
            children: List.generate(dCount, (_) {
              return SizedBox(
                width: widget.direction == Axis.horizontal ? widget.stepLineWidth : widget.stepLineHeight,
                height: widget.direction == Axis.horizontal ? widget.stepLineHeight : widget.stepLineWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isActive ? _activeStepLineColor : _inactiveStepLineColor,
                    borderRadius: BorderRadius.circular(widget.stepLineRadius),
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
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        final boxSize =
            widget.direction == Axis.horizontal ? constraints.constrainWidth() : constraints.constrainHeight();

        return Container(
          alignment: Alignment.center,
          width: widget.direction == Axis.horizontal ? boxSize : widget.leadingSize,
          height: widget.direction == Axis.horizontal ? widget.leadingSize : boxSize,
          child: SizedBox(
            width: widget.direction == Axis.horizontal ? boxSize : widget.stepLineHeight,
            height: widget.direction == Axis.horizontal ? widget.stepLineHeight : boxSize,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isActive ? _activeStepLineColor : _inactiveStepLineColor,
              ),
            ),
          ),
        );
      }),
    );
  }

  // Line that connection leading widget with step line widget
  Widget _continuousStepLine(Steps step, int i) {
    if (!widget.showStepLine || !widget.isStepLineContinuous) {
      return const SizedBox.shrink();
    }

    bool firstIsActive = widget.steps[i].isActive;
    bool nextIsActive = i < widget.steps.length - 1 ? widget.steps[i + 1].isActive : widget.steps[i].isActive;

    return SizedBox(
      width: widget.direction == Axis.horizontal ? widget.leadingSize * widget.leadingSizeFactor : widget.leadingSize,
      height: widget.direction == Axis.horizontal ? widget.leadingSize : widget.leadingSize * widget.leadingSizeFactor,
      child: widget.isStepLineDashed
          ? _continuousStepLineDashed(firstIsActive, nextIsActive, i)
          : _continuousStepLineSolid(firstIsActive, nextIsActive, i),
    );
  }

  Widget _continuousStepLineDashed(bool firstIsActive, bool nextIsActive, int i) {
    return widget.direction == Axis.horizontal
        ? Row(
            children: [
              Expanded(
                child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  final boxSize = widget.direction == Axis.horizontal
                      ? constraints.constrainWidth()
                      : constraints.constrainHeight();

                  // if dashFillRate < 1 divide by 2, so that the density is the same as the density of dashedLine widget
                  final dCount = (boxSize *
                          (widget.dashFillRate == 1 ? widget.dashFillRate : widget.dashFillRate / 2) /
                          widget.stepLineWidth)
                      .ceil();

                  return Flex(
                    // spaceAround: the opposite of spaceBetween on dashedLine widget
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    direction: widget.direction,
                    children: List.generate(dCount, (_) {
                      return SizedBox(
                        width: widget.direction == Axis.horizontal ? widget.stepLineWidth : widget.stepLineHeight,
                        height: widget.direction == Axis.horizontal ? widget.stepLineHeight : widget.stepLineWidth,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            // hide first line with transparent color
                            color: i == 0
                                ? Colors.transparent
                                : (firstIsActive ? _activeStepLineColor : _inactiveStepLineColor),
                            borderRadius: BorderRadius.circular(widget.stepLineRadius),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
              Expanded(
                child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  final boxSize = widget.direction == Axis.horizontal
                      ? constraints.constrainWidth()
                      : constraints.constrainHeight();

                  // if dashFillRate < 1 divide by 2, so that the density is the same as the density of dashedLine widget
                  final dCount = (boxSize *
                          (widget.dashFillRate == 1 ? widget.dashFillRate : widget.dashFillRate / 2) /
                          widget.stepLineWidth)
                      .ceil();
                  return Flex(
                    // spaceAround: the opposite of spaceBetween on dashedLine widget
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    direction: widget.direction,
                    children: List.generate(dCount, (_) {
                      return SizedBox(
                        width: widget.direction == Axis.horizontal ? widget.stepLineWidth : widget.stepLineHeight,
                        height: widget.direction == Axis.horizontal ? widget.stepLineHeight : widget.stepLineWidth,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            // hide last line with transparent color
                            color: i == widget.steps.length - 1
                                ? Colors.transparent
                                : (nextIsActive ? _activeStepLineColor : _inactiveStepLineColor),
                            borderRadius: BorderRadius.circular(widget.stepLineRadius),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ],
          )
        : Column(
            children: [
              Expanded(
                child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  final boxSize = widget.direction == Axis.horizontal
                      ? constraints.constrainWidth()
                      : constraints.constrainHeight();

                  // if dashFillRate < 1 divide by 2, so that the density is the same as the density of dashedLine widget
                  final dCount = (boxSize *
                          (widget.dashFillRate == 1 ? widget.dashFillRate : widget.dashFillRate / 2) /
                          widget.stepLineWidth)
                      .ceil();

                  return Flex(
                    // spaceAround: the opposite of spaceBetween on dashedLine widget
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    direction: widget.direction,
                    children: List.generate(dCount, (_) {
                      return SizedBox(
                        width: widget.direction == Axis.horizontal ? widget.stepLineWidth : widget.stepLineHeight,
                        height: widget.direction == Axis.horizontal ? widget.stepLineHeight : widget.stepLineWidth,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            // hide first line with transparent color
                            color: i == 0
                                ? Colors.transparent
                                : (firstIsActive ? _activeStepLineColor : _inactiveStepLineColor),
                            borderRadius: BorderRadius.circular(widget.stepLineRadius),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
              Expanded(
                child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                  final boxSize = widget.direction == Axis.horizontal
                      ? constraints.constrainWidth()
                      : constraints.constrainHeight();

                  // if dashFillRate < 1 divide by 2, so that the density is the same as the density of dashedLine widget
                  final dCount = (boxSize *
                          (widget.dashFillRate == 1 ? widget.dashFillRate : widget.dashFillRate / 2) /
                          widget.stepLineWidth)
                      .ceil();

                  return Flex(
                    // spaceAround: the opposite of spaceBetween on dashedLine widget
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    direction: widget.direction,
                    children: List.generate(dCount, (_) {
                      return SizedBox(
                        width: widget.direction == Axis.horizontal ? widget.stepLineWidth : widget.stepLineHeight,
                        height: widget.direction == Axis.horizontal ? widget.stepLineHeight : widget.stepLineWidth,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            // hide last line with transparent color
                            color: i == widget.steps.length - 1
                                ? Colors.transparent
                                : (nextIsActive ? _activeStepLineColor : _inactiveStepLineColor),
                            borderRadius: BorderRadius.circular(widget.stepLineRadius),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ],
          );
  }

  Widget _continuousStepLineSolid(bool firstIsActive, bool nextIsActive, int i) {
    return widget.direction == Axis.horizontal
        ? Row(
            children: [
              Expanded(
                child: Container(
                  // hide first line with transparent color
                  color: i == 0 ? Colors.transparent : (firstIsActive ? _activeStepLineColor : _inactiveStepLineColor),
                  width: widget.direction == Axis.horizontal ? widget.stepLineWidth : widget.stepLineHeight,
                  height: widget.direction == Axis.horizontal ? widget.stepLineHeight : widget.stepLineWidth,
                ),
              ),
              Expanded(
                child: Container(
                  // hide last line with transparent color
                  color: i == widget.steps.length - 1
                      ? Colors.transparent
                      : (nextIsActive ? _activeStepLineColor : _inactiveStepLineColor),
                  width: widget.direction == Axis.horizontal ? widget.stepLineWidth : widget.stepLineHeight,
                  height: widget.direction == Axis.horizontal ? widget.stepLineHeight : widget.stepLineWidth,
                ),
              ),
            ],
          )
        : Column(
            children: [
              Expanded(
                child: Container(
                  // hide first line with transparent color
                  color: i == 0 ? Colors.transparent : (firstIsActive ? _activeStepLineColor : _inactiveStepLineColor),
                  width: widget.direction == Axis.horizontal ? widget.stepLineWidth : widget.stepLineHeight,
                  height: widget.direction == Axis.horizontal ? widget.stepLineHeight : widget.stepLineWidth,
                ),
              ),
              Expanded(
                child: Container(
                  // hide last line with transparent color
                  color: i == widget.steps.length - 1
                      ? Colors.transparent
                      : (nextIsActive ? _activeStepLineColor : _inactiveStepLineColor),
                  width: widget.direction == Axis.horizontal ? widget.stepLineWidth : widget.stepLineHeight,
                  height: widget.direction == Axis.horizontal ? widget.stepLineHeight : widget.stepLineWidth,
                ),
              ),
            ],
          );
  }

  Widget _stepWidgetHorizontal(Steps step, int i) {
    return SizedBox(
      width: widget.leadingSize * widget.leadingSizeFactor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _leadingWidget(step, i),
          _titleWidgetStepHorizontal(step),
          _subtitleWidgetStepHorizontal(step),
        ],
      ),
    );
  }

  Widget _titleWidgetStepHorizontal(Steps step) {
    if (step.title == null) {
      return const SizedBox.shrink();
    }

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
                  color: step.isActive ? _titleActiveColor : _titleInactiveColor,
                ),
      ),
    );
  }

  Widget _subtitleWidgetStepHorizontal(Steps step) {
    if (!widget.showSubtitle || step.subtitle == null) {
      return const SizedBox.shrink();
    }

    return Text(
      step.subtitle!,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: widget.subtitleStyle ??
          Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: widget.subtitleFontSize ?? widget.leadingSize / 2.6,
                color: step.isActive ? _subtitleActiveColor : _subtitleInactiveColor,
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
                    _titleWidgetStepVertical(step),
                    _subtitleWidgetStepVertical(step),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _titleWidgetStepVertical(Steps step) {
    if (step.title == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        step.title!,
        style: widget.titleStyle ??
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: widget.titleFontSize ?? widget.leadingSize / 2,
                  color: step.isActive ? _titleActiveColor : _titleInactiveColor,
                ),
      ),
    );
  }

  Widget _subtitleWidgetStepVertical(Steps step) {
    if (!widget.showSubtitle || step.subtitle == null) {
      return const SizedBox.shrink();
    }

    return Text(
      step.subtitle!,
      style: widget.subtitleStyle ??
          Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: widget.subtitleFontSize ?? widget.leadingSize / 2.6,
                color: step.isActive ? _subtitleActiveColor : _subtitleInactiveColor,
              ),
    );
  }

  Widget _leadingWidget(Steps step, int i) {
    return SizedBox(
      width: widget.direction == Axis.horizontal ? widget.leadingSize * widget.leadingSizeFactor : widget.leadingSize,
      height: widget.direction == Axis.horizontal ? widget.leadingSize : widget.leadingSize * widget.leadingSizeFactor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Line that connection leading widget with step line widget
          _continuousStepLine(step, i),
          if (step.leading != null)
            // Custom leading
            Center(
              child: widget.hideInactiveLeading
                  ? step.isActive
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
                  color: step.isActive ? _activeColor : _inactiveColor,
                ),
              ),
              child: Container(
                width: widget.leadingSize / (widget.showCounter ? 0 : 2),
                height: widget.leadingSize / (widget.showCounter ? 0 : 2),
                decoration: BoxDecoration(
                  color: step.isActive ? _activeColor : _inactiveColor,
                  shape: BoxShape.circle,
                ),
                child: widget.showCounter
                    ? Center(
                        child: Text(
                          '${i + 1}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
  }
}
