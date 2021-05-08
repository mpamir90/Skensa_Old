import 'package:flutter/material.dart';
import 'package:skensa/SkensaComunity/IsiTugas.dart';
import 'package:skensa/SkensaComunity/api/TugasApi.dart';

import 'Tugas.dart';

class TugasDetail extends StatefulWidget {
  int idKelas;
  String pelajaran;
  String idGuru;
  TugasDetail({Key key, this.idKelas, this.pelajaran, this.idGuru})
      : super(key: key);
  @override
  _TugasDetailState createState() => _TugasDetailState();
}

class _TugasDetailState extends State<TugasDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.idKelas == null) {
      Navigator.pop(context);
    } else {}
    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: TugasApi().getDataApi(context, widget.idKelas, widget.idGuru),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Container();
              break;
            case ConnectionState.waiting:
              return Container();
              break;
            case ConnectionState.active:
              return Container();
              break;
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Container(child: Text(snapshot.error.toString()));
              } else {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(widget.pelajaran),
                  ),
                  body: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Tugas Yang Tersedia",
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Container(
                          height: heightDevice * 0.8,
                          child: ListView.builder(
                              itemCount: snapshot.data["result"].length,
                              itemBuilder: (context, i) => buildCardTugas(
                                  context,
                                  snapshot.data["result"][i]["nama_tugas"],
                                  snapshot.data["result"][i]["published"],
                                  snapshot.data["result"][i]["kategori"],
                                  snapshot.data["result"][i]["nama_isi_tugas"],
                                  snapshot.data["result"][i]["nama_kelas"],
                                  snapshot.data["result"][i]["expired"]))),
                    ],
                  ),
                );
              }
              break;
          }
        });
  }

  Widget buildCardTugas(BuildContext context, String judul, String published,
      String kategori, String fileIsi, String kelas, String expired) {
    DateTime dateExpired = DateTime.utc(int.parse(expired.split("-").first),
        int.parse(expired.split("-")[1]), int.parse(expired.split("-").last));
    DateTime dateNow = DateTime.now().toUtc();

    return Card(
      color: (dateExpired.compareTo(dateNow) < 0) ? Colors.red : Colors.white,
      child: InkWell(
        onTap: () {
          if (dateExpired.compareTo(dateNow) < 0) {
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IsiTugas(
                          fileIsi,
                          judul,
                          kelas,
                          actionButton: true,
                        )));
          }
        },
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                judul,
                style: TextStyle(fontSize: 18),
                maxLines: 1,
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text("published : " + published),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text("Expired : " + expired),
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
