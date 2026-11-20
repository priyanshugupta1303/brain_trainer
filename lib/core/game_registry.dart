import '../games/analytical/analytical_game.dart';
import '../games/calculation/calculation_game.dart';
import '../games/code_trace/code_trace_game.dart';
import '../games/go_no_go/go_no_go_game.dart';
import '../games/hanoi/hanoi_game.dart';
import '../games/logic/logic_game.dart';
import '../games/matrix/matrix_game.dart';
import '../games/mind_map/mind_map_game.dart';
import '../games/n_back/n_back_game.dart';
import '../games/odd_shade/odd_shade_game.dart';
import '../games/pair_recall/pair_recall_game.dart';
import '../games/pattern/pattern_game.dart';
import '../games/priority/priority_game.dart';
import '../games/rotation/rotation_game.dart';
import '../games/rule_switch/rule_switch_game.dart';
import '../games/schulte/schulte_game.dart';
import '../games/sequence_recall/sequence_recall_game.dart';
import '../games/sliding/sliding_game.dart';
import '../games/stroop/stroop_game.dart';
import '../games/symbol_digit/symbol_digit_game.dart';
import 'category.dart';
import 'mini_game.dart';

/// Register new games here. Nothing else in the app needs to change.
/// One game per category so far; a category can hold several.
const List<MiniGame> allGames = [
  HanoiGame(), // Planning
  AnalyticalGame(), // Analytical Thinking
  CalculationGame(), // Calculation
  SequenceRecallGame(), // Short Term Memory
  PairRecallGame(), // Long Term Memory
  NBackGame(), // Working Memory
  PatternGame(), // Pattern Recognition
  MindMapGame(), // Mind Mapping
  SymbolDigitGame(), // Processing Speed
  RotationGame(), // Spatial Intelligence
  RuleSwitchGame(), // Mental Flexibility
  SchulteGame(), // Concentration
  StroopGame(), // Focus
  PriorityGame(), // Productivity
  CodeTraceGame(), // Coding
  MatrixGame(), // Cognitive Intelligence
  OddShadeGame(), // Visual Perception
  GoNoGoGame(), // Impulse Control
  SlidingGame(), // Problem Solving
  LogicGame(), // Logic
];

List<MiniGame> gamesFor(Category category) =>
    allGames.where((g) => g.category == category).toList();
