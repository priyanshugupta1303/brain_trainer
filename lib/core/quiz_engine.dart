import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'mini_game.dart';

/// One multiple-choice question. Prompt and choices are widgets, so a game can
/// show text, tables, shapes or anything else.
class QuizQuestion {
  const QuizQuestion({
    required this.prompt,
    required this.choices,
    required this.correctIndex,
  });

  final Widget prompt;
  final List<Widget> choices;
  final int correctIndex;
}

Widget quizText(
  String text, {
  double size = 28,
  bool mono = false,
  FontWeight? weight,
  TextAlign align = TextAlign.center,
}) {
  return Text(
    text,
    textAlign: align,
    style: TextStyle(
      fontSize: size,
      fontWeight: weight,
      fontFamily: mono ? 'monospace' : null,
      height: 1.3,
    ),
  );
}

Widget quizChoice(String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
  );
}

/// A question whose choices are numbers: the answer plus three nearby wrong
/// numbers. [spread] is how far away the wrong numbers can be (keep it >= 3).
QuizQuestion numberQuestion({
  required Random rng,
  required Widget prompt,
  required int answer,
  int spread = 6,
}) {
  final options = <int>{answer};
  var guard = 0;
  while (options.length < 4 && guard++ < 200) {
    final delta = 1 + rng.nextInt(spread);
    options.add(rng.nextBool() ? answer + delta : answer - delta);
  }
  final list = options.toList()..shuffle(rng);
  return QuizQuestion(
    prompt: prompt,
    choices: [for (final o in list) quizChoice('$o')],
    correctIndex: list.indexOf(answer),
  );
}

/// A question whose choices are text. [options] must contain [answer].
QuizQuestion textQuestion({
  required Random rng,
  required Widget prompt,
  required String answer,
  required List<String> options,
  bool shuffle = true,
}) {
  final list = [...options];
  if (shuffle) list.shuffle(rng);
  return QuizQuestion(
    prompt: prompt,
    choices: [for (final o in list) quizChoice(o)],
    correctIndex: list.indexOf(answer),
  );
}

/// Shared engine for "read a question, pick an answer" games: calculation,
/// logic, patterns, matrices, code tracing, and so on.
class QuizRunner extends StatefulWidget {
  const QuizRunner({
    super.key,
    required this.session,
    required this.questions,
    required this.title,
    required this.instructions,
    this.secondsPerQuestion,
    this.choiceHeight = 64,
  });

  final GameSession session;
  final List<QuizQuestion> questions;
  final String title;
  final String instructions;

  /// Null means no time limit.
  final int? secondsPerQuestion;
  final double choiceHeight;

  @override
  State<QuizRunner> createState() => _QuizRunnerState();
}

class _QuizRunnerState extends State<QuizRunner> {
  final _runClock = Stopwatch()..start();
  final _questionClock = Stopwatch();
  Timer? _timer;

  int _index = 0;
  int? _picked; // chosen index, -1 if time ran out, null while unanswered
  int _correct = 0;
  int _speedBonus = 0;

  @override
  void initState() {
    super.initState();
    _startQuestion();
  }

  void _startQuestion() {
    _questionClock
      ..reset()
      ..start();
    final seconds = widget.secondsPerQuestion;
    if (seconds != null) {
      _timer = Timer(Duration(seconds: seconds), () => _answer(-1));
    }
  }

  void _answer(int choice) {
    if (_picked != null) return;
    _timer?.cancel();

    final ok = choice == widget.questions[_index].correctIndex;
    if (ok) {
      _correct++;
      final seconds = widget.secondsPerQuestion;
      if (seconds != null) {
        final speed = 1 - _questionClock.elapsedMilliseconds / (seconds * 1000);
        _speedBonus += (speed.clamp(0.0, 1.0) * 50).round();
      }
    }
    setState(() => _picked = choice);
    _timer = Timer(Duration(milliseconds: ok ? 600 : 1200), _next);
  }

  void _next() {
    if (_index + 1 >= widget.questions.length) {
      _finish();
      return;
    }
    setState(() {
      _index++;
      _picked = null;
    });
    _startQuestion();
  }

  void _finish() {
    _runClock.stop();
    widget.session.onFinished(
      GameResult(
        score: _correct * 100 + _speedBonus,
        performance: _correct / widget.questions.length,
        duration: _runClock.elapsed,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _runClock.stop();
    _questionClock.stop();
    super.dispose();
  }

  (Color?, Color?) _colors(ThemeData theme, int i, int correct, int? picked) {
    if (picked == null) return (null, null);
    if (i == correct) return (Colors.green.shade700, Colors.white);
    if (i == picked) return (theme.colorScheme.error, theme.colorScheme.onError);
    return (
      theme.colorScheme.surfaceContainerHighest,
      theme.colorScheme.onSurfaceVariant,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = widget.questions[_index];
    final picked = _picked;
    final seconds = widget.secondsPerQuestion;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(widget.title, style: theme.textTheme.titleLarge),
          if (widget.instructions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                widget.instructions,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            'Question ${_index + 1} / ${widget.questions.length}',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          if (seconds != null && picked == null)
            TweenAnimationBuilder<double>(
              key: ValueKey(_index),
              tween: Tween(begin: 1.0, end: 0.0),
              duration: Duration(seconds: seconds),
              builder: (context, value, _) =>
                  LinearProgressIndicator(value: value),
            )
          else
            const SizedBox(height: 4),
          Expanded(
            child: Center(
              child: SingleChildScrollView(child: question.prompt),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 12.0;
              final width = (constraints.maxWidth - spacing) / 2;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (var i = 0; i < question.choices.length; i++)
                    SizedBox(
                      width: width,
                      height: widget.choiceHeight,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              _colors(theme, i, question.correctIndex, picked).$1,
                          foregroundColor:
                              _colors(theme, i, question.correctIndex, picked).$2,
                        ),
                        onPressed: () => _answer(i),
                        child: question.choices[i],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
