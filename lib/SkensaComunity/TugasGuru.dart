import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skensa/SkensaComunity/CreateTugas.dart';
import 'package:skensa/SkensaComunity/IsiTugas.dart';
import 'package:skensa/SkensaComunity/api/TugasApi.dart';

class TugasGuru extends StatefulWidget {
  @override
  _TugasGuruState createState() => _TugasGuruState();
}

class _TugasGuruState extends State<TugasGuru> {
  String idTugas;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          label: Text("Tambah Tugas"),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateTugas()));
          }),
      body: Container(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Center(
                  child: Text(
                "Tugas Yang Sudah Dibuat",
                style: TextStyle(fontSize: 30),
              )),
              Expanded(
                  child: Container(
                child: FutureBuilder(
                    future: TugasApi().getDataApiGuru(),
                    builder: (context,
                        AsyncSnapshot<Map<String, dynamic>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Container(
                            child: Center(child: Text("Loading")),
                          );
                          break;
                        case ConnectionState.waiting:
                          return Container(
                            child: Center(child: Text("Loading")),
                          );
                          break;
                        case ConnectionState.active:
                          return Container(
                            child: Center(child: Text("Loading")),
                          );
                          break;
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Text("Error Terdeteksi");
                          } else {
                            return ListView.builder(
                                itemCount: snapshot.data["result"].length,
                                itemBuilder: (context, i) => buildCardTugas(
                                    context,
                                    snapshot.data["result"][i]["nama_tugas"],
                                    snapshot.data["result"][i]["published"],
                                    snapshot.data["result"][i]["kategori"],
                                    snapshot.data["result"][i]
                                        ["nama_isi_tugas"],
                                    snapshot.data["result"][i]["nama_kelas"],
                                    snapshot.data["result"][i]["id_tugas"],
                                    snapshot.data["result"][i]["expired"]));
                          }
                          break;
                      }
                    }),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardTugas(
      BuildContext context,
      String judul,
      String published,
      String kategori,
      String fileIsi,
      String kelas,
      String idTugas,
      String expired) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IsiTugas(
                        fileIsi,
                        judul,
                        kelas,
                        actionButton: false,
                      )));
        },
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    judul,
                    style: TextStyle(fontSize: 18),
                    maxLines: 1,
                  ),
                ],
              ),
              Container(
                height: 1,
                color: Colors.grey[350],
              ),
            ],
          ),
          subtitle: Column(
            children: <Widget>[
              Text(
                "Kategori : " + kategori,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text("Kelas : " + kelas),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("published : " + published),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text("Expired : " + expired),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
