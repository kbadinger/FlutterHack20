import 'dart:math';

import 'package:smashmath/smash-game.dart';
import 'package:smashmath/view.dart';

import 'package:smashmath/components/block.dart';

class GameSpawner {
  final SmashGame game;
  final int maxSpawnInterval = 2500;
  final int minSpawnInterval = 150;
  final int intervalChange = 3;
  final int maxBlocks = 20;
  int currentInterval;
  int nextSpawn;

  GameSpawner(this.game) {
    game.resetBlocks();

    start();
    game.spawn();
  }

  void start() {
    game.resetBlocks();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
  }

  void killAll() {
    game.blocks.forEach((Block bl) => bl.isDead = true);
  }

  void update(double t) {
    if (game.activeView == BMView.playing) {
      int nowTimestamp = DateTime.now().millisecondsSinceEpoch;

      int blks = 0;
      game.blocks.forEach((Block bl) {
        if (!bl.isDead) blks += 1;
      });

      while (blks < 4) {
        game.spawn();

        blks += 1;
      }

      if (game.blocks.length >= maxBlocks) {
        print("max");

        int ct = Random().nextInt(maxBlocks - 3);

        while (ct > 0) {
          ct -= 1;
          game.blocks.removeAt(0);
        }
      }

      if (nowTimestamp >= nextSpawn && blks < maxBlocks) {
        game.spawn();

        if (currentInterval > minSpawnInterval) {
          currentInterval -= intervalChange;
          currentInterval -= (currentInterval * .02).toInt();
        }
        nextSpawn = nowTimestamp + currentInterval;
      }
    }
  }
}
