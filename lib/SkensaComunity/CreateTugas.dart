import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skensa/SkensaComunity/Home.dart';

import 'package:skensa/SkensaComunity/api/TugasApi.dart';

class CreateTugas extends StatefulWidget {
  @override
  _CreateTugasState createState() => _CreateTugasState();
}

class _CreateTugasState extends State<CreateTugas> {
  List<File> myFile = [];
  List<String> listKelas = [];
  TextEditingController isi = TextEditingController();
  TextEditingController namaTugas = TextEditingController();
  TextEditingController tglExpired = TextEditingController();
  bool rpl2 = false;
  bool mm = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: GestureDetector(onTap: () {}, child: Text("Buat Tugas Baru")),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    context: (context),
                    builder: (context) => StatefulBuilder(
                          builder: (context, setter) => Container(
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 30, 0, 20),
                                    child: Text("Pilih Kelas",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                                Container(
                                  height: 3,
                                  color: Colors.grey,
                                ),
                                Expanded(
                                  child: Container(
                                      child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: TextFormField(
                                          controller: namaTugas,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            prefixText: "Nama Tugas : ",
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: TextFormField(
                                          controller: tglExpired,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              prefixText: "Tgl Expired : ",
                                              hintText: "YY-MM-DD"),
                                        ),
                                      ),
                                      CheckboxListTile(
                                          title: Text("XII RPL-2"),
                                          value: rpl2,
                                          onChanged: (value) {
                                            rpl2 = value;
                                            (value)
                                                ? listKelas.add("XII RPL-2")
                                                : listKelas.remove("XII RPL-2");
                                            debugPrint(listKelas.toString());
                                            setter(() {});
                                          }),
                                      CheckboxListTile(
                                          title: Text("XII MM-1"),
                                          value: mm,
                                          onChanged: (value) {
                                            mm = value;
                                            (value)
                                                ? listKelas.add("XII MM-1")
                                                : listKelas.remove("XII MM-1");
                                            debugPrint(listKelas.toString());
                                            setter(() {});
                                          }),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          CupertinoButton(
                                            color: Colors.lightBlue,
                                            child: Text("Tambah"),
                                            onPressed: () {
                                              if (listKelas.length > 0) {
                                                FutureBuilder(
                                                    future: TugasApi()
                                                        .uploadTugas(
                                                            isi.text,
                                                            listKelas,
                                                            namaTugas.text,
                                                            tglExpired.text,
                                                            listFile: myFile),
                                                    builder: (context,
                                                        AsyncSnapshot<bool>
                                                            snapshot) {
                                                      switch (snapshot
                                                          .connectionState) {
                                                        case ConnectionState
                                                            .none:
                                                          return CircularProgressIndicator();
                                                          break;
                                                        case ConnectionState
                                                            .waiting:
                                                          return CircularProgressIndicator();
                                                          break;
                                                        case ConnectionState
                                                            .active:
                                                          return CircularProgressIndicator();
                                                          break;
                                                        case ConnectionState
                                                            .done:
                                                          break;
                                                      }
                                                    });
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Beranda()));
                                              } else {
                                                showDialog(
                                                    context: (context),
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: Text(
                                                              "Pilih Kelas Terlebih Dahulu"),
                                                          content:
                                                              CupertinoButton(
                                                            color: Colors.blue,
                                                            child: Text("OK"),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        ));
                                              }
                                            },
                                          ),
                                          CupertinoButton(
                                            color: Colors.red,
                                            child: Text("Kembali"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                                )
                              ],
                            ),
                          ),
                        ));
              })
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          TugasApi().pickFileCreateTugas(context).then((value) {
            if (value != null) {
              myFile.add(value);
              setState(() {});
            }
          });
        },
        label: Text("Tambahkan File"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 3,
              child: Container(
                child: Column(
                  children: <Widget>[
                    TextField(
                      maxLines: 9,
                      controller: isi,
                      decoration: InputDecoration(
                        hintText: "Tulis Sesuatu",
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    )
                  ],
                ),
              ),
            ),
            (myFile.length > 0)
                ? buildFlexibleFile(context, myFile)
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Flexible buildFlexibleFile(BuildContext context, List<File> listFile) {
    return Flexible(
        flex: 1,
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.lightBlue,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "File Yang Tersedia",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: ListView.builder(
                      itemCount: listFile.length,
                      itemBuilder: (context, i) => Card(
                              child: Row(
                            children: <Widget>[
                              Icon(Icons.insert_drive_file),
                              Flexible(
                                child: Text(
                                  listFile[i].path.split("/").last,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ))),
                ),
              )
            ],
          ),
        ));
  }
}
