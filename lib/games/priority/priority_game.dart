import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';
import '../../core/quiz_engine.dart';

const _tasks = [
  'Prepare the quarterly report',
  'Reply to a routine newsletter',
  'Fix the login bug',
  'Book the team lunch',
  'Learn a new framework',
  'Renew a software licence',
  'Tidy the shared folder',
  'Answer a client complaint',
  'Review a colleague\'s pull request',
  'Update the office calendar',
];

const _urgent = ['Due today', 'Due in 2 hours', 'Due tomorrow morning'];
const _notUrgent = ['Due next month', 'No deadline', 'Due next quarter'];
const _important = ['Impact: high', 'Affects a key goal', 'Client-critical'];
const _notImportant = ['Impact: low', 'Nice to have', 'Barely affects goals'];

const _quadrants = ['DO NOW', 'SCHEDULE', 'DELEGATE', 'DROP'];

class PriorityGame extends MiniGame {
  const PriorityGame();

  @override
  String get id => 'priority';

  @override
  String get title => 'Priority Sort';

  @override
  String get description => 'Decide what to do now, schedule, delegate or drop.';

  @override
  Category get category => Category.productivity;

  @override
  Widget build(BuildContext context, GameSession session) {
    final level = session.level;
    final rng = Random(session.seed);

    final questions = List<QuizQuestion>.generate(12, (_) {
      final task = _tasks[rng.nextInt(_tasks.length)];
      final urgent = rng.nextBool();
      final important = rng.nextBool();

      // Early levels always use the plain wording; later levels vary it.
      String pick(List<String> options) =>
          level <= 4 ? options.first : options[rng.nextInt(options.length)];

      final answer = urgent
          ? (important ? 'DO NOW' : 'DELEGATE')
          : (important ? 'SCHEDULE' : 'DROP');

      return textQuestion(
        rng: rng,
        shuffle: false, // fixed button order so the player can learn it
        prompt: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            quizText(task, size: 24, weight: FontWeight.w700),
            const SizedBox(height: 8),
            quizText(pick(urgent ? _urgent : _notUrgent), size: 18),
            quizText(pick(important ? _important : _notImportant), size: 18),
          ],
        ),
        answer: answer,
        options: _quadrants,
      );
    });

    return QuizRunner(
      session: session,
      questions: questions,
      title: 'Priority Sort',
      instructions:
          'DO NOW = urgent + important\nSCHEDULE = important only\nDELEGATE = urgent only\nDROP = neither',
      secondsPerQuestion: max(5, 13 - level),
    );
  }
}
