import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:skensa/SkensaComunity/ApiLogin.dart';

import 'package:skensa/SkensaComunity/Home.dart';
import 'package:skensa/SkensaComunity/SecondPage.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Directory pathHive = await getExternalStorageDirectory();
  // Hive.init(pathHive.path);
  // if (Hive.isAdapterRegistered(1)) {
  // } else {
  //   Hive.registerAdapter(MyHiveAdapter());
  // }
  // Hive.openBox<MyHive>("myHive");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String id;
  @override
  void initState() {
    ApiData().getStringProfile("id_guru").then((value) {
      id = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "SKENSA",
        home: FutureBuilder(
            future: ApiData().getIntProfile("idPengguna"),
            builder: (context, AsyncSnapshot<int> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Container(
                    child: Center(child: Image.asset("assets/skensa.png")),
                  );
                  break;
                case ConnectionState.waiting:
                  return Container(
                    child: Center(child: Image.asset("assets/skensa.png")),
                  );

                  break;
                case ConnectionState.active:
                  return Container(
                    child: Center(child: Image.asset("assets/skensa.png")),
                  );

                  break;
                case ConnectionState.done:
                  // TODO: Handle this case.
                  debugPrint(id);
                  debugPrint(snapshot.data.toString());
                  if (snapshot.hasData) {
                    return Beranda();
                  } else {
                    return SeconPages();
                  }
                  break;
              }
            }));
  }
}
