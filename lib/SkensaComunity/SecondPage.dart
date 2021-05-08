import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:skensa/SkensaComunity/ApiLogin.dart';
import 'package:skensa/SkensaComunity/Home.dart';
import 'package:skensa/SkensaComunity/Registrasi.dart';

class SeconPages extends StatefulWidget {
  @override
  _SeconPagesState createState() => _SeconPagesState();
}

class _SeconPagesState extends State<SeconPages> {
  @override
  Widget build(BuildContext context) {
    bool _loading = false;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          title: Row(children: [Text("Login")]),
        ),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Opacity(
                opacity: 0.6,
                child: Container(
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Flexible(
                      flex: 1,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                            child: Text(
                          "SKENSA Community",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.8)),
                        )),
                      )),
                  Flexible(
                      flex: 1,
                      child: Container(
                        //Container flex

                        padding: EdgeInsets.all(10),
                        child: ListView(children: <Widget>[
                          Container(
                              //Container Login
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white.withOpacity(0.7)),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  _usernameField(),
                                  _passwordField(),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        CupertinoButton(
                                          color: Colors.lightBlue,
                                          onPressed: () {
                                            ApiData()
                                                .getData(username.text,
                                                    password.text)
                                                .then((value) {
                                              if (value) {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Beranda()),
                                                    (route) => false);
                                              } else {
                                                showDialog(
                                                    context: (context),
                                                    builder: (context) =>
                                                        AlertDialog(
                                                            title: Text(
                                                                "Akun Tidak Ditemukan"),
                                                            content:
                                                                CupertinoButton(
                                                              child: Text("OK"),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              color: Colors
                                                                  .lightBlue,
                                                            )));
                                              }
                                            });
                                          },
                                          child: Text("Login"),
                                        ),
                                        CupertinoButton(
                                            child: Text("Login Sebagai Guru"),
                                            onPressed: () {
                                              ApiData()
                                                  .getDataGuru(
                                                      context,
                                                      username.text,
                                                      password.text)
                                                  .then((value) {
                                                if (value) {
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Beranda()),
                                                      (route) => false);
                                                } else {
                                                  showDialog(
                                                      context: (context),
                                                      builder: (context) =>
                                                          AlertDialog(
                                                            title: Text(
                                                                "Akun Tidak Ditemukan"),
                                                            content:
                                                                CupertinoButton(
                                                              child: Text("Ok"),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ));
                                                }
                                              });
                                            })
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Registrasi()));
                                            },
                                            child:
                                                Text("Registrasi Akun Baru")),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        ]),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

TextEditingController username = new TextEditingController();
Container _usernameField() {
  return Container(
    child: TextField(
      controller: username,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Username",
        prefixIcon: Icon(Icons.person),
        labelStyle: TextStyle(
          fontSize: 20,
        ),
      ),
    ),
  );
}

List<String> nama = ["diriku", "pernah berjuang"];

TextEditingController password = new TextEditingController();
Container _passwordField() {
  return Container(
    margin: EdgeInsets.only(top: 10),
    child: TextFormField(
      controller: password,
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Password",
        prefixIcon: Icon(Icons.vpn_key),
        counter: GestureDetector(onTap: () {}, child: Text("Lupa Password")),
        labelStyle: TextStyle(
          fontSize: 20,
        ),
      ),
    ),
  );
}
