import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';
import '../../core/reaction_engine.dart';

class GoNoGoGame extends MiniGame {
  const GoNoGoGame();

  @override
  String get id => 'go_no_go';

  @override
  String get title => 'Go / No-Go';

  @override
  String get description => 'Tap for the green circle. Hold still for the red square.';

  @override
  Category get category => Category.impulseControl;

  @override
  Widget build(BuildContext context, GameSession session) {
    final level = session.level;
    final rng = Random(session.seed);

    // Harder levels: less time per trial and more no-go trials.
    final windowMs = max(500, 1000 - (level - 1) * 55);
    final noGoShare = 0.2 + level * 0.02;

    final trials = List<ReactionTrial>.generate(30, (_) {
      final go = rng.nextDouble() >= noGoShare;
      return ReactionTrial(
        stimulus: _Shape(go: go),
        correct: go ? 'go' : null,
      );
    });

    return ReactionRunner(
      session: session,
      trials: trials,
      options: const [ReactionOption(value: 'go', label: 'TAP')],
      responseWindowMs: windowMs,
      title: 'Go / No-Go',
      instructions: 'Tap only for the green circle.',
    );
  }
}

/// Go and no-go differ in shape as well as color, so it also works for
/// players with red-green color blindness.
class _Shape extends StatelessWidget {
  const _Shape({required this.go});

  final bool go;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: go ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
        shape: go ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: go ? null : BorderRadius.circular(24),
      ),
    );
  }
}
