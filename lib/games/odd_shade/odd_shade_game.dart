import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';

class OddShadeGame extends MiniGame {
  const OddShadeGame();

  @override
  String get id => 'odd_shade';

  @override
  String get title => 'Odd Shade';

  @override
  String get description => 'Spot the one square whose shade is slightly different.';

  @override
  Category get category => Category.visualPerception;

  @override
  Widget build(BuildContext context, GameSession session) =>
      _OddShadeView(session: session);
}

class _OddShadeView extends StatefulWidget {
  const _OddShadeView({required this.session});

  final GameSession session;

  @override
  State<_OddShadeView> createState() => _OddShadeViewState();
}

class _OddShadeViewState extends State<_OddShadeView> {
  static const _rounds = 12;
  static const _secondsPerRound = 8;

  late final Random _rng;
  late final int _size;
  late final double _delta;

  final _runClock = Stopwatch()..start();
  final _roundClock = Stopwatch();
  Timer? _timer;

  int _round = 1;
  int _correct = 0;
  int _speedBonus = 0;
  late double _hue;
  late int _odd;
  late bool _lighter;
  int? _picked; // tapped cell, -1 on timeout, null while waiting

  @override
  void initState() {
    super.initState();
    final level = widget.session.level;
    _rng = Random(widget.session.seed);
    _size = min(6, 3 + (level - 1) ~/ 2); // 3x3 up to 6x6
    _delta = max(0.035, 0.22 - level * 0.02); // smaller difference = harder
    _newRound();
  }

  /// Sets up a round. Callers outside initState wrap this in setState.
  void _newRound() {
    _hue = _rng.nextDouble() * 360;
    _odd = _rng.nextInt(_size * _size);
    _lighter = _rng.nextBool();
    _picked = null;
    _roundClock
      ..reset()
      ..start();
    _timer = Timer(const Duration(seconds: _secondsPerRound), () => _pick(-1));
  }

  void _pick(int cell) {
    if (_picked != null) return;
    _timer?.cancel();

    final ok = cell == _odd;
    if (ok) {
      _correct++;
      final speed = 1 - _roundClock.elapsedMilliseconds / (_secondsPerRound * 1000);
      _speedBonus += (speed.clamp(0.0, 1.0) * 50).round();
    }
    setState(() => _picked = cell);
    _timer = Timer(Duration(milliseconds: ok ? 450 : 1000), _advance);
  }

  void _advance() {
    if (_round >= _rounds) {
      _finish();
      return;
    }
    setState(() {
      _round++;
      _newRound();
    });
  }

  void _finish() {
    _runClock.stop();
    widget.session.onFinished(
      GameResult(
        score: _correct * 100 + _speedBonus,
        performance: _correct / _rounds,
        duration: _runClock.elapsed,
      ),
    );
  }

  Color _cellColor(int i) {
    final lightness = i == _odd ? 0.5 + (_lighter ? _delta : -_delta) : 0.5;
    return HSLColor.fromAHSL(1, _hue, 0.55, lightness.clamp(0.0, 1.0).toDouble())
        .toColor();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _runClock.stop();
    _roundClock.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final picked = _picked;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Odd Shade', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          const Text('Tap the square that looks different.'),
          const SizedBox(height: 4),
          Text('Round $_round / $_rounds', style: theme.textTheme.bodySmall),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.count(
                  crossAxisCount: _size,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (var i = 0; i < _size * _size; i++)
                      GestureDetector(
                        onTap: () => _pick(i),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _cellColor(i),
                            borderRadius: BorderRadius.circular(8),
                            border: picked != null && i == _odd
                                ? Border.all(color: Colors.white, width: 4)
                                : (picked == i
                                    ? Border.all(color: Colors.red, width: 4)
                                    : null),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
