// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omr/KullaniciIslemleri/Login.dart';
import 'package:omr/Testler.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  String? kAdi;
  String? kId;
  Future<bool> oturumKontrol() async {
    var sp = await SharedPreferences.getInstance();
    String? spDurum = sp.getString("girisDurum");
    if(spDurum == "1"){
      kAdi = sp.getString("kullanici_adi");
      kId = sp.getString("kullanici_id");
      return true;
    }
    else{
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Optical Mark Recognition',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: oturumKontrol(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            bool gecisIzni = snapshot.data!;
            return gecisIzni ? Testler(kAdi!, kId!) : Login();
          }else{
            return Container(
            );
          }
        },
      )
    );
  }
}
