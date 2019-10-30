import 'dart:ui';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:innovation_bridge/dialogs/CommonMessageDialog.dart';
import 'package:innovation_bridge/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils{

  static void setPreference(String key, String value) async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString(key, value);
    }
    catch(e){
      print(e);
    }
  }

  static void setPreferenceInt(String key, int value ) async {
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt(key, value);
    }
    catch(e){
      print(e);
    }
  }

  static Future<String> getAuthToken() async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      return preferences.getString(Constants.AUTH_TOKEN);
    }
    catch(e){
      print(e);
    }
  }

  static void clearPreference() async{
    try{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.remove(Constants.AUTH_TOKEN);
      preferences.remove(Constants.EVENT_NAME);
      preferences.remove(Constants.EVENT_START_DATE);
      preferences.remove(Constants.EVENT_END_DATE);
      preferences.remove(Constants.LAST_DATETIME);
      preferences.remove(Constants.READ_COUNT);
      preferences.clear();
    }
    catch(e){
      print(e);
    }
  }

  static Future<String> getPreference(String key) async{
    var preferenceValue = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    preferenceValue = prefs.get(key);
    return preferenceValue;
  }

  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static showCommonMessageDialog(BuildContext context, String title, String message){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CommonMessageDialog(dialogTitle: title,
          errorMessage: message),
    );
  }
}