import 'package:flutter/material.dart';

// Define types
class Variable {
  String? value;
  String? type;
  BlockExpression? nestedBlock;

  Variable({this.value, this.type, this.nestedBlock});
}

class BlockExpression {
  String name;
  Map<String, double> position;
  Variable? var1;
  Variable? var2;

  BlockExpression({
    required this.name,
    required this.position,
    this.var1,
    this.var2,
  });
}

class Chain {
  String id;
  Map<String, double> position;
  List<BlockExpression> blocks;

  Chain({required this.id, required this.position, required this.blocks});
}

class SavedData {
  int currentLevelIndex;
  bool inSandbox;
  int levelsCompleted;
  Map<String, String?> savedRover;
  Map<String, dynamic> levelData;
  Map<String, dynamic> codeChains;

  SavedData({
    this.currentLevelIndex = 0,
    this.inSandbox = false,
    this.levelsCompleted = 20,
    Map<String, String?>? savedRover,
    Map<String, dynamic>? levelData,
    Map<String, dynamic>? codeChains,
  }) : savedRover =
           savedRover ??
           {
             "Wheels": "Basic Wheels",
             "Top": null,
             "Top Front": null,
             "Top Rear": null,
             "Bottom Front": null,
             "Bottom Rear": null,
           },
       levelData = levelData ?? {},
       codeChains = codeChains ?? {};

  SavedData copyWith({
    int? currentLevelIndex,
    bool? inSandbox,
    int? levelsCompleted,
    Map<String, String?>? savedRover,
    Map<String, dynamic>? levelData,
    Map<String, dynamic>? codeChains,
  }) {
    return SavedData(
      currentLevelIndex: currentLevelIndex ?? this.currentLevelIndex,
      inSandbox: inSandbox ?? this.inSandbox,
      levelsCompleted: levelsCompleted ?? this.levelsCompleted,
      savedRover: savedRover ?? this.savedRover,
      levelData: levelData ?? this.levelData,
      codeChains: codeChains ?? this.codeChains,
    );
  }
}

class GlobalState {
  SavedData savedData;
  int levelCount;
  int levelsPerArea;
  Map<String, dynamic> partList;
  Map<String, dynamic> connectionList;
  List<Map<String, dynamic>> areas;
  List<Map<String, dynamic>> levels;

  GlobalState({
    required this.savedData,
    this.levelCount = 24,
    this.levelsPerArea = 6,
    required this.partList,
    required this.connectionList,
    required this.areas,
    required this.levels,
  });
}

class GlobalProvider extends ChangeNotifier {
  late GlobalState _globalState;

  GlobalProvider() {
    _globalState = _getDefaultState();
  }

  GlobalState get globalState => _globalState;

  void setGlobalState(GlobalState newState) {
    _globalState = newState;
    notifyListeners();
  }

  void updateSavedData(SavedData newSavedData) {
    _globalState.savedData = newSavedData;
    notifyListeners();
  }

  void resetState() {
    final currentInSandbox = _globalState.savedData.inSandbox;
    _globalState = _getDefaultState();
    _globalState.savedData.inSandbox = currentInSandbox;
    notifyListeners();
  }

  GlobalState _getDefaultState() {
    return GlobalState(
      savedData: SavedData(),
      levelCount: 24,
      levelsPerArea: 6,
      partList: {
        "Basic Wheels": {
          "unlockCompletion": 0,
          "validConnections": ["Wheels"],
          "hitboxSize": {"x": 750, "y": 250},
        },
        "Claw": {
          "unlockCompletion": 3,
          "validConnections": ["Bottom Front", "Bottom Rear"],
          "hitboxSize": {"x": 110, "y": 80},
        },
        "Omni Wheels": {
          "unlockCompletion": 5,
          "validConnections": ["Wheels"],
          "hitboxSize": {"x": 750, "y": 200},
        },
        "Dish": {
          "unlockCompletion": 10,
          "validConnections": ["Top"],
          "hitboxSize": {"x": 60, "y": 80},
        },
        "Microphone": {
          "unlockCompletion": 16,
          "validConnections": ["Top Front", "Top Rear"],
          "hitboxSize": {"x": 100, "y": 50},
        },
        "Tracks": {
          "unlockCompletion": 7,
          "validConnections": ["Wheels"],
          "hitboxSize": {"x": 900, "y": 200},
        },
        "Scanner": {
          "unlockCompletion": 22,
          "validConnections": ["Top Front", "Top Rear"],
          "hitboxSize": {"x": 110, "y": 60},
        },
        "Mecanum Wheels": {
          "unlockCompletion": 19,
          "validConnections": ["Wheels"],
          "hitboxSize": {"x": 750, "y": 350},
        },
      },
      connectionList: {
        "Wheels": {"zIndex": 3, "transform": []},
        "Top": {"zIndex": 3, "transform": []},
        "Top Front": {"zIndex": 4, "transform": []},
        "Top Rear": {"zIndex": 4, "transform": []},
        "Bottom Front": {"zIndex": 2, "transform": []},
        "Bottom Rear": {"zIndex": 2, "transform": []},
      },
      areas: [
        {"name": "Terra Research Base", "mapScale": 2.5},
        {"name": "The Frontier", "mapScale": 3},
        {"name": "Echo Caverns", "mapScale": 3},
        {"name": "Forgotten Complex", "mapScale": 4},
      ],
      levels: [
        {"id": 1, "name": "Level 1", "x": 13, "y": -80},
        {"id": 2, "name": "Level 2", "x": -187, "y": -78},
        {"id": 3, "name": "Level 3", "x": -187, "y": -17},
        {"id": 4, "name": "Level 4", "x": -187, "y": 83},
        {"id": 5, "name": "Level 5", "x": 13, "y": 43},
        {"id": 6, "name": "Level 6", "x": 173, "y": 83},
        {"id": 7, "name": "Level 7", "x": -170, "y": 80},
        {"id": 8, "name": "Level 8", "x": -160, "y": -50},
        {"id": 9, "name": "Level 9", "x": -30, "y": 50},
        {"id": 10, "name": "Level 10", "x": 80, "y": 120},
        {"id": 11, "name": "Level 11", "x": 130, "y": 20},
        {"id": 12, "name": "Level 12", "x": 160, "y": -60},
        {"id": 13, "name": "Level 13", "x": 140, "y": 80},
        {"id": 14, "name": "Level 14", "x": 40, "y": 90},
        {"id": 15, "name": "Level 15", "x": -40, "y": 110},
        {"id": 16, "name": "Level 16", "x": -90, "y": 20},
        {"id": 17, "name": "Level 17", "x": -150, "y": -110},
        {"id": 18, "name": "Level 18", "x": 50, "y": -120},
        {"id": 19, "name": "Level 19", "x": 25, "y": 100},
        {"id": 20, "name": "Level 20", "x": 55, "y": 13},
        {"id": 21, "name": "Level 21", "x": -36, "y": 43},
        {"id": 22, "name": "Level 22", "x": -6, "y": -18},
        {"id": 23, "name": "Level 23", "x": 45, "y": -59},
        {"id": 24, "name": "Level 24", "x": 14, "y": -108},
      ],
    );
  }
}

class GlobalStorage {
  GlobalStorage._internal();
  static final GlobalStorage _instance = GlobalStorage._internal();
  factory GlobalStorage() => _instance;

  bool inSandbox = false;
  int levelsCompleted = 20;

  void updateInSandbox(bool value) {
    inSandbox = value;
  }
}
