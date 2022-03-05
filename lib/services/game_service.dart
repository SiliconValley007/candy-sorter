import 'package:candy_sorter/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameService {
  /// constants constructor
  const GameService();

  /// method to save the number of candies selected by the user to device local storage
  Future<bool> saveNumberOfCandies({required int numberOfCandies}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setInt(noOfCandyKey, numberOfCandies);
  }

  /// method to retrieve the number of candies from device local storage
  Future<int> getNumberOfCandies() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    /// when nothing is stored with this key in local storage, getInt() will return null
    return sharedPreferences.getInt(noOfCandyKey) ?? 20;
  }

  /// save the list of colors selected by the user to local storage
  Future<bool> saveListOfColors({required List<Color> colors}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    /// shared_preferences only has a method to store a list of strings, therefore we need to convert the list of colors to a list of string
    List<String> stringColors = [];
    for (Color color in colors) {
      stringColors.add(color.value.toString());
    }
    /// saving the integer value of the colors as a string to local storage
    return await sharedPreferences.setStringList(gameColorsKey, stringColors);
  }

  /// retrieve the list of String colors from local storage
  Future<List<Color>> getListOfColors() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    /// when there is nothing stored to local storage with the given key, getStringList() will return null
    List<String> stringColors =
        sharedPreferences.getStringList(gameColorsKey) ?? [];
    /// if nothing is stored to local storage, we use this list of colors (these are the colors that will be displayed when the app is first launched, till the time the user saves a new changed list of colors)
    if (stringColors.isEmpty) {
      return [
        Colors.red,
        Colors.green,
        Colors.blueGrey,
        Colors.cyan,
        Colors.orange,
      ];
    }
    /// since we stored the color value as a string, we retrieve that list of strings and convert each string into an integer and that integer into a Color object.
    List<Color> gameColors = [];
    for (String color in stringColors) {
      gameColors.add(Color(int.parse(color)));
    }
    return gameColors;
  }
}
