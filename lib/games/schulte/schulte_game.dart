import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';

class SchulteGame extends MiniGame {
  const SchulteGame();

  @override
  String get id => 'schulte';

  @override
  String get title => 'Schulte Table';

  @override
  String get description => 'Tap the numbers in ascending order, as fast as you can.';

  @override
  Category get category => Category.concentration;

  @override
  Widget build(BuildContext context, GameSession session) =>
      _SchulteView(session: session);
}

class _SchulteView extends StatefulWidget {
  const _SchulteView({required this.session});

  final GameSession session;

  @override
  State<_SchulteView> createState() => _SchulteViewState();
}

class _SchulteViewState extends State<_SchulteView> {
  late final int size;
  late final List<int> cells;

  final _clock = Stopwatch()..start();
  int _next = 1;
  int _errors = 0;
  int? _wrong;

  @override
  void initState() {
    super.initState();
    // Levels 1-3 → 3x3, 4-6 → 4x4, 7-9 → 5x5, 10 → 6x6.
    size = min(6, 3 + (widget.session.level - 1) ~/ 3);
    cells = List<int>.generate(size * size, (i) => i + 1)
      ..shuffle(Random(widget.session.seed));
  }

  void _onTap(int value) {
    if (value == _next) {
      setState(() {
        _next++;
        _wrong = null;
      });
      if (_next > cells.length) _finish();
    } else {
      setState(() {
        _errors++;
        _wrong = value;
      });
      Future<void>.delayed(const Duration(milliseconds: 250), () {
        if (mounted) setState(() => _wrong = null);
      });
    }
  }

  void _finish() {
    _clock.stop();
    final count = cells.length;
    final elapsedMs = max(1, _clock.elapsedMilliseconds);
    final targetMs = count * 1500; // 1.5 s per cell counts as a full-marks pace
    final accuracy = count / (count + _errors);
    final speed = (targetMs / elapsedMs).clamp(0.0, 1.0).toDouble();
    final paceBonus = min(2.0, targetMs / elapsedMs);

    widget.session.onFinished(
      GameResult(
        score: (1000 * accuracy * paceBonus).round(),
        performance: accuracy * speed,
        duration: _clock.elapsed,
      ),
    );
  }

  @override
  void dispose() {
    _clock.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final done = _next > cells.length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            done ? 'Done' : 'Find $_next',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text('Mistakes: $_errors'),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.count(
                  crossAxisCount: size,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (final v in cells)
                      _Cell(
                        value: v,
                        done: v < _next,
                        wrong: v == _wrong,
                        onTap: () => _onTap(v),
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

class _Cell extends StatelessWidget {
  const _Cell({
    required this.value,
    required this.done,
    required this.wrong,
    required this.onTap,
  });

  final int value;
  final bool done;
  final bool wrong;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = wrong
        ? scheme.errorContainer
        : done
            ? scheme.surfaceContainerLow
            : scheme.secondaryContainer;

    return Material(
      color: color,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: done ? null : onTap,
        child: Center(
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                '$value',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: done ? scheme.outline : scheme.onSecondaryContainer,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
