import 'dart:ui';
import 'package:smashmath/smash-game.dart';
import 'dart:math';
import 'package:flutter/painting.dart';

import 'package:flame/sprite.dart';
import 'package:smashmath/view.dart';

class Block {
  final SmashGame game;
  Rect blRect;

  bool isDead = false;
  bool isOffScreen = false;
  Random rnd;

  Random rndAnswer;

  List<Sprite> deadSprite;
  Sprite blockSprite;
  double spriteIndex = 0;

  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  int theValue = 0;

  TextPainter painterAns;
  TextStyle textStyleAns;
  Offset positionAns;
  double xval;
  double yval;

  Block(this.game, double x, double y) {
    blRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);

    xval = x;
    yval = y;

    position = Offset.zero;
    positionAns = Offset.zero;

    rndAnswer = Random();

    bool hasValue = false;

    game.blocks.forEach((Block bl) {
      if (bl.theValue == game.currentAnswer) {
        hasValue = true;
      }
    });

    if (hasValue) {
      theValue = rndAnswer.nextInt(100);
    } else {
      theValue = game.currentAnswer;
    }

    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
        color: Color(0xffffffff), fontSize: 30, fontFamily: 'Prstart');

    painterAns = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyleAns = TextStyle(
        color: Color(0xffffffff), fontSize: 12, fontFamily: 'Prstart');

    rnd = Random();

    deadSprite = List<Sprite>();

    deadSprite.add(Sprite('drop1.png'));
    deadSprite.add(Sprite('drop2.png'));
    blockSprite = Sprite('block.png');
  }
  void render(Canvas c) {
    painter.paint(c, position);

    if (isDead) {
      deadSprite[spriteIndex.toInt()].renderRect(c, blRect.inflate(2));
    } else {
      blockSprite.renderRect(c, blRect.inflate(2));

      painterAns.paint(c, positionAns);
    }
  }

  void update(double t) {
    if (isDead) {
      int x = rnd.nextInt(12) + 10;

      spriteIndex += 30 * t;
      if (spriteIndex >= 2) {
        spriteIndex -= 2;
      }

      blRect = blRect.translate(0, game.tileSize * x * t);
    }

    if ((painter.text?.text ?? '') != game.problemString) {
      painter.text = TextSpan(
        text: game.problemString,
        style: textStyle,
      );

      painter.layout();

      position = Offset(
        (game.screenSize.width / 2) - (painter.width / 2),
        30 + (painter.height * 1.5),
      );
    }

    if ((painterAns.text?.text ?? '') != theValue.toString()) {
      painterAns.text = TextSpan(
        text: theValue.toString(),
        style: textStyleAns,
      );

      painterAns.layout();

      positionAns = Offset(xval + blRect.width / 2 - painterAns.width / 2,
          yval + blRect.height / 2 - painterAns.height / 2);
    }

    if (blRect.top > game.screenSize.height) {
      isOffScreen = true;
    }
  }

  void onTapDown() {
    if (game.activeView == BMView.playing) {
      if (!isDead) {
        isDead = true;

        if (game.activeView == BMView.playing) {
          game.score += 1;
          game.nextProblem();

          if (game.score > (game.store.getInt('highscore') ?? 0)) {
            game.store.setInt('highscore', game.score);
            game.highscoreDisplay.updateHighscore();
          }
        }
      }
    }
  }
}
