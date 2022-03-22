// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omr/KullaniciIslemleri/Register.dart';
import 'package:omr/KullaniciIslemleri/ResetPassword.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:http/http.dart' as http;
import 'package:omr/Testler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool sifreTiklama = true;
  var kAdiController = TextEditingController();
  var kSifreController = TextEditingController();
  late String girisYapanKullaniciAdi;
  late String girisYapanKullaniciId;
  bool isLoading = false;

  Future<String> girisYap(String kAdi, String kSifre) async {
    var url = Uri.parse("http://ufuk.site/omr/kullanici_islemleri/kullanici_giris.php");
    var veri = {
      "kAdi": kAdi,
      "kSifre": kSifre,
    };
    var cevap = await http.post(url, body: veri);
    var jsonVeri = jsonDecode(cevap.body);
    if(cevap.body.contains("false")) {
      return "false";
    } else if (cevap.body.contains("true")) {
      girisYapanKullaniciId = (jsonVeri["mesaj"][0]["id"]).toString();
      girisYapanKullaniciAdi = jsonVeri["mesaj"][0]["kAdi"];
      return girisYapanKullaniciAdi;
    }else {
      return "false";
    }
  }

  Future<void> hataliGiris() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 1),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Fontelico.emo_unhappy, size: 15),
          Text("Kullanıcı Adı yada Şifre Hatalı",
              style: TextStyle(color: Colors.black)),
        ],
      ),
      width: 240,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.white54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    ));
    setState(() {
      isLoading = false;
    });
  }

  Future<void> basarililiGiris() async {
    var sp = await SharedPreferences.getInstance();
    sp.setString("girisDurum", "1");
    sp.setString("kullanici_adi", girisYapanKullaniciAdi);
    sp.setString("kullanici_id", girisYapanKullaniciId);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Testler()));
    setState(() {
      isLoading = false;
    });
  }

  Future<void> girilenBilgileriKontrolEt() async {
    setState(() {
      isLoading = true;
    });
      girisYap(kAdiController.text, kSifreController.text)
          .then((value) => value == "false" ? hataliGiris() : basarililiGiris());
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
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
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100),
                          topRight: Radius.circular(100))),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(bottom: ekranYuksekligi/20, top: ekranYuksekligi/20),
                          child: Text(
                            "Optik Form\nOkuma Sistemi",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.robotoMono(
                                color: Color(0xff736e7e),
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: ekranYuksekligi/40, bottom: ekranYuksekligi/50),
                          child: Icon(
                            MfgLabs.user,
                            size: 100,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Giriş Yap", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 20,
                            shadowColor: Colors.indigo,
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: kAdiController,
                              decoration: InputDecoration(
                                  hintText: "Kullanıcı Adı",
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                  ),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0)),
                                    borderSide: BorderSide(
                                        color: Color(0xff736e7e), width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0)),
                                    borderSide: BorderSide(
                                        color: Color(0xff736e7e), width: 2),
                                  )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 16),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 20,
                            shadowColor: Colors.indigo,
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: sifreTiklama,
                              controller: kSifreController,
                              decoration: InputDecoration(
                                  hintText: "Şifre",
                                  prefixIcon:
                                      Icon(Icons.vpn_key, color: Colors.grey),
                                  suffixIcon: IconButton(
                                    icon: Icon(sifreTiklama
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        sifreTiklama = !sifreTiklama;
                                      });
                                    },
                                  ),
                                  prefixIconColor: Colors.amber,
                                  suffixIconColor: Colors.red,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0)),
                                    borderSide: BorderSide(
                                        color: Color(0xff736e7e), width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0)),
                                    borderSide: BorderSide(
                                        color: Color(0xff736e7e), width: 2),
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          height: 45,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              girilenBilgileriKontrolEt();
                            },
                            icon: Icon(Icons.arrow_forward),
                            label: Text(
                              "Giriş Yap",
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
                        SizedBox(
                          height: ekranYuksekligi / 14,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Hesabınız Yok Mu?   ",
                              style: TextStyle(color: Color(0xff736e7e)),
                            ),
                            TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()));
                                },
                                child: Text(
                                  "Üye Ol",
                                  style: TextStyle(
                                      color: Color(0xff736e7e),
                                      decoration: TextDecoration.underline),
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.only(top: 5),
                                tapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ResetPassword()));
                              },
                              child: Text(
                                "Şifrenizi mi unuttunuz?",
                                style: TextStyle(
                                    color: Color(0xff736e7e),
                                    decoration: TextDecoration.underline),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
