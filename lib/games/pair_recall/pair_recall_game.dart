import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';
import '../../core/quiz_engine.dart';

const _words = [
  'Falcon', 'Maple', 'Lantern', 'Copper', 'Harbor', 'Violet', 'Compass',
  'Meadow', 'Quartz', 'Ember', 'Saddle', 'Willow', 'Anchor', 'Pebble',
  'Velvet', 'Marble', 'Orchard', 'Thistle', 'Beacon', 'Canyon',
];

class PairRecallGame extends MiniGame {
  const PairRecallGame();

  @override
  String get id => 'pair_recall';

  @override
  String get title => 'Pair Recall';

  @override
  String get description =>
      'Memorise word and number pairs, take a short break, then recall them.';

  @override
  Category get category => Category.longTermMemory;

  @override
  Widget build(BuildContext context, GameSession session) =>
      _PairView(session: session);
}

enum _Phase { study, distract, recall }

class _PairView extends StatefulWidget {
  const _PairView({required this.session});

  final GameSession session;

  @override
  State<_PairView> createState() => _PairViewState();
}

class _PairViewState extends State<_PairView> {
  late final List<(String, int)> _pairs;
  late final List<QuizQuestion> _sums;
  late final List<QuizQuestion> _recall;
  late int _secondsLeft;
  Timer? _timer;
  _Phase _phase = _Phase.study;

  @override
  void initState() {
    super.initState();
    final level = widget.session.level;
    final rng = Random(widget.session.seed);

    final count = 4 + level ~/ 2; // 4..9 pairs
    final words = [..._words]..shuffle(rng);
    final numbers =
        (List<int>.generate(90, (i) => i + 10)..shuffle(rng)).take(count).toList();
    _pairs = [for (var i = 0; i < count; i++) (words[i], numbers[i])];

    // The break: a few quick sums so the pairs cannot just be held in mind.
    _sums = List<QuizQuestion>.generate(6, (_) {
      final a = 12 + rng.nextInt(60);
      final b = 12 + rng.nextInt(60);
      return numberQuestion(
        rng: rng,
        prompt: quizText('$a + $b', size: 40, weight: FontWeight.w700),
        answer: a + b,
        spread: 8,
      );
    });

    final order = [..._pairs]..shuffle(rng);
    _recall = [
      for (final (word, number) in order)
        _recallQuestion(rng, word, number, numbers),
    ];

    _secondsLeft = max(12, count * 4 - level);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft <= 1) {
        _startBreak();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  QuizQuestion _recallQuestion(
    Random rng,
    String word,
    int number,
    List<int> pool,
  ) {
    final others = pool.where((n) => n != number).toList()..shuffle(rng);
    final options = [number, ...others.take(3)]..shuffle(rng);
    return QuizQuestion(
      prompt: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          quizText(word, size: 40, weight: FontWeight.w700),
          const SizedBox(height: 8),
          quizText('Which number went with this word?', size: 16),
        ],
      ),
      choices: [for (final o in options) quizChoice('$o')],
      correctIndex: options.indexOf(number),
    );
  }

  void _startBreak() {
    _timer?.cancel();
    if (_phase != _Phase.study || !mounted) return;
    setState(() => _phase = _Phase.distract);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case _Phase.study:
        return _studyView(context);
      case _Phase.distract:
        // Reuse the quiz engine, but intercept its result: when the break ends
        // we move on to recall instead of finishing the game.
        return QuizRunner(
          key: const ValueKey('break'),
          session: GameSession(
            level: widget.session.level,
            seed: widget.session.seed,
            onFinished: (_) {
              if (mounted) setState(() => _phase = _Phase.recall);
            },
          ),
          questions: _sums,
          title: 'Quick sums',
          instructions: 'A short break. Then you will recall the pairs.',
        );
      case _Phase.recall:
        return QuizRunner(
          key: const ValueKey('recall'),
          session: widget.session, // this result is the real game result
          questions: _recall,
          title: 'Recall',
          instructions: 'Pick the number that went with each word.',
        );
    }
  }

  Widget _studyView(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Memorise the pairs', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('$_secondsLeft s left', style: theme.textTheme.bodySmall),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final (word, number) in _pairs)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          '$word  →  $number',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: _startBreak,
              child: const Text("I'm ready"),
            ),
          ),
        ],
      ),
    );
  }
}
