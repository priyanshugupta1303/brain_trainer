import 'package:flutter/material.dart';

/// The 20 cognitive areas the app trains.
enum Category {
  planning('Planning', Icons.route),
  analyticalThinking('Analytical Thinking', Icons.analytics),
  calculation('Calculation', Icons.calculate),
  shortTermMemory('Short Term Memory', Icons.flash_on),
  longTermMemory('Long Term Memory', Icons.history_edu),
  workingMemory('Working Memory', Icons.memory),
  patternRecognition('Pattern Recognition', Icons.pattern),
  mindMapping('Mind Mapping', Icons.account_tree),
  processingSpeed('Processing Speed', Icons.speed),
  spatialIntelligence('Spatial Intelligence', Icons.view_in_ar),
  mentalFlexibility('Mental Flexibility', Icons.swap_horiz),
  concentration('Concentration', Icons.center_focus_strong),
  focus('Focus', Icons.filter_center_focus),
  productivity('Productivity', Icons.checklist),
  coding('Coding', Icons.code),
  cognitiveIntelligence('Cognitive Intelligence', Icons.psychology),
  visualPerception('Visual Perception', Icons.visibility),
  impulseControl('Impulse Control', Icons.front_hand),
  problemSolving('Problem Solving', Icons.extension),
  logic('Logic', Icons.lightbulb);

  const Category(this.label, this.icon);

  final String label;
  final IconData icon;

  /// Evenly spaced hues so every category is distinguishable.
  Color get color =>
      HSLColor.fromAHSL(1, (index * 18.0) % 360, 0.55, 0.45).toColor();
}
