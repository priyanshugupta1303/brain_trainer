import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';

class HanoiGame extends MiniGame {
  const HanoiGame();

  @override
  String get id => 'hanoi';

  @override
  String get title => 'Tower of Hanoi';

  @override
  String get description => 'Move the whole stack to the right peg in as few moves as you can.';

  @override
  Category get category => Category.planning;

  @override
  Widget build(BuildContext context, GameSession session) =>
      _HanoiView(session: session);
}

class _HanoiView extends StatefulWidget {
  const _HanoiView({required this.session});

  final GameSession session;

  @override
  State<_HanoiView> createState() => _HanoiViewState();
}

class _HanoiViewState extends State<_HanoiView> {
  late final int _n; // number of discs
  late final List<List<int>> _pegs; // each peg: bottom -> top, 1 = smallest disc
  final _clock = Stopwatch()..start();
  int? _from;
  int _moves = 0;
  String? _message;

  int get _optimal => (1 << _n) - 1;

  @override
  void initState() {
    super.initState();
    // Levels 1-3 -> 3 discs, 4-6 -> 4, 7-9 -> 5, 10 -> 6.
    _n = 3 + (widget.session.level - 1) ~/ 3;
    _pegs = [
      [for (var d = _n; d >= 1; d--) d],
      <int>[],
      <int>[],
    ];
  }

  void _tap(int i) {
    var moved = false;
    setState(() {
      final from = _from;
      if (from == null) {
        if (_pegs[i].isNotEmpty) {
          _from = i;
          _message = null;
        }
        return;
      }
      if (from == i) {
        _from = null;
        return;
      }
      final disc = _pegs[from].last;
      if (_pegs[i].isNotEmpty && _pegs[i].last < disc) {
        _message = 'A bigger disc cannot sit on a smaller one.';
        _from = null;
        return;
      }
      _pegs[from].removeLast();
      _pegs[i].add(disc);
      _moves++;
      _from = null;
      _message = null;
      moved = true;
    });
    if (moved && _pegs[2].length == _n) _finish();
  }

  void _finish() {
    _clock.stop();
    final performance = (_optimal / _moves).clamp(0.0, 1.0).toDouble();
    widget.session.onFinished(
      GameResult(
        score: (performance * 1000).round(),
        performance: performance,
        duration: _clock.elapsed,
      ),
    );
  }

  @override
  void dispose() {
    _clock.stop();
    super.dispose();
  }

  Widget _peg(BuildContext context, int i) {
    final theme = Theme.of(context);
    final selected = _from == i;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: selected
            ? theme.colorScheme.secondaryContainer
            : theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _tap(i),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth - 8;
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 8,
                    margin: const EdgeInsets.only(top: 24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      for (final d in _pegs[i].reversed)
                        Container(
                          width: maxWidth * (0.3 + 0.7 * d / _n),
                          height: 24,
                          margin: const EdgeInsets.only(bottom: 3),
                          decoration: BoxDecoration(
                            color: HSLColor.fromAHSL(1, d * 360.0 / (_n + 1), 0.6, 0.5)
                                .toColor(),
                            borderRadius: BorderRadius.circular(8),
                            border: selected && d == _pegs[i].last
                                ? Border.all(
                                    color: theme.colorScheme.onSurface,
                                    width: 3,
                                  )
                                : null,
                          ),
                        ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Tower of Hanoi', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Moves: $_moves  ·  Best possible: $_optimal',
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(
            height: 28,
            child: Center(
              child: Text(
                _message ?? '',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < 3; i++) Expanded(child: _peg(context, i)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap a peg to lift its top disc, then tap where to drop it.',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
