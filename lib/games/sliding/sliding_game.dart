import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';

class SlidingGame extends MiniGame {
  const SlidingGame();

  @override
  String get id => 'sliding';

  @override
  String get title => 'Sliding Puzzle';

  @override
  String get description => 'Slide the tiles into order, 1 to 8, with the gap last.';

  @override
  Category get category => Category.problemSolving;

  @override
  Widget build(BuildContext context, GameSession session) =>
      _SlidingView(session: session);
}

class _SlidingView extends StatefulWidget {
  const _SlidingView({required this.session});

  final GameSession session;

  @override
  State<_SlidingView> createState() => _SlidingViewState();
}

class _SlidingViewState extends State<_SlidingView> {
  late final List<int> _tiles; // 0 is the gap
  late final int _shuffleMoves;
  final _clock = Stopwatch()..start();
  int _moves = 0;

  bool get _solved {
    for (var i = 0; i < 8; i++) {
      if (_tiles[i] != i + 1) return false;
    }
    return _tiles[8] == 0;
  }

  List<int> _neighbours(int p) {
    final r = p ~/ 3;
    final c = p % 3;
    return [
      if (r > 0) p - 3,
      if (r < 2) p + 3,
      if (c > 0) p - 1,
      if (c < 2) p + 1,
    ];
  }

  @override
  void initState() {
    super.initState();
    final rng = Random(widget.session.seed);
    _shuffleMoves = 8 + widget.session.level * 5;

    // Scramble by making legal moves backwards from the solved board, so the
    // puzzle is always solvable. Never undo the previous move immediately.
    _tiles = [1, 2, 3, 4, 5, 6, 7, 8, 0];
    var gap = 8;
    int? previous;
    void slide() {
      final options = _neighbours(gap).where((n) => n != previous).toList();
      final next = options[rng.nextInt(options.length)];
      _tiles[gap] = _tiles[next];
      _tiles[next] = 0;
      previous = gap;
      gap = next;
    }

    for (var k = 0; k < _shuffleMoves; k++) {
      slide();
    }
    if (_solved) slide(); // astronomically unlikely, but never start solved
  }

  void _tap(int p) {
    final gap = _tiles.indexOf(0);
    if (!_neighbours(p).contains(gap)) return;
    setState(() {
      _tiles[gap] = _tiles[p];
      _tiles[p] = 0;
      _moves++;
    });
    if (_solved) _finish();
  }

  void _finish() {
    _clock.stop();
    // The scramble length is roughly the par: matching it is a full score.
    final performance = (_shuffleMoves / _moves).clamp(0.0, 1.0).toDouble();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Sliding Puzzle', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Moves: $_moves  ·  Par: $_shuffleMoves',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (var p = 0; p < 9; p++)
                      if (_tiles[p] == 0)
                        const SizedBox.shrink()
                      else
                        Material(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => _tap(p),
                            child: Center(
                              child: Text(
                                '${_tiles[p]}',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
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
