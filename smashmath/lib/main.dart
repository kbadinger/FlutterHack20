import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:smashmath/smash-game.dart';
import 'package:flame/flame.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

 SharedPreferences storage = await SharedPreferences.getInstance();

  Flame.images.loadAll(<String>[
    'background.png',
    'drop1.png',
    'drop2.png',
    'block.png',
    'titlepage.png',
    'start.png',
    'lost.png',
    'icon-help.png',
    'dialoghelp.png'
  ]);

  await Flame.init(fullScreen: true, orientation: DeviceOrientation.portraitUp);

  SmashGame game = SmashGame(storage);

  runApp(game.widget);
}
