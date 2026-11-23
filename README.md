# Brain Trainer

priyanshugupta1303.github.io/brainer_trainer

Offline, cross-platform brain-training games in Flutter. Twenty cognitive
categories; two games implemented so far (N-Back, Schulte Table).

## First-time setup

This archive holds the Dart code only. Generate the platform folders and the
database code once:

    flutter create . --project-name brain_trainer --platforms=android,ios,web,windows,macos,linux
    flutter pub get
    dart run build_runner build --delete-conflicting-outputs
    flutter run

`flutter create .` will not overwrite existing files. Re-run `build_runner`
whenever you change `lib/data/database.dart`.

**Web:** Drift needs `sqlite3.wasm` and `drift_worker.js` in `web/`.
See https://drift.simonbinder.eu/platforms/web/

## Layout

    lib/core/        Category enum, MiniGame contract, registry, difficulty staircase
    lib/data/        Drift database (sessions + per-game level) and Riverpod providers
    lib/features/    Home grid, category list, play host + result screen
    lib/games/       One folder per game

## Adding a game

1. Create `lib/games/<name>/<name>_game.dart` with a class extending `MiniGame`.
2. Build all randomness from `session.seed`; map `session.level` to difficulty.
3. Call `session.onFinished(GameResult(...))` once; `performance` is 0.0–1.0.
4. Add it to `allGames` in `lib/core/game_registry.dart`.

Keep each game's `id` stable: it is the database key for scores and levels.
