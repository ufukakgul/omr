// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omr/KullaniciIslemleri/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Testler extends StatefulWidget {
  const Testler(this.kAdi, this.kId, {Key? key}) : super(key: key);

  final String kAdi;
  final String kId;
  @override
  State<Testler> createState() => _TestlerState();
}

class _TestlerState extends State<Testler> {
  late String girisYapanKullaniciTestId;
  late String girisYapanKullaniciId;
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

  Future<String> kayitListele(String kullanici_id) async {
    var url = Uri.parse("http://ufuk.site/omr/test_islemleri/testleri_listele.php");
    var veri = {
      "kullanici_id": kullanici_id,
    };
    var cevap = await http.post(url, body: veri);
    var jsonVeri = jsonDecode(cevap.body);
    if(cevap.body.contains("false")) {
      return "Kayıt Yok";
    } else if (cevap.body.contains("true")) {
      girisYapanKullaniciId = (jsonVeri["kayitlar"][0]["kullanici_id"]).toString();
      girisYapanKullaniciTestId = jsonVeri["kayitlar"][0]["test_id"];
      return girisYapanKullaniciId;
    }else {
      return "Hatalı Giriş";
    }
  }

  @override
  void initState() {
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
            Text(widget.kAdi, style: TextStyle(color: Colors.white, fontSize: 16),),
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
            SizedBox(
              width: 140,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: () {
                  kayitListele(widget.kId).then((value) => print(value));
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
