import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:smashmath/smash-game.dart';
import 'package:smashmath/view.dart';

class HelpButton {
  final SmashGame game;
  Rect rect;
  Sprite sprite;

  HelpButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * .25,
      game.screenSize.height - (game.tileSize * 1.25),
      game.tileSize,
      game.tileSize,
    );
    sprite = Sprite('icon-help.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void onTapDown() {
    game.activeView = BMView.help;
  }
}