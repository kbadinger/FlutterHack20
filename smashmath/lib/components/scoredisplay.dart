import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:smashmath/smash-game.dart';

class ScoreDisplay {
  final SmashGame game;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  ScoreDisplay(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
        color: Color(0xffffffff), fontSize: 30, fontFamily: 'Prstart');

    position = Offset.zero;
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }

  void update(double t) {
    if ((painter.text?.text ?? '') != game.score.toString()) {
      painter.text = TextSpan(
        text: game.score.toString(),
        style: textStyle,
      );

      painter.layout();

      position = Offset(
        10 + (painter.width / 2),
        25 + (painter.height / 2),
      );
    }
  }
}
