import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/difficulty.dart';
import '../../core/mini_game.dart';
import '../../data/providers.dart';

/// Hosts any MiniGame: loads its level, runs a round, saves the result,
/// adjusts difficulty, and offers another round.
class PlayScreen extends ConsumerStatefulWidget {
  const PlayScreen({super.key, required this.game});

  final MiniGame game;

  @override
  ConsumerState<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends ConsumerState<PlayScreen> {
  int? _level;
  int _newLevel = 1;
  int _seed = 0;
  int _runKey = 0;
  bool _saving = false;
  GameResult? _result;

  @override
  void initState() {
    super.initState();
    _startRound();
  }

  Future<void> _startRound() async {
    final level = await ref.read(dbProvider).levelFor(widget.game.id);
    if (!mounted) return;
    setState(() {
      _level = level;
      _seed = Random().nextInt(0x7fffffff);
      _result = null;
      _saving = false;
      _runKey++;
    });
  }

  Future<void> _onFinished(GameResult result) async {
    if (_saving) return;
    _saving = true;

    final db = ref.read(dbProvider);
    final game = widget.game;
    final level = _level!;
    final next = nextLevel(level, result.performance, game.maxLevel);

    await db.addSession(
      gameId: game.id,
      category: game.category.name,
      level: level,
      score: result.score,
      performance: result.performance,
      durationMs: result.duration.inMilliseconds,
    );
    await db.setLevel(game.id, next);

    if (!mounted) return;
    ref.invalidate(levelProvider(game.id));
    ref.invalidate(bestScoreProvider(game.id));
    setState(() {
      _result = result;
      _newLevel = next;
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    final level = _level;
    final result = _result;

    return Scaffold(
      appBar: AppBar(
        title: Text(game.title),
        actions: [
          if (level != null && result == null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(child: Text('Level $level')),
            ),
        ],
      ),
      body: SafeArea(
        child: level == null
            ? const Center(child: CircularProgressIndicator())
            : result != null
                ? _ResultView(
                    result: result,
                    oldLevel: level,
                    newLevel: _newLevel,
                    onPlayAgain: _startRound,
                  )
                : KeyedSubtree(
                    key: ValueKey(_runKey),
                    child: game.build(
                      context,
                      GameSession(
                        level: level,
                        seed: _seed,
                        onFinished: _onFinished,
                      ),
                    ),
                  ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.result,
    required this.oldLevel,
    required this.newLevel,
    required this.onPlayAgain,
  });

  final GameResult result;
  final int oldLevel;
  final int newLevel;
  final VoidCallback onPlayAgain;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final seconds = (result.duration.inMilliseconds / 1000).toStringAsFixed(1);
    final levelText = newLevel > oldLevel
        ? 'Level up: $oldLevel → $newLevel'
        : newLevel < oldLevel
            ? 'Easier next time: level $newLevel'
            : 'Staying at level $newLevel';

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${result.score}', style: textTheme.displayLarge),
              const Text('points'),
              const SizedBox(height: 16),
              Text('${(result.performance * 100).round()}% performance · ${seconds}s'),
              const SizedBox(height: 8),
              Text(levelText, style: textTheme.titleMedium),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onPlayAgain,
                  child: const Text('Play again'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to games'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
