import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:skensa/SkensaComunity/ApiLogin.dart';
import 'package:skensa/SkensaComunity/api/server.dart';

class TugasApi {
  String _server = Server().myserver;

  ///Untuk Mengambil Data Tugas
  Future<Map<String, dynamic>> getTugas(String kelas, String fileIsi) async {
    http.Response respon =
        await http.get(_server + "Tugas/" + kelas + "/" + fileIsi);
    Map<String, dynamic> result = json.decode(respon.body);
    debugPrint(respon.body);
    return result;
  }

  //Untuk Mendownload file Server
  Future<String> pickFile(String kelas, String fileName) async {
    PermissionStatus izin = await Permission.storage.request();
    Directory dir =
        (await getExternalStorageDirectory()).parent.parent.parent.parent;
    // File myFile = await pick.FilePicker.getFile();

    Uint8List respon =
        await http.readBytes(_server + "Tugas/" + kelas + "/File/" + fileName);
    // Uint8List byte = respon.bodyBytes;
    Directory appFolderDownload = Directory(dir.path + "/Skensa");
    debugPrint(appFolderDownload.path);

    if (await appFolderDownload.exists() == false) {
      await appFolderDownload.create();
    }
    File imeg = File(appFolderDownload.path + "/" + fileName);

    await imeg.writeAsBytes(respon);
    return imeg.path;
  }

  void openFile(String path) {
    OpenFile.open(path);
  }

  Future deleteTugas(String namaFile, String kelas, {List fileTugas}) async {
    String listFile = "";
    if (fileTugas != null) {
      for (var i = 0; i < fileTugas.length; i++) {
        listFile += fileTugas[i] + "/";
      }
    }
    debugPrint(listFile);
    http.Response respon = await http.post(_server + "HapusTugas.php",
        body: {"isiTugas": namaFile, "listFile": listFile, "namaKelas": kelas});
  }

  Future<bool> uploadTugas(
      String isi, List<String> listKelas, String namaTugas, String tglExpired,
      {List<File> listFile}) async {
    Directory interDir = await getApplicationDocumentsDirectory();
    Directory dirUpload = Directory(interDir.path + "UploadTugas");
    File fileJson = File(dirUpload.path + "/" + "fileJson.json");
    await dirUpload.create();
    await fileJson.create();
    List<String> tugasFileJson = [];
    if (listFile.length > 0) {
      for (var i = 0; i < listFile.length; i++) {
        tugasFileJson.add(listFile[i].path.split("/").last);
      }
    }

    Map<String, dynamic> isiJson = {"isi": isi, "file_tugas": tugasFileJson};

    if (await dirUpload.exists()) {
      debugPrint("directory ada");
      if (await fileJson.exists()) {
        debugPrint("file ada");
        debugPrint(json.encode(isiJson));
        await fileJson.writeAsString(json.encode(isiJson));
        http.Response respon;

        for (var i = 0; i < listFile.length; i++) {
          for (var i2 = 0; i2 < listKelas.length; i2++) {
            String base64File = base64Encode(await listFile[i].readAsBytes());
            respon = await http.post(_server + "/Upload.php", body: {
              "file": base64File,
              "nama": listFile[i].path.split("/").last,
              "dir": "Tugas/" + listKelas[i2] + "/File/"
            });
            debugPrint(respon.body);
          }
        }
        String fileNameJson = namaTugas +
            DateTime.now().hour.toString() +
            DateTime.now().minute.toString() +
            DateTime.now().second.toString() +
            ".json";
        String fileJsonEncode = base64Encode(await fileJson.readAsBytes());

        for (var i = 0; i < listKelas.length; i++) {
          respon = await http.post(_server + "Upload.php", body: {
            "file": fileJsonEncode,
            "nama": fileNameJson,
            "dir": "Tugas/" + listKelas[i] + "/"
          });
          debugPrint(respon.body);
        }

        int idGuru = await ApiData().getIntProfile("idPengguna");
        for (var i = 0; i < listKelas.length; i++) {
          Map<String, dynamic> idKelas = await searchKelas(listKelas[i]);
          respon = await http.post(_server + "InsertTugas.php", body: {
            "namaTugas": namaTugas,
            "namaIsiTugas": fileNameJson,
            "idGuru": idGuru.toString(),
            "idKelas": idKelas["result"][0]["id_kelas"],
            "tglExpired": tglExpired,
            "published": "2020-07-29"
          });

          debugPrint(namaTugas);
          debugPrint(fileNameJson);
          debugPrint(idGuru.toString());
          debugPrint(idKelas["result"][0]["id_kelas"]);
          debugPrint(respon.body);
        }
        return true;
      } else {
        debugPrint("file tidak ada.File akan dibuat");
        await fileJson.create();
      }
    } else {
      debugPrint("directory Tidak Ada.Directory Akan Dibuat");
      await dirUpload.create();
      if (await dirUpload.exists()) {
        debugPrint("directory berhasil dibuat");
      } else {
        debugPrint("gagal Dibuat");
      }
    }
  }

  Future<Map<String, dynamic>> searchKelas(String namaKelas) async {
    http.Response respon = await http
        .post(_server + "searchKelas.php", body: {"namaKelas": namaKelas});
    Map<String, dynamic> result = jsonDecode(respon.body);
    return result;
  }

  Future<File> pickFileCreateTugas(BuildContext context) async {
    PermissionStatus izin = await Permission.storage.request();
    if (izin.isGranted) {
      Directory dir = await getExternalStorageDirectory();

      File myFile = await FilePicker.getFile();
      if (myFile != null) {
        if (await myFile.length() > 20000000) {
          showDialog(
              context: (context),
              builder: (context) => AlertDialog(
                    title: Text("File Tidak Boleh Lebih Dari 20mb"),
                  ));
        } else {
          return myFile;
        }
      } else {
        return null;
      }
    }
  }

  Future<Map<String, dynamic>> getPelajaranApi() async {
    try {
      http.Response respon = await http.post(_server + "GetPelajaran.php",
          body: {"idKelas": await ApiData().getStringProfile("id_kelas")});
      Map<String, dynamic> result = json.decode(respon.body);
      debugPrint(result.toString());
      return result;
    } catch (e) {
      debugPrint(e);
    }
  }

  Future<Map<String, dynamic>> getDataApiGuru() async {
    int no = await ApiData().getIntProfile("idPengguna");

    http.Response respon = await http.post(
      _server + "TugasGuru.php",
      body: {"idGuru": no.toString()},
    );
    Map<String, dynamic> result = json.decode(respon.body);
    debugPrint(result.toString());

    return result;
  }

  Future<Map<String, dynamic>> getDataApi(
      BuildContext context, int idKelas, String idGuru) async {
    try {
      http.Response respon = await http.post(_server + "Tugas.php", body: {
        "idGuru": idGuru,
        "id_kelas": idKelas.toString(),
      });
      Map<String, dynamic> result = json.decode(respon.body);
      debugPrint(result.toString());
      return result;
    } catch (e) {
      showDialog(
          context: (context),
          builder: (context) => Dialog(
                child: Text(e.toString()),
              ));
    }
  }
}
