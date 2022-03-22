// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omr/KullaniciIslemleri/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Testler extends StatefulWidget {
  const Testler({Key? key}) : super(key: key);

  @override
  State<Testler> createState() => _TestlerState();
}

class _TestlerState extends State<Testler> {
  var kAdi;
  var kId;
  Future<String> kullanici_adi() async {
    var sp = await SharedPreferences.getInstance();
    String? kAdi = sp.getString("kullanici_adi");
    return kAdi.toString();
  }

  Future<String> kullanici_id() async {
    var sp = await SharedPreferences.getInstance();
    String? kId = sp.getString("kullanici_id");
    return kId.toString();
  }

  Future<void> cikisYap() async {
    var sp = await SharedPreferences.getInstance();
    sp.remove("girisDurum");
    sp.remove("kullanici_adi");
    sp.remove("kullanici_id");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }
  @override
  void initState() {
    kullanici_adi().then((value) => kAdi=value);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff5e4d91).withOpacity(0.8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Optik Form Okuma Sistemi", style: TextStyle(color: Colors.white, fontSize: 16),),
            Text("  --  "),
            Text("$kAdi", style: TextStyle(color: Colors.white, fontSize: 16),),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("resimler/optikForm.jpg"),
              )
            ),
            //child: Image.asset("resimler/optikForm.jpg"),
          ),
        ),
      ),
      body: Container(
        width: ekranGenisligi,
        height: ekranYuksekligi,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              stops: const [
                0.1,
                0.2,
                0.8,
                0.9,
              ],
              colors: [
                Color(0xff5e4d91).withOpacity(0.7),
                Color(0xff5e4d91).withOpacity(0.6),
                Color(0xff5e4d91).withOpacity(0.2),
                Color(0xff5e4d91).withOpacity(0.1),
              ],
            )),
        child: Column(
          children: [
            Spacer(),
            SizedBox(
              width: 140,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: () {
                  cikisYap();
                },
                icon: Icon(Icons.arrow_forward),
                label: Text(
                  "Çıkış Yap",
                  style: GoogleFonts.robotoMono(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Color(0xff736e7e),
                    onPrimary: Colors.white,
                    shadowColor: Colors.grey,
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10)),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
