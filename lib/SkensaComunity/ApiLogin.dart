import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:skensa/SkensaComunity/api/server.dart';

class ApiData {
  String _server = Server().myserver;
  void saveLogin(int id) async {
    SharedPreferences dataId = await SharedPreferences.getInstance();
    dataId.setInt("idPengguna", id);
  }

  Future<int> getIntProfile(String key) async {
    SharedPreferences dataId = await SharedPreferences.getInstance();
    return dataId.getInt(key);
  }

  Future<String> getStringProfile(String key) async {
    SharedPreferences dataId = await SharedPreferences.getInstance();
    return dataId.getString(key);
  }

  Future<bool> getBoolProfile(String key) async {
    SharedPreferences dataId = await SharedPreferences.getInstance();
    return dataId.getBool(key);
  }

  Future<bool> getDataGuru(
      BuildContext context, String username, String password) async {
    try {
      String name = username.replaceAll(RegExp(r"[^\w\s]+"), "");
      String pass = password.replaceAll(RegExp(r"[^\w\s]+"), "");
      debugPrint(name);
      debugPrint(pass);
      http.Response respon = await http.post(_server + "loginGuru.php",
          body: {"username": name, "password": pass});
      Map<String, dynamic> result = json.decode(respon.body);
      SharedPreferences dataGuru = await SharedPreferences.getInstance();

      if (result["result"].length == 1) {
        dataGuru.setInt(
            "idPengguna", int.parse(result["result"][0]["id_guru"]));
        dataGuru.setBool("isGuru", true);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> getData(String username, String password) async {
    try {
      String name = username.replaceAll(RegExp(r"[^\w\s]+"), "");
      String pass = password.replaceAll(RegExp(r"[^\w\s]+"), "");
      debugPrint(name);
      debugPrint(pass);
      http.Response getData = await http.post(_server + "login.php",
          body: {"username": username, "password": password});
      debugPrint(getData.body);
      Map<String, dynamic> result = json.decode(getData.body);
      List<Object> hasil = result["result"];
      SharedPreferences dataId = await SharedPreferences.getInstance();

      if (hasil.length == 1) {
        saveLogin(int.parse(result["result"][0]["id_pengguna"]));
        dataId.setString("id_kelas", result["result"][0]["id_kelas"]);
        return true;
      } else {
        return false;
      }
    } on SocketException catch (error) {
      debugPrint("gk ada internet.error is : " + error.osError.toString());
    }
  }
}
