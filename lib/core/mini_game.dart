import 'package:flutter/widgets.dart';

import 'category.dart';

/// What a game reports when a round ends.
class GameResult {
  const GameResult({
    required this.score,
    required this.performance,
    required this.duration,
  });

  /// Raw points, shown to the player and used for "best score".
  final int score;

  /// 0.0–1.0 measure of how well the round went. Drives adaptive difficulty.
  final double performance;

  final Duration duration;
}

/// Everything a game needs to run one round.
class GameSession {
  const GameSession({
    required this.level,
    required this.seed,
    required this.onFinished,
  });

  /// 1..MiniGame.maxLevel. Games map this to their own difficulty knobs.
  final int level;

  /// Use this to seed all randomness so a round is reproducible.
  final int seed;

  /// Call exactly once when the round is over.
  final void Function(GameResult result) onFinished;
}

/// Contract every mini-game implements.
abstract class MiniGame {
  const MiniGame();

  /// Stable id used as the database key. Never change it after release.
  String get id;
  String get title;
  String get description;
  Category get category;
  int get maxLevel => 10;

  Widget build(BuildContext context, GameSession session);
}
