import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/category.dart';
import '../../core/game_registry.dart';
import '../../data/providers.dart';
import '../play/play_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Brain Trainer')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.05,
        ),
        itemCount: Category.values.length,
        itemBuilder: (context, i) => _CategoryCard(Category.values[i]),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard(this.category);

  final Category category;

  @override
  Widget build(BuildContext context) {
    final count = gamesFor(category).length;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (count == 0) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('${category.label} games are coming soon.')),
              );
            return;
          }
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => CategoryScreen(category: category)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category.icon, size: 36, color: category.color),
              const SizedBox(height: 8),
              Text(
                category.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                count == 0 ? 'Coming soon' : '$count game${count == 1 ? '' : 's'}',
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    final games = gamesFor(category);
    return Scaffold(
      appBar: AppBar(title: Text(category.label)),
      body: ListView.separated(
        itemCount: games.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final game = games[i];
          return ListTile(
            leading: Icon(category.icon, color: category.color),
            title: Text(game.title),
            subtitle: Text(game.description),
            trailing: _GameStats(game.id),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => PlayScreen(game: game)),
            ),
          );
        },
      ),
    );
  }
}

class _GameStats extends ConsumerWidget {
  const _GameStats(this.gameId);

  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final level = ref.watch(levelProvider(gameId)).valueOrNull ?? 1;
    final best = ref.watch(bestScoreProvider(gameId)).valueOrNull;
    return Text(
      best == null ? 'Level $level' : 'Level $level\nBest $best',
      textAlign: TextAlign.end,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
