import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';
import '../../core/reaction_engine.dart';

class _Ink {
  const _Ink(this.name, this.color);

  final String name;
  final Color color;
}

const _inks = [
  _Ink('RED', Color(0xFFD32F2F)),
  _Ink('BLUE', Color(0xFF1976D2)),
  _Ink('GREEN', Color(0xFF388E3C)),
  _Ink('ORANGE', Color(0xFFF57C00)),
];

class StroopGame extends MiniGame {
  const StroopGame();

  @override
  String get id => 'stroop';

  @override
  String get title => 'Stroop';

  @override
  String get description => 'Tap the color the word is written in, not what it says.';

  @override
  Category get category => Category.focus;

  @override
  Widget build(BuildContext context, GameSession session) {
    final level = session.level;
    final rng = Random(session.seed);

    // Harder levels: a 4th color, less time, fewer "easy" matching trials.
    final pool = _inks.take(level <= 3 ? 3 : 4).toList();
    final windowMs = max(1400, 3000 - level * 160);
    final congruentShare = max(0.1, 0.5 - level * 0.04);

    final trials = List<ReactionTrial>.generate(30, (_) {
      final ink = pool[rng.nextInt(pool.length)];
      final others = pool.where((p) => p != ink).toList();
      final word = rng.nextDouble() < congruentShare
          ? ink
          : others[rng.nextInt(others.length)];
      return ReactionTrial(
        stimulus: Text(
          word.name,
          style: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w800,
            color: ink.color,
          ),
        ),
        correct: ink.name,
      );
    });

    return ReactionRunner(
      session: session,
      trials: trials,
      options: [
        for (final ink in pool) ReactionOption(value: ink.name, label: ink.name),
      ],
      responseWindowMs: windowMs,
      title: 'Stroop',
      instructions: 'Tap the INK color, ignore the word.',
    );
  }
}
