import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';
import '../../core/reaction_engine.dart';

const _symbols = ['★', '♥', '♣', '♠', '◆', '●', '▲', '■'];

class SymbolDigitGame extends MiniGame {
  const SymbolDigitGame();

  @override
  String get id => 'symbol_digit';

  @override
  String get title => 'Symbol Match';

  @override
  String get description => 'Use the key to turn each symbol into its digit, as fast as you can.';

  @override
  Category get category => Category.processingSpeed;

  @override
  Widget build(BuildContext context, GameSession session) {
    final level = session.level;
    final rng = Random(session.seed);

    final count = 4 + level ~/ 4; // 4..6 symbols
    final used = ([..._symbols]..shuffle(rng)).take(count).toList();
    final digits = [for (var d = 1; d <= count; d++) d]..shuffle(rng);

    // The key stays on screen above every symbol.
    final key = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: [
                Text(used[i], style: const TextStyle(fontSize: 26)),
                Text(
                  '${digits[i]}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
      ],
    );

    final trials = List<ReactionTrial>.generate(30, (_) {
      final i = rng.nextInt(count);
      return ReactionTrial(
        stimulus: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            key,
            const SizedBox(height: 16),
            Text(used[i], style: const TextStyle(fontSize: 64)),
          ],
        ),
        correct: '${digits[i]}',
      );
    });

    return ReactionRunner(
      session: session,
      trials: trials,
      options: [
        for (var d = 1; d <= count; d++) ReactionOption(value: '$d', label: '$d'),
      ],
      responseWindowMs: max(900, 2200 - level * 110),
      title: 'Symbol Match',
      instructions: 'Tap the digit that matches the symbol.',
      buttonHeight: 56,
    );
  }
}
