import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/gestures.dart';
import 'package:smashmath/components/block.dart';
import 'package:smashmath/components/background.dart';
import 'package:smashmath/components/startbutton.dart';
import 'package:smashmath/controllers/spawn.dart';
import 'package:smashmath/components/helpbutton.dart';
import 'package:smashmath/components/scoredisplay.dart';
import 'package:smashmath/components/highscore.dart';

import 'package:smashmath/views/helpview.dart';
import 'package:smashmath/views/lost.dart';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:smashmath/views/home.dart';
import 'package:smashmath/view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmashGame extends Game with TapDetector {
  final SharedPreferences store;
  Size screenSize;
  double tileSize;
  List<Block> blocks;
  Random rnd;

  Random rndA;
  Random rndB;

  var activeView = BMView.home;
  HomeView homeview;
  StartButton startButton;
  Background bk;
  LostView lostView;
  GameSpawner gameSpawn;
  HelpButton helpButton;
  HelpView helpView;
  int score;
  ScoreDisplay scoreDisplay;
  String problemString;
  int problemA;
  int problemB;
  int oper;
  int currentAnswer;

  HighscoreDisplay highscoreDisplay;

  SmashGame(this.store) {
    initialize();
  }

  void initialize() async {
    blocks = List<Block>();

    rnd = Random();

    rndA = Random();
    rndB = Random();

    resize(await Flame.util.initialDimensions());

    bk = Background(this);
    homeview = HomeView(this);
    startButton = StartButton(this);
    lostView = LostView(this);
    gameSpawn = GameSpawner(this);
    helpButton = HelpButton(this);
    helpView = HelpView(this);
    score = 0;
    highscoreDisplay = HighscoreDisplay(this);

    problemA = rndA.nextInt(10);
    problemB = rndA.nextInt(10);
    currentAnswer = problemA * problemB;

    problemString = "$problemA x $problemB";

    scoreDisplay = ScoreDisplay(this);
  }

  void resetBlocks() {
    blocks = List<Block>();
  }

  void spawn() {
    double x = 0;
    double y = 0;

    bool collide = true;
    bool containsit = false;

    while (collide) {

      x = (rnd.nextDouble() * (screenSize.width - (tileSize * 2))) + tileSize;
      y = (rnd.nextDouble() * (screenSize.height - tileSize - 80)) + 80;

      collide = false;

      Offset os = Offset(x + tileSize/2, y + tileSize/2);

      blocks.forEach((Block bl) {

        if (bl.theValue == currentAnswer)
        {
          containsit = true;
        }

        if (bl.blRect.contains(os)) {
          collide = true;          
         
        }
      });
    }

    blocks.add(Block(this, x, y));


  if (!containsit)
  {
int moreadd = Random().nextInt(3);

while (moreadd > 0)
{
  moreadd -= 1;
  spawn();

}
  }

  }

  void render(Canvas canvas) {
    bk.render(canvas);
    helpButton.render(canvas);
    highscoreDisplay.render(canvas);

    if (activeView == BMView.home) homeview.render(canvas);
    if (activeView == BMView.playing) scoreDisplay.render(canvas);

    if (activeView == BMView.home || activeView == BMView.lost) {
      startButton.render(canvas);
    }

    if (activeView == BMView.help) helpView.render(canvas);

    if (activeView == BMView.lost) lostView.render(canvas);

    if (activeView == BMView.playing) {
      blocks.forEach((Block bl) => bl.render(canvas));
    }
  }

  void update(double t) {
    blocks.forEach((Block bl) => bl.update(t));
    blocks.removeWhere((Block bl) => bl.isOffScreen);
    gameSpawn.update(t);
    if (activeView == BMView.playing) scoreDisplay.update(t);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  void nextProblem() {
    problemA = rndA.nextInt(10);
    problemB = rndA.nextInt(10);
    currentAnswer = problemA * problemB;

    problemString = "$problemA x $problemB";
  }

  void onTapDown(TapDownDetails d) {
    bool isHandled = false;
    bool didSmash = false;

    if (!isHandled) {
      if (activeView == BMView.help) {
        activeView = BMView.home;
        isHandled = true;
      }
    }

    if (!isHandled && startButton.rect.contains(d.globalPosition)) {
      if (activeView == BMView.home || activeView == BMView.lost) {
        startButton.onTapDown();
        isHandled = true;
      }
    }

    if (!isHandled) {
      blocks.forEach((Block bl) {
        if (bl.blRect.contains(d.globalPosition)) {
          if (currentAnswer == bl.theValue) {
            bl.onTapDown();
            isHandled = true;

            didSmash = true;
          }
        }
      });
    }

    if (!isHandled && activeView == BMView.playing && !didSmash) {
      activeView = BMView.lost;
    }

    if (!isHandled && helpButton.rect.contains(d.globalPosition)) {
      if (activeView == BMView.home || activeView == BMView.lost) {
        helpButton.onTapDown();
        isHandled = true;
      }
    }
  }
}
