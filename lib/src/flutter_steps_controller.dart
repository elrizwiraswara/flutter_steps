import 'package:flutter/foundation.dart';

/// A controller for managing the current step in a [FlutterSteps] widget.
///
/// Provides programmatic navigation with [next], [back], and [jumpTo] methods.
///
/// Example:
/// ```dart
/// final controller = FlutterStepsController(initialStep: 0);
///
/// // Navigate
/// controller.next(totalSteps);
/// controller.back();
/// controller.jumpTo(2, totalSteps);
///
/// // Don't forget to dispose
/// controller.dispose();
/// ```
class FlutterStepsController extends ChangeNotifier {
  int _currentStep;

  /// Creates a [FlutterStepsController] with an optional [initialStep].
  FlutterStepsController({int initialStep = 0}) : _currentStep = initialStep;

  /// The current step index.
  int get currentStep => _currentStep;

  /// Whether the current step is the first step.
  bool get isFirstStep => _currentStep == 0;

  /// Whether the current step is the last step for the given [totalSteps].
  bool isLastStep(int totalSteps) => _currentStep >= totalSteps - 1;

  /// Moves to the next step if not already at the last step.
  void next(int totalSteps) {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  /// Moves to the previous step if not already at the first step.
  void back() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  /// Jumps to a specific [step] index.
  ///
  /// The [step] must be within bounds (0 to [totalSteps] - 1).
  void jumpTo(int step, int totalSteps) {
    if (step >= 0 && step < totalSteps && step != _currentStep) {
      _currentStep = step;
      notifyListeners();
    }
  }
}
