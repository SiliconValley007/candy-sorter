import 'package:candy_sorter/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameService {
  const GameService();
  Future<bool> saveNumberOfCandies({required int numberOfCandies}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setInt(noOfCandyKey, numberOfCandies);
  }

  Future<int> getNumberOfCandies() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(noOfCandyKey) ?? 20;
  }

  Future<bool> saveListOfColors({required List<Color> colors}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> stringColors = [];
    for (Color color in colors) {
      stringColors.add(color.value.toString());
    }
    return await sharedPreferences.setStringList(gameColorsKey, stringColors);
  }

  Future<List<Color>> getListOfColors() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> stringColors =
        sharedPreferences.getStringList(gameColorsKey) ?? [];
    if (stringColors.isEmpty) {
      return [
        Colors.red,
        Colors.green,
        Colors.blueGrey,
        Colors.cyan,
        Colors.orange,
      ];
    }
    List<Color> gameColors = [];
    for (String color in stringColors) {
      gameColors.add(Color(int.parse(color)));
    }
    return gameColors;
  }
}
