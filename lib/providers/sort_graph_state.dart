import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pysort_flutter/model/algorithm_step.dart';
import 'package:pysort_flutter/model/data_set.dart';

class SortGraphState extends ChangeNotifier {
  int _currentStep = 0;
  final List<AlgorithmStep> _steps;
  final DataSet data;
  List<int> _elementList = [];

  AlgorithmStep get currentStep {
    return _steps[_currentStep];
  }

  bool get isLastStep {
    return currentStepIndex == _steps.length - 1;
  }

  int get currentStepIndex {
    return _currentStep;
  }

  List<int> get elementList => _elementList;

  void nextStep() {
    if (!isLastStep) {
      _elementList = currentStep.doStep(_elementList);
      _currentStep += 1;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep != 0) {
      _currentStep -= 1;
      _elementList = currentStep.undoStep(_elementList);
      notifyListeners();
    }
  }

  Timer? _autoPlayTimer;

  bool get isAutoPlay {
    return _autoPlayTimer?.isActive ?? false;
  }

  bool get canNext {
    return !isLastStep && !isAutoPlay;
  }

  bool get canPrevious {
    return currentStepIndex != 0 && !isAutoPlay;
  }

  void stopAutoPlay() {
    _autoPlayTimer?.cancel();
  }

  void startAutoPlay(
      {Duration delay = const Duration(seconds: 1), bool isForwards = true}) {
    if (isAutoPlay == true) {
      return;
    }
    _autoPlayTimer = Timer.periodic(
      delay,
      (Timer timer) {
        if (isForwards) {
          if (isLastStep) {
            nextStep();
            _autoPlayTimer?.cancel();
            notifyListeners();
          } else {
            nextStep();
            notifyListeners();
          }
          return;
        }
        if (currentStepIndex == 0) {
          previousStep();
          _autoPlayTimer?.cancel();
          notifyListeners();
        } else {
          previousStep();
          notifyListeners();
        }
      },
    );
  }

  SortGraphState({required List<AlgorithmStep> steps, required this.data})
      : _steps = steps,
        _elementList = data.data;
}