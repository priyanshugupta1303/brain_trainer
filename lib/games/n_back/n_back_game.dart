import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';

class NBackGame extends MiniGame {
  const NBackGame();

  @override
  String get id => 'n_back';

  @override
  String get title => 'N-Back';

  @override
  String get description =>
      'Tap MATCH when the lit square is the same as the one N steps ago.';

  @override
  Category get category => Category.workingMemory;

  @override
  Widget build(BuildContext context, GameSession session) =>
      _NBackView(session: session);
}

class _NBackView extends StatefulWidget {
  const _NBackView({required this.session});

  final GameSession session;

  @override
  State<_NBackView> createState() => _NBackViewState();
}

class _NBackViewState extends State<_NBackView> {
  late final int n;
  late final int intervalMs;
  late final List<int> seq;

  final _clock = Stopwatch()..start();
  Timer? _nextTimer;
  Timer? _hideTimer;

  int _index = -1;
  bool _visible = false;
  bool _responded = false;
  int _hits = 0;
  int _misses = 0;
  int _falseAlarms = 0;
  int _correctRejects = 0;

  @override
  void initState() {
    super.initState();
    final level = widget.session.level;
    // Levels 1-3 → 1-back, 4-6 → 2-back, 7-10 → 3-back; speed ramps with level.
    n = min(3, 1 + (level - 1) ~/ 3);
    intervalMs = max(1200, 2600 - level * 120);

    final trials = 20 + n;
    final rng = Random(widget.session.seed);
    seq = List<int>.filled(trials, 0);
    for (var i = 0; i < trials; i++) {
      // ~30% of trials are forced matches so targets are not too rare.
      seq[i] = (i >= n && rng.nextDouble() < 0.3) ? seq[i - n] : rng.nextInt(9);
    }
    _nextTimer = Timer(const Duration(milliseconds: 800), _advance);
  }

  bool _isTarget(int i) => i >= n && seq[i] == seq[i - n];

  /// Score the trial that just ended if the player did not tap.
  void _closeTrial() {
    if (_index < n || _responded) return;
    if (_isTarget(_index)) {
      _misses++;
    } else {
      _correctRejects++;
    }
  }

  void _advance() {
    _closeTrial();
    if (_index + 1 >= seq.length) {
      _finish();
      return;
    }
    setState(() {
      _index++;
      _visible = true;
      _responded = false;
    });
    _hideTimer = Timer(
      Duration(milliseconds: (intervalMs * 0.65).round()),
      () {
        if (mounted) setState(() => _visible = false);
      },
    );
    _nextTimer = Timer(Duration(milliseconds: intervalMs), _advance);
  }

  void _tap() {
    if (_index < n || _responded) return;
    setState(() {
      _responded = true;
      if (_isTarget(_index)) {
        _hits++;
      } else {
        _falseAlarms++;
      }
    });
  }

  void _finish() {
    _clock.stop();
    final targets = _hits + _misses;
    final nonTargets = _correctRejects + _falseAlarms;
    final hitRate = targets == 0 ? 1.0 : _hits / targets;
    final rejectRate = nonTargets == 0 ? 1.0 : _correctRejects / nonTargets;
    // Balanced accuracy: tapping never (or always) cannot score well.
    final performance = ((hitRate + rejectRate) / 2).clamp(0.0, 1.0).toDouble();
    final score = max(0, _hits * 100 - _falseAlarms * 50 - _misses * 25);

    widget.session.onFinished(
      GameResult(score: score, performance: performance, duration: _clock.elapsed),
    );
  }

  @override
  void dispose() {
    _nextTimer?.cancel();
    _hideTimer?.cancel();
    _clock.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final started = _index >= 0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text('$n-back', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(started ? 'Trial ${_index + 1} / ${seq.length}' : 'Get ready…'),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (var i = 0; i < 9; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 80),
                        decoration: BoxDecoration(
                          color: (started && _visible && seq[_index] == i)
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: FilledButton(
              onPressed: started ? _tap : null,
              child: Text(_responded ? 'Recorded' : 'MATCH'),
            ),
          ),
        ],
      ),
    );
  }
}
