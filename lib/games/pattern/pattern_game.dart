import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';
import '../../core/quiz_engine.dart';

class PatternGame extends MiniGame {
  const PatternGame();

  @override
  String get id => 'pattern';

  @override
  String get title => 'Number Patterns';

  @override
  String get description => 'Find the rule and pick the next number in the sequence.';

  @override
  Category get category => Category.patternRecognition;

  @override
  Widget build(BuildContext context, GameSession session) {
    final level = session.level;
    final rng = Random(session.seed);

    final questions = List<QuizQuestion>.generate(10, (_) {
      final seq = _sequence(rng, level);
      return numberQuestion(
        rng: rng,
        prompt: quizText(
          '${seq.take(5).join(',  ')},  ?',
          size: 30,
          weight: FontWeight.w700,
        ),
        answer: seq[5],
        spread: 3 + level,
      );
    });

    return QuizRunner(
      session: session,
      questions: questions,
      title: 'Number Patterns',
      instructions: 'What comes next?',
      secondsPerQuestion: max(8, 22 - level * 2),
    );
  }
}

/// Returns six terms; the sixth is the answer.
List<int> _sequence(Random rng, int level) {
  final kinds = level <= 2 ? 2 : (level <= 5 ? 4 : 7);

  switch (rng.nextInt(kinds)) {
    case 0: // arithmetic
      {
        final start = 1 + rng.nextInt(10);
        final step = 2 + rng.nextInt(7);
        return [for (var i = 0; i < 6; i++) start + step * i];
      }
    case 1: // doubling
      {
        final start = 1 + rng.nextInt(4);
        return [for (var i = 0; i < 6; i++) start * (1 << i)];
      }
    case 2: // alternating steps
      {
        final a = 2 + rng.nextInt(5);
        final b = 5 + rng.nextInt(5);
        var value = 2 + rng.nextInt(6);
        final out = <int>[];
        for (var i = 0; i < 6; i++) {
          out.add(value);
          value += i.isEven ? a : b;
        }
        return out;
      }
    case 3: // squares with an offset
      {
        final offset = rng.nextInt(5);
        return [for (var i = 1; i <= 6; i++) i * i + offset];
      }
    case 4: // each term is the sum of the previous two
      {
        final out = [1 + rng.nextInt(4), 2 + rng.nextInt(4)];
        while (out.length < 6) {
          out.add(out[out.length - 1] + out[out.length - 2]);
        }
        return out;
      }
    case 5: // growing steps
      {
        var value = 1 + rng.nextInt(6);
        var step = 1 + rng.nextInt(2);
        final out = <int>[];
        for (var i = 0; i < 6; i++) {
          out.add(value);
          value += step;
          step++;
        }
        return out;
      }
    default: // tripling
      {
        final start = 1 + rng.nextInt(3);
        return [for (var i = 0; i < 6; i++) start * pow(3, i).toInt()];
      }
  }
}
