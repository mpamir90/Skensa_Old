import 'package:flutter/material.dart';
import 'package:skensa/SkensaComunity/DetailTugas.dart';
import 'package:skensa/SkensaComunity/api/TugasApi.dart';


class Tugas extends StatefulWidget {
  @override
  _TugasState createState() => _TugasState();
}

class _TugasState extends State<Tugas> {


  @override
  Widget build(BuildContext context) {
    TugasApi tugas = TugasApi();
    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
            width: widthDevice,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: Text(
                  "Pilih Mata Pelajaran",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: heightDevice * 0.8,
                  child: FutureBuilder(future: TugasApi().getPelajaranApi(),builder:
                      (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Container(
                          child: Text("Loading"),
                        );
                        break;
                      case ConnectionState.waiting:
                        return Container(
                          child: Text("Loading"),
                        );
                        break;
                      case ConnectionState.active:
                        return Container(
                          child: Text("Loading"),
                        );
                        break;
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Container(
                            child: Text(snapshot.error.toString()),
                          );
                        } else {
                          ;
                          return ListView.builder(itemCount: snapshot.data["result"].length,
                              itemBuilder: (context, i) => buildCardGuru(
                                  widthDevice,
                                  snapshot.data["result"][i]["nama_pelajaran"],
                                  snapshot.data["result"][i]["nama"],
                                  int.parse(snapshot.data["result"][i]["id_kelas"]),
                                  snapshot.data["result"][i]["id_guru"]

                                  ));
                        }
                        break;
                    }
                  }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildCardGuru(
      double widthDevice, String pelajaran, String nama_guru, int idKelas,String idGuru) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TugasDetail(
                        idKelas: idKelas,
                        pelajaran: pelajaran,
                        idGuru: idGuru,
                      )));
        },
        child: ListTile(
          dense: false,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              "assets/guru.jpeg",
              width: widthDevice * 0.2,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                pelajaran,
                style: TextStyle(fontSize: 20),
              ),
              Container(
                height: 1,
                color: Colors.grey[350],
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                nama_guru,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
