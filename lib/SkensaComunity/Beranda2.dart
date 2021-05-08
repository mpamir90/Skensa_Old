import 'package:flutter/material.dart';

class Beranda2 extends StatefulWidget {
  @override
  _Beranda2State createState() => _Beranda2State();
}

class _Beranda2State extends State<Beranda2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               Center(child: Text("Coming Soon")),
            ],
          )
        ],
      ),
    );
  }
}