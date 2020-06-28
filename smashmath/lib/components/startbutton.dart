import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:smashmath/smash-game.dart';
import 'package:smashmath/view.dart';


class StartButton {
  final SmashGame game;
  Rect rect;
  Sprite sprite;

  StartButton(this.game) {
    rect = Rect.fromLTWH(
  game.tileSize * 1.5,
  (game.screenSize.height * .75) - (game.tileSize * 1.5),
  game.tileSize * 6,
  game.tileSize * 3,
);
sprite = Sprite('start.png');

  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}

  void onTapDown() {
game.score = 0;

    game.activeView = BMView.playing;
    game.gameSpawn.start();
  }
}