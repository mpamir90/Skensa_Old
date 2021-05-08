import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skensa/SkensaComunity/Home.dart';
import 'package:skensa/SkensaComunity/api/TugasApi.dart';

class IsiTugas extends StatefulWidget {
  String fileIsi;
  String judul;
  String kelas;
  bool actionButton;
  IsiTugas(this.fileIsi, this.judul, this.kelas, {this.actionButton});
  @override
  _IsiTugasState createState() => _IsiTugasState();
}

class _IsiTugasState extends State<IsiTugas> {
  List listFile;
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.judul),
          actions: (widget.actionButton) ? null : hapusTugas(context)),
      floatingActionButton: (widget.actionButton)
          ? buildFloatingActionButton(context)
          : SizedBox(),
      body: Container(
        child: FutureBuilder(
            future: TugasApi().getTugas(widget.kelas, widget.fileIsi),
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  // TODO: Handle this case.
                  return Container();
                  break;
                case ConnectionState.waiting:
                  // TODO: Handle this case.
                  return Container();
                  break;
                case ConnectionState.active:
                  // TODO: Handle this case.
                  return Container();
                  break;
                case ConnectionState.done:
                  // TODO: Handle this case.

                  _isLoading = false;
                  if (snapshot.hasError) {
                    return Text("error :" + snapshot.error.toString());
                  } else {
                    if (snapshot.data["file_tugas"].length > 0) {
                      listFile = snapshot.data["file_tugas"];
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          flex: 3,
                          child: Container(
                            child: ListView(
                              children: [
                                Text(
                                  snapshot.data["isi"],
                                  style: TextStyle(fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                        ),
                        (snapshot.data["file_tugas"].length > 0)
                            ? buildFileTersedia(context, snapshot)
                            : SizedBox()
                      ],
                    );
                  }
                  break;
              }
            }),
      ),
    );
  }

  List<Widget> hapusTugas(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(
          Icons.delete,
          size: 30,
        ),
        onPressed: () {
          if (!_isLoading) {
            showDialog(
                context: (context),
                builder: (context) => AlertDialog(
                      title: Text("Konfirmasi Penghapusan Tugas"),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: CupertinoButton(
                              child: Text(
                                "Hapus",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              onPressed: () {
                                TugasApi()
                                    .deleteTugas(widget.fileIsi, widget.kelas,
                                        fileTugas: listFile)
                                    .then((value) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Beranda()));
                                });
                              },
                            ),
                          ),
                          Flexible(
                            child: CupertinoButton(
                              child: Text("Batal"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ));
          }
        },
        color: Colors.redAccent,
      )
    ];
  }

  Flexible buildFileTersedia(
      BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(9.0),
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
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: snapshot.data["file_tugas"].length,
                itemBuilder: (context, i) => InkWell(
                  onTap: () {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Row(
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Downloading"),
                        ],
                      ),
                      backgroundColor: Colors.blue,
                      duration: Duration(seconds: 1),
                    ));
                    TugasApi()
                        .pickFile(
                      widget.kelas,
                      snapshot.data["file_tugas"][i],
                    )
                        .then((value) {
                      if (value != null) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 4),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                  child: Text("File Tersimpan Di " + value)),
                              GestureDetector(
                                  onTap: () {
                                    TugasApi().openFile(value);
                                  },
                                  child: Flexible(
                                      child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text("Buka File"),
                                  ))),
                            ],
                          ),
                          backgroundColor: Colors.green,
                        ));
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 4),
                          content: Text("File Tidak Tersimpan"),
                          backgroundColor: Colors.red,
                        ));
                      }
                    });
                  },
                  child: Card(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.insert_drive_file,
                          size: 30,
                        ),
                        Flexible(child: Text(snapshot.data["file_tugas"][i]))
                      ],
                    ),
                  ),
                ),
              ),
            ))
          ],
        )),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      label: Text("Kerjakan"),
      onPressed: () {
        showModalBottomSheet(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            context: (context),
            builder: (context) => Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Text("Upload Tugas"),
                        RaisedButton(
                          child: Text("Upload File"),
                          onPressed: () {
                            showDialog(
                                context: (context),
                                builder: (context) => AlertDialog(
                                      title: Text(
                                          "Fitur Ini Belum Siap Digunakan"),
                                      content: CupertinoButton(
                                          child: Text("Ok"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                    ));
                          },
                        )
                      ],
                    ),
                  ),
                ));
      },
    );
  }
}
