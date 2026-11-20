import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/category.dart';
import '../../core/mini_game.dart';
import '../../core/reaction_engine.dart';

const _branches = <String, List<String>>{
  'ANIMALS': ['Tiger', 'Falcon', 'Dolphin', 'Rabbit', 'Cobra', 'Eagle', 'Wolf', 'Panda'],
  'FRUITS': ['Mango', 'Cherry', 'Papaya', 'Lemon', 'Plum', 'Guava', 'Melon', 'Peach'],
  'VEHICLES': ['Truck', 'Tram', 'Scooter', 'Ferry', 'Bicycle', 'Rocket', 'Taxi', 'Glider'],
  'BODY PARTS': ['Elbow', 'Ankle', 'Shoulder', 'Wrist', 'Knee', 'Spine', 'Thumb', 'Chin'],
  'INSTRUMENTS': ['Violin', 'Flute', 'Tabla', 'Guitar', 'Piano', 'Drum', 'Sitar', 'Trumpet'],
  'SPORTS': ['Cricket', 'Hockey', 'Tennis', 'Rugby', 'Archery', 'Boxing', 'Squash', 'Karate'],
};

class MindMapGame extends MiniGame {
  const MindMapGame();

  @override
  String get id => 'mind_map';

  @override
  String get title => 'Mind Map Sort';

  @override
  String get description => 'Send each word to the right branch of the map, fast.';

  @override
  Category get category => Category.mindMapping;

  @override
  Widget build(BuildContext context, GameSession session) {
    final level = session.level;
    final rng = Random(session.seed);

    // More branches (and less time) at higher levels.
    final branchCount = level <= 3 ? 2 : (level <= 7 ? 3 : 4);
    final names = (_branches.keys.toList()..shuffle(rng)).take(branchCount).toList();

    final trials = List<ReactionTrial>.generate(24, (_) {
      final branch = names[rng.nextInt(names.length)];
      final words = _branches[branch]!;
      final word = words[rng.nextInt(words.length)];
      return ReactionTrial(
        stimulus: Text(
          word,
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800),
        ),
        correct: branch,
      );
    });

    return ReactionRunner(
      session: session,
      trials: trials,
      options: [for (final b in names) ReactionOption(value: b, label: b)],
      responseWindowMs: max(1400, 3200 - level * 160),
      title: 'Mind Map Sort',
      instructions: 'Tap the branch the word belongs to.',
      buttonHeight: 64,
    );
  }
}
