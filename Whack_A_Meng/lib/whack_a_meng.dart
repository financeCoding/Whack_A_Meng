library whack_a_meng;

import "dart:async";
import "dart:math";
import 'package:stagexl/stagexl.dart';

part "src/Button.dart";
part "src/Clock.dart";
part "src/EndOfLevelScreen.dart";
part "src/Hammer.dart";
part "src/Hole.dart";
part "src/Level.dart";
part "src/LevelResult.dart";
part "src/LevelSpec.dart";
part "src/NpcVisit.dart";
part "src/ScoreBoard.dart";
part "src/TutorialScreen.dart";
part "src/WelcomeScreen.dart";

class Game extends Sprite {
  ResourceManager _resourceManager;
  int _currentLevelNum = 1;
  Level _currentLevel;

  Game(this._resourceManager) {
    onAddedToStage.listen(_onAddedToStage);
  }

  _onAddedToStage(Event e) {
    var hammer = new Hammer(_resourceManager);
    addChild(hammer);

    onMouseMove.listen((evt) => Hammer.Instance.move(evt));
    onMouseClick.listen((evt) => Hammer.Instance.hit(evt));

    _startLevel();
  }

  _startLevel() {
    _currentLevel = new Level(_resourceManager, _currentLevelNum);
    addChildAt(_currentLevel, 0);

    Mouse.hide();

    _currentLevel.start().then((result) {
      Mouse.show();

      var resultScreen = new EndOfLevelScreen(_resourceManager, result);
      addChild(resultScreen);

      resultScreen.onClose.listen((_) {
        if (result == LevelResult.TimeOut) {
          _currentLevelNum = 1;
        } else {
          _currentLevelNum++;
        }

        removeChild(_currentLevel);
        _startLevel();

        removeChild(resultScreen);
      });
    });
  }
}

abstract class OptionSelector {
  Random _random = new Random();

  dynamic pickOption() {
    List options = getOptions();
    return options[_random.nextInt(options.length)];
  }

  List getOptions();
}