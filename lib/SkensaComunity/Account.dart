import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skensa/SkensaComunity/SecondPage.dart';



class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

  //Shared Preferences:idPengguna,id_kelas,id_guru
  void logOut() async {
    SharedPreferences dataRemove = await SharedPreferences.getInstance();
    await dataRemove.remove("idPengguna");
    await dataRemove.remove("Profile");
    await dataRemove.remove("isGuru");
    debugPrint(dataRemove.getInt("idPengguna").toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
      children: <Widget>[
        Center(
          child: CupertinoButton(
            color: Colors.red,
              child: Text("Log Out"),
              onPressed: () {
                showDialog(
                    context: (context),
                    builder: (context) => AlertDialog(
                          title: Text("Konfirmasi Logout"),
                          actions: <Widget>[
                            Row(
                              
                              children: <Widget>[
                                CupertinoButton(
                                color: Colors.red,
                                child: Text("OK"),
                                onPressed: () {
                                  logOut();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SeconPages()),
                                      (route) => false);
                                }),
                            CupertinoButton(
                                color: Colors.lightBlue,
                                child: Text("Batal"),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                              ],
                            )
                          ],
                        ));
              }),
        )
      ],
    ));
  }
}
