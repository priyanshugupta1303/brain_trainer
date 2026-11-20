import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';
import '../../core/quiz_engine.dart';

const _periods = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

class AnalyticalGame extends MiniGame {
  const AnalyticalGame();

  @override
  String get id => 'analytical';

  @override
  String get title => 'Data Detective';

  @override
  String get description => 'Read a small table and answer questions about it.';

  @override
  Category get category => Category.analyticalThinking;

  @override
  Widget build(BuildContext context, GameSession session) {
    final level = session.level;
    final rng = Random(session.seed);
    final questions =
        List<QuizQuestion>.generate(10, (_) => _tableQuestion(rng, level));

    return QuizRunner(
      session: session,
      questions: questions,
      title: 'Data Detective',
      instructions: 'Study the table, then answer.',
      secondsPerQuestion: max(12, 30 - level * 2),
    );
  }
}

QuizQuestion _tableQuestion(Random rng, int level) {
  final n = level <= 3 ? 4 : (level <= 7 ? 5 : 6);
  final pool = List<int>.generate(80, (i) => i + 20)..shuffle(rng);
  final v = pool.take(n).toList(); // distinct, so highest/lowest is unique
  final names = _periods.take(n).toList();

  final table = [
    for (var i = 0; i < n; i++) '${names[i]}  ${v[i].toString().padLeft(3)}',
  ].join('\n');

  Widget prompt(String question) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          quizText(table, size: 22, mono: true),
          const SizedBox(height: 16),
          quizText(question, size: 20),
        ],
      );

  // 0 highest, 1 lowest, 2 difference, 3 total, 4 biggest rise
  var kind = rng.nextInt(level <= 3 ? 3 : (level <= 6 ? 4 : 5));

  var riseIndex = 1;
  if (kind == 4) {
    final rises = [for (var i = 1; i < n; i++) v[i] - v[i - 1]];
    final best = rises.reduce(max);
    if (rises.where((r) => r == best).length == 1) {
      riseIndex = rises.indexOf(best) + 1;
    } else {
      kind = 0; // tie: fall back to an unambiguous question
    }
  }

  switch (kind) {
    case 0:
      {
        final i = v.indexOf(v.reduce(max));
        return textQuestion(
          rng: rng,
          prompt: prompt('Which month has the highest value?'),
          answer: names[i],
          options: names,
        );
      }
    case 1:
      {
        final i = v.indexOf(v.reduce(min));
        return textQuestion(
          rng: rng,
          prompt: prompt('Which month has the lowest value?'),
          answer: names[i],
          options: names,
        );
      }
    case 2:
      {
        final i = rng.nextInt(n);
        var j = rng.nextInt(n - 1);
        if (j >= i) j++;
        return numberQuestion(
          rng: rng,
          prompt: prompt('What is the difference between ${names[i]} and ${names[j]}?'),
          answer: (v[i] - v[j]).abs(),
          spread: 8,
        );
      }
    case 3:
      {
        final i = rng.nextInt(n);
        var j = rng.nextInt(n - 1);
        if (j >= i) j++;
        return numberQuestion(
          rng: rng,
          prompt: prompt('What is ${names[i]} + ${names[j]}?'),
          answer: v[i] + v[j],
          spread: 10,
        );
      }
    default:
      return textQuestion(
        rng: rng,
        prompt: prompt('Which month had the biggest rise from the month before?'),
        answer: names[riseIndex],
        options: names.sublist(1),
      );
  }
}
