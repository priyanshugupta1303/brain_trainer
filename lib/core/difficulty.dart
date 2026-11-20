import 'dart:math';

/// Simple staircase: move up on strong rounds, down on weak ones.
int nextLevel(int level, double performance, int maxLevel) {
  if (performance >= 0.8) return min(level + 1, maxLevel);
  if (performance < 0.5) return max(level - 1, 1);
  return level;
}
