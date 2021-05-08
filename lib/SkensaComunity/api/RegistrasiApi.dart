import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skensa/SkensaComunity/api/server.dart';

class RegistrasiApi {
  final String _server = Server().myserver;
  http.Response respon;
  List lister = [];

  Future<Map<String, dynamic>> getReferance() async {
    respon = await http.get(Uri.parse(_server + "getReferance.php"));
    Map<String, dynamic> result = json.decode(respon.body);
    debugPrint(result.toString());
    return result;
  }

  Future<String> registrasiSiswa(String nama, String email, String password,
      String idKelas, String nisn, BuildContext context) async {
    String namaValid = nama.replaceAll(RegExp(r"[^\w\s]+"), "");
    String emailValid = email.replaceAll(RegExp(r"[^\w\s]+"), "");
    String passwordValid = password.replaceAll(RegExp(r"[^\w\s]+"), "");
    String idKelasValid = idKelas.replaceAll(RegExp(r"[^\w\s]+"), "");
    String nisnValid = nisn.replaceAll(RegExp(r"[^\w\s]+"), "");

    debugPrint(namaValid);
    debugPrint(emailValid);
    debugPrint(passwordValid);
    debugPrint(idKelasValid);
    debugPrint(nisnValid);

    respon = await http.post(_server + "RegistrasiMurid.php", body: {
      "NamaLengkap": namaValid,
      "Email": emailValid,
      "Password": passwordValid,
      "NISN": nisnValid,
      "IdKelas": "1"
    });
    Map<String, dynamic> result = json.decode(respon.body);

    if (result["result"] > 0) {
      showDialog(
          context: (context),
          builder: (context) => AlertDialog(
                title: Text("Akun Berhasil Dibuat"),
                content: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [],
                  ),
                ),
              ));
    } else {}
  }
}
