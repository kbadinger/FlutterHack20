import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:smashmath/smash-game.dart';

class HighscoreDisplay {
  final SmashGame game;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  HighscoreDisplay(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

   

    textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 15,
      fontFamily: 'Prstart'
    );

    position = Offset.zero;

    updateHighscore();
  }

  void updateHighscore() {
    int highscore = game.store.getInt('highscore') ?? 0;

    painter.text = TextSpan(
      text: 'High Score: ' + highscore.toString(),
      style: textStyle,
    );

    painter.layout();

    position = Offset(
      game.screenSize.width - 10 - painter.width,
      45,
    );
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }
}