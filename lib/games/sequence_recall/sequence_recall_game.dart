import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';

class SequenceRecallGame extends MiniGame {
  const SequenceRecallGame();

  @override
  String get id => 'sequence_recall';

  @override
  String get title => 'Sequence Recall';

  @override
  String get description => 'Watch the pads flash, then repeat the sequence. It grows each round.';

  @override
  Category get category => Category.shortTermMemory;

  @override
  Widget build(BuildContext context, GameSession session) =>
      _SequenceView(session: session);
}

enum _Phase { watching, input }

class _SequenceView extends StatefulWidget {
  const _SequenceView({required this.session});

  final GameSession session;

  @override
  State<_SequenceView> createState() => _SequenceViewState();
}

class _SequenceViewState extends State<_SequenceView> {
  late final int _pads;
  late final int _cols;
  late final List<int> _seq;
  late final int _flashMs;
  late final int _target;

  final _clock = Stopwatch()..start();
  _Phase _phase = _Phase.watching;
  int _len = 3; // length of the sequence in the current round
  int _inputIndex = 0;
  int _best = 0; // longest sequence repeated correctly
  int? _lit;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    final level = widget.session.level;
    final rng = Random(widget.session.seed);
    _pads = level <= 5 ? 4 : 9;
    _cols = _pads == 4 ? 2 : 3;
    _seq = List<int>.generate(12, (_) => rng.nextInt(_pads));
    _flashMs = max(300, 700 - level * 40);
    _target = min(12, 3 + level); // length that counts as a full score
    _showSequence();
  }

  Future<void> _showSequence() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    for (var i = 0; i < _len; i++) {
      if (!mounted) return;
      setState(() => _lit = _seq[i]);
      await Future<void>.delayed(Duration(milliseconds: _flashMs));
      if (!mounted) return;
      setState(() => _lit = null);
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
    if (!mounted) return;
    setState(() => _phase = _Phase.input);
  }

  void _tap(int pad) {
    if (_phase != _Phase.input || _done) return;

    setState(() => _lit = pad);
    Future<void>.delayed(const Duration(milliseconds: 160), () {
      if (mounted) setState(() => _lit = null);
    });

    if (pad != _seq[_inputIndex]) {
      _finish();
      return;
    }
    _inputIndex++;
    if (_inputIndex == _len) {
      _best = _len;
      if (_len >= _seq.length) {
        _finish();
        return;
      }
      setState(() {
        _len++;
        _inputIndex = 0;
        _phase = _Phase.watching;
      });
      _showSequence();
    }
  }

  void _finish() {
    if (_done) return;
    _done = true;
    _clock.stop();
    widget.session.onFinished(
      GameResult(
        score: _best * 100,
        performance: min(1.0, _best / _target),
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
          Text('Sequence Recall', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            _phase == _Phase.watching ? 'Watch…' : 'Your turn: repeat it',
            style: theme.textTheme.titleMedium,
          ),
          Text('Length $_len', style: theme.textTheme.bodySmall),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.count(
                  crossAxisCount: _cols,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (var i = 0; i < _pads; i++)
                      _Pad(
                        hue: i * 360.0 / _pads,
                        lit: _lit == i,
                        onTap: () => _tap(i),
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

class _Pad extends StatelessWidget {
  const _Pad({required this.hue, required this.lit, required this.onTap});

  final double hue;
  final bool lit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = lit
        ? HSLColor.fromAHSL(1, hue, 0.85, 0.62).toColor()
        : HSLColor.fromAHSL(1, hue, 0.35, 0.28).toColor();
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(borderRadius: BorderRadius.circular(14), onTap: onTap),
    );
  }
}
