import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';
import '../../core/quiz_engine.dart';

typedef _Cells = Set<Point<int>>;

final _dirs = <Point<int>>[
  const Point(1, 0),
  const Point(-1, 0),
  const Point(0, 1),
  const Point(0, -1),
];

class RotationGame extends MiniGame {
  const RotationGame();

  @override
  String get id => 'rotation';

  @override
  String get title => 'Mental Rotation';

  @override
  String get description => 'Pick the shape that is the same piece, just turned (not flipped).';

  @override
  Category get category => Category.spatialIntelligence;

  @override
  Widget build(BuildContext context, GameSession session) {
    final level = session.level;
    final rng = Random(session.seed);
    final questions =
        List<QuizQuestion>.generate(8, (_) => _question(rng, level));

    return QuizRunner(
      session: session,
      questions: questions,
      title: 'Mental Rotation',
      instructions: 'Which option is the same shape rotated? Mirror images are wrong.',
      secondsPerQuestion: max(12, 26 - level),
      choiceHeight: 96,
    );
  }
}

QuizQuestion _question(Random rng, int level) {
  final size = 4 + level ~/ 4; // 4..6 cells
  final base = _randomShape(rng, size);
  final forbidden = _rotationKeys(base); // every orientation of the real shape

  var correct = base;
  for (var i = 1 + rng.nextInt(3); i > 0; i--) {
    correct = _rotate(correct);
  }

  final options = <_Cells>[correct];
  while (options.length < 4) {
    final wrong = _distractor(rng, base, forbidden);
    if (wrong == null) break;
    options.add(wrong);
  }
  options.shuffle(rng);

  return QuizQuestion(
    prompt: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ShapeView(cells: base, cell: 26),
        const SizedBox(height: 8),
        quizText('Which is the same shape, rotated?', size: 18),
      ],
    ),
    choices: [for (final o in options) _ShapeView(cells: o, cell: 16)],
    correctIndex: options.indexOf(correct),
  );
}

// ---- geometry helpers ----

_Cells _normalize(Iterable<Point<int>> cells) {
  final minX = cells.map((p) => p.x).reduce(min);
  final minY = cells.map((p) => p.y).reduce(min);
  return {for (final p in cells) Point(p.x - minX, p.y - minY)};
}

_Cells _rotate(_Cells c) => _normalize([for (final p in c) Point(-p.y, p.x)]);

_Cells _mirror(_Cells c) => _normalize([for (final p in c) Point(-p.x, p.y)]);

String _key(_Cells c) {
  final list = c.toList()
    ..sort((a, b) => a.x != b.x ? a.x.compareTo(b.x) : a.y.compareTo(b.y));
  return list.map((p) => '${p.x},${p.y}').join(';');
}

/// Keys of all four rotations: two shapes are "the same piece" if they share one.
Set<String> _rotationKeys(_Cells c) {
  final keys = <String>{};
  var current = _normalize(c);
  for (var i = 0; i < 4; i++) {
    keys.add(_key(current));
    current = _rotate(current);
  }
  return keys;
}

bool _isConnected(_Cells c) {
  final seen = <Point<int>>{c.first};
  final queue = [c.first];
  while (queue.isNotEmpty) {
    final p = queue.removeLast();
    for (final d in _dirs) {
      final q = Point(p.x + d.x, p.y + d.y);
      if (c.contains(q) && seen.add(q)) queue.add(q);
    }
  }
  return seen.length == c.length;
}

/// Grows a connected shape that fits inside a 4x4 box.
_Cells _randomShape(Random rng, int size) {
  final cells = <Point<int>>{const Point(0, 0)};
  var guard = 0;
  while (cells.length < size && guard++ < 500) {
    final from = cells.elementAt(rng.nextInt(cells.length));
    final dir = _dirs[rng.nextInt(_dirs.length)];
    final next = Point(from.x + dir.x, from.y + dir.y);
    if (cells.contains(next)) continue;

    final test = {...cells, next};
    final xs = test.map((p) => p.x);
    final ys = test.map((p) => p.y);
    if (xs.reduce(max) - xs.reduce(min) >= 4) continue;
    if (ys.reduce(max) - ys.reduce(min) >= 4) continue;
    cells.add(next);
  }
  return _normalize(cells);
}

/// A shape that looks similar but is NOT a rotation of [base]: a mirror image,
/// or the shape with one cell moved. Returns null if none could be found.
_Cells? _distractor(Random rng, _Cells base, Set<String> forbidden) {
  for (var attempt = 0; attempt < 80; attempt++) {
    _Cells candidate;
    if (attempt.isEven) {
      var mirrored = _mirror(base);
      for (var i = rng.nextInt(4); i > 0; i--) {
        mirrored = _rotate(mirrored);
      }
      candidate = mirrored;
    } else {
      final cells = base.toList();
      final removed = cells.removeAt(rng.nextInt(cells.length));
      final anchor = cells[rng.nextInt(cells.length)];
      final dir = _dirs[rng.nextInt(_dirs.length)];
      final added = Point(anchor.x + dir.x, anchor.y + dir.y);
      if (added == removed || cells.contains(added)) continue;
      candidate = _normalize([...cells, added]);
    }

    // Prefer connected shapes; relax that if we keep failing.
    if (attempt < 40 && !_isConnected(candidate)) continue;

    final keys = _rotationKeys(candidate);
    if (keys.any(forbidden.contains)) continue;
    forbidden.addAll(keys); // so no two wrong options are the same shape
    return candidate;
  }
  return null;
}

class _ShapeView extends StatelessWidget {
  const _ShapeView({required this.cells, required this.cell});

  final Set<Point<int>> cells;
  final double cell;

  @override
  Widget build(BuildContext context) {
    // Follow the surrounding text color so the shape stays visible both on the
    // plain page and inside a (possibly colored) answer button.
    final color = DefaultTextStyle.of(context).style.color ?? Colors.black;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var y = 0; y < 4; y++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var x = 0; x < 4; x++)
                Container(
                  width: cell,
                  height: cell,
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: cells.contains(Point(x, y)) ? color : null,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
