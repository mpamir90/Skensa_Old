import 'package:flutter/material.dart';
import 'package:skensa/SkensaComunity/Account.dart';

import 'dart:async';

import 'package:skensa/SkensaComunity/ApiLogin.dart';
import 'package:skensa/SkensaComunity/Beranda2.dart';
import 'package:skensa/SkensaComunity/Kelas.dart';
import 'package:skensa/SkensaComunity/Tugas.dart';
import 'package:skensa/SkensaComunity/TugasGuru.dart';

class Beranda extends StatefulWidget {

  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  List beranda = [Container(child: Center(child: Text("Coming Soon"),),)];

  int indexNavigation = 0;
  
  @override
  void initState() {
    ApiData().getBoolProfile("isGuru").then((value) {
      if (value != null ) {
        beranda = [
          Beranda2(),
          Kelas(),
          TugasGuru(),
          Account(),
        ];
        setState(() {});
      } else {
        beranda = [
          Beranda2(),
          Kelas(),
          Tugas(),
          Account(),
        ];
      }
    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
        bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).size.height * 0.07,
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text("Beranda"),
                  backgroundColor: Colors.lightBlue),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_box_outline_blank),
                  title: Text("Kelas"),
                  backgroundColor: Colors.lightBlue),
              BottomNavigationBarItem(
                  icon: Icon(Icons.assignment),
                  title: Text("Tugas"),
                  backgroundColor: Colors.lightBlue),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  title: Text("Account"),
                  backgroundColor: Colors.lightBlue),
            ],
            iconSize: MediaQuery.of(context).size.height * 0.02,
            currentIndex: indexNavigation,
            onTap: (i) {
              indexNavigation = i;
              debugPrint(indexNavigation.toString());
              setState(() {});
            },
          ),
        ),
        body: beranda[indexNavigation]
       
        );
  }
}
