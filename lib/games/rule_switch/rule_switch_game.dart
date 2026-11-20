import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';
import '../../core/reaction_engine.dart';

class RuleSwitchGame extends MiniGame {
  const RuleSwitchGame();

  @override
  String get id => 'rule_switch';

  @override
  String get title => 'Rule Switch';

  @override
  String get description => 'The question keeps changing. Answer YES or NO for the current rule.';

  @override
  Category get category => Category.mentalFlexibility;

  @override
  Widget build(BuildContext context, GameSession session) {
    final level = session.level;
    final rng = Random(session.seed);

    // The rule flips every `block` trials; higher levels flip more often.
    final block = max(2, 6 - level ~/ 2);

    final trials = List<ReactionTrial>.generate(32, (i) {
      final rule = (i ~/ block) % 2;
      final n = 1 + rng.nextInt(9);
      final yes = rule == 0 ? n.isEven : n > 5;

      return ReactionTrial(
        stimulus: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: rule == 0 ? const Color(0xFF1565C0) : const Color(0xFFEF6C00),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                rule == 0 ? 'Is it EVEN?' : 'Is it MORE than 5?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('$n', style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w800)),
          ],
        ),
        correct: yes ? 'YES' : 'NO',
      );
    });

    return ReactionRunner(
      session: session,
      trials: trials,
      options: const [
        ReactionOption(value: 'YES', label: 'YES'),
        ReactionOption(value: 'NO', label: 'NO'),
      ],
      responseWindowMs: max(1200, 2600 - level * 140),
      title: 'Rule Switch',
      instructions: 'Watch the colored label: the rule changes.',
    );
  }
}
