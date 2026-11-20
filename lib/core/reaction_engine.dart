import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'mini_game.dart';

/// A button the player can press.
class ReactionOption {
  const ReactionOption({required this.value, required this.label});

  /// What gets compared with [ReactionTrial.correct].
  final Object value;
  final String label;
}

/// One stimulus plus the right response to it.
class ReactionTrial {
  const ReactionTrial({required this.stimulus, this.correct});

  final Widget stimulus;

  /// The [ReactionOption.value] that is correct, or null when the right
  /// move is to NOT respond at all (the "no-go" case).
  final Object? correct;
}

/// Shared engine for "see a stimulus, react quickly and correctly" games:
/// Go/No-Go, Stroop, rule switching, symbol matching, and so on.
///
/// A game only describes its trials and buttons. The engine handles timing,
/// feedback, scoring, and reporting the result to the session.
class ReactionRunner extends StatefulWidget {
  const ReactionRunner({
    super.key,
    required this.session,
    required this.trials,
    required this.options,
    required this.responseWindowMs,
    required this.title,
    required this.instructions,
    this.gapMs = 400,
    this.buttonHeight = 72,
  });

  final GameSession session;
  final List<ReactionTrial> trials;
  final List<ReactionOption> options;

  /// How long the player has to answer each trial.
  final int responseWindowMs;

  /// Pause between trials, during which the result icon is shown.
  final int gapMs;

  /// Height of the answer buttons.
  final double buttonHeight;

  final String title;
  final String instructions;

  @override
  State<ReactionRunner> createState() => _ReactionRunnerState();
}

enum _Phase { intro, stimulus, gap }

class _ReactionRunnerState extends State<ReactionRunner> {
  final _runClock = Stopwatch()..start();
  final _trialClock = Stopwatch();
  Timer? _timer;

  _Phase _phase = _Phase.intro;
  int _index = -1;
  bool? _lastOk;

  int _respondTotal = 0;
  int _respondCorrect = 0;
  int _withholdTotal = 0;
  int _withholdCorrect = 0;
  int _wrong = 0;
  int _speedBonus = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 900), _nextTrial);
  }

  void _nextTrial() {
    if (_index + 1 >= widget.trials.length) {
      _finish();
      return;
    }
    setState(() {
      _index++;
      _phase = _Phase.stimulus;
      _lastOk = null;
    });
    _trialClock
      ..reset()
      ..start();
    _timer = Timer(
      Duration(milliseconds: widget.responseWindowMs),
      () => _endTrial(null), // time ran out = "no response"
    );
  }

  /// Ends the current trial. [response] is null when the player did not press.
  void _endTrial(Object? response) {
    if (_phase != _Phase.stimulus) return;
    _timer?.cancel();

    final reactionMs = _trialClock.elapsedMilliseconds;
    final correct = widget.trials[_index].correct;
    final ok = response == correct;

    if (correct == null) {
      _withholdTotal++;
      if (ok) _withholdCorrect++;
    } else {
      _respondTotal++;
      if (ok) {
        _respondCorrect++;
        // Up to 50 bonus points for answering quickly.
        final speed = 1 - reactionMs / widget.responseWindowMs;
        _speedBonus += (speed.clamp(0.0, 1.0) * 50).round();
      }
    }
    if (!ok) _wrong++;

    setState(() {
      _phase = _Phase.gap;
      _lastOk = ok;
    });
    _timer = Timer(Duration(milliseconds: widget.gapMs), _nextTrial);
  }

  void _respond(Object value) {
    if (_phase == _Phase.stimulus) _endTrial(value);
  }

  void _finish() {
    _runClock.stop();

    // Average the accuracy of "respond" trials and "withhold" trials, so that
    // pressing everything (or nothing) can never score well.
    final rates = <double>[
      if (_respondTotal > 0) _respondCorrect / _respondTotal,
      if (_withholdTotal > 0) _withholdCorrect / _withholdTotal,
    ];
    final performance =
        rates.isEmpty ? 0.0 : rates.reduce((a, b) => a + b) / rates.length;

    final correctCount = _respondCorrect + _withholdCorrect;
    final score = max(0, correctCount * 100 + _speedBonus - _wrong * 50);

    widget.session.onFinished(
      GameResult(
        score: score,
        performance: performance,
        duration: _runClock.elapsed,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _runClock.stop();
    _trialClock.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inTrial = _phase == _Phase.stimulus && _index >= 0;

    Widget stage = const SizedBox.shrink();
    if (inTrial) {
      stage = widget.trials[_index].stimulus;
    } else if (_phase == _Phase.gap && _lastOk != null) {
      final ok = _lastOk!;
      stage = Icon(
        ok ? Icons.check_circle : Icons.cancel,
        size: 72,
        color: ok ? Colors.green : theme.colorScheme.error,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(widget.title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(widget.instructions, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            _index < 0 ? 'Get ready…' : 'Trial ${_index + 1} / ${widget.trials.length}',
            style: theme.textTheme.bodySmall,
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Center(child: stage),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 12.0;
              final single = widget.options.length == 1;
              final width = single
                  ? constraints.maxWidth
                  : (constraints.maxWidth - spacing) / 2;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final option in widget.options)
                    SizedBox(
                      width: width,
                      height: widget.buttonHeight,
                      child: FilledButton(
                        onPressed: inTrial ? () => _respond(option.value) : null,
                        child: Text(
                          option.label,
                          style: const TextStyle(fontSize: 20),
                        ),
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
