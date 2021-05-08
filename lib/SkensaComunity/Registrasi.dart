import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skensa/SkensaComunity/api/RegistrasiApi.dart';

class Registrasi extends StatefulWidget {
  @override
  _RegistrasiState createState() => _RegistrasiState();
}

class _RegistrasiState extends State<Registrasi> {
  List jurusan = [];
  List kelas = [];
  @override
  void initState() {
    // TODO: implement initState
    RegistrasiApi().getReferance().then((value) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabsContainer = [
      buildContainerSiswa(),
      Container(
        color: Colors.blue,
      )
    ];
    debugPrint("jadi");
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Registrasi"),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Siswa",
              ),
              Tab(
                text: "Guru",
              )
            ],
          ),
        ),
        body: TabBarView(children: tabsContainer),
      ),
    );
  }

  Container buildContainerSiswa() {
    TextEditingController namaLengkap = TextEditingController();
    TextEditingController nisn = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    String idKelas = '';
    bool jurusanBool = false;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Card(
              child: TextFormField(
                controller: namaLengkap,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Nama Lengkap",
                  icon: Icon(Icons.person),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Card(
                child: TextFormField(
                  controller: nisn,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "NISN",
                    icon: Icon(Icons.confirmation_number),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Card(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Jurusan :   "),
                    ),
                    Flexible(
                      child: DropdownButtonFormField(
                          hint: Text("Pilih Jurusan"),
                          items: [
                            DropdownMenuItem(
                              child: Text("Rekayasa Perangkat Lunak"),
                              value: "1",
                            ),
                            DropdownMenuItem(
                              child: Text("Multimedia"),
                              value: "MM",
                            )
                          ],
                          onChanged: (value) {
                            idKelas = value;
                          }),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Card(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Kelas :   "),
                    ),
                    Flexible(
                      child: DropdownButtonFormField(
                          disabledHint: Text("Pilih Jurusan Terlebih Dahulu"),
                          hint: Text("Pilih Kelas"),
                          items: [
                            DropdownMenuItem(
                              child: Text("X"),
                              value: "X",
                            ),
                            DropdownMenuItem(
                              child: Text("XI"),
                              value: "XI",
                            ),
                            DropdownMenuItem(
                              child: Text("XII"),
                              value: "XII",
                            )
                          ],
                          onChanged: (value) {}),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Card(
                child: TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    icon: Icon(Icons.alternate_email),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Card(
                child: TextFormField(
                  controller: password,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    icon: Icon(Icons.vpn_key),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CupertinoButton(
                child: Text("Registrasi"),
                onPressed: () {
                  RegistrasiApi().registrasiSiswa(namaLengkap.text, email.text,
                      password.text, idKelas, nisn.text, context);
                },
                color: Colors.lightBlue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
