// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final kAdiController = TextEditingController();
  final kMailController = TextEditingController();
  final kSifreController = TextEditingController();
  bool isLoading = false;
  bool sifreTiklama = true;

  Future<String> kisiEkle(String kullanici_adi, String kullanici_mail, String kullanici_sifre) async {
    var url = Uri.parse("http://ufuk.site/omr/kullanici_islemleri/kullanici_ekle.php");
    var veri = {
      "kullanici_adi": kullanici_adi,
      "kullanici_mail": kullanici_mail,
      "kullanici_sifre": kullanici_sifre,
    };
    var cevap = await http.post(url, body: veri);
    print("Cevap: ${cevap.body}");
    if(cevap.body.contains("mail")) {
      return cevap.body.toString();
    } else if (cevap.body.contains("kullanici")) {
      return cevap.body.toString();
    } else return cevap.body.toString();
  }

  Future<void> kullaniciVar() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 1),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Fontelico.emo_unhappy, size: 15),
          Text("Bu kullanıcı adı ile kayıtlı kullanıcı var",
              style: TextStyle(color: Colors.black)),
        ],
      ),
      width: 300,
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

  Future<void> mailVar() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 1),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Fontelico.emo_unhappy, size: 15),
          Text("Bu mail ile kayıtlı kullanıcı var",
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

  Future<void> kullaniciOlusturuldu() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 1),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Fontelico.emo_wink, size: 15),
          Text("Kayıt oluşturuldu.", style: TextStyle(color: Colors.black)),
        ],
      ),
      width: 180,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.white54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    ));
    kAdiController.text = "";
    kMailController.text = "";
    kSifreController.text = "";
    setState(() {
      isLoading = false;
    });
    await Future.delayed(Duration(milliseconds: 1200));
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<void> girilenBilgileriKontrolEt() async {
    setState(() {
      isLoading = true;
    });
    if (kAdiController.text.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Fontelico.emo_unhappy,
              size: 15,
            ),
            Text(
              "Geçerli bir kullanıcı adı girin.",
              style: TextStyle(color: Colors.black),
            ),
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
    } else if ((!((kMailController.text).contains("@"))) ||
        (!((kMailController.text).contains(".")))) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Fontelico.emo_unhappy, size: 15),
            Text("Geçerli bir mail adresi girin.",
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
    } else if ((kSifreController.text).isEmpty ||
        (kSifreController.text.length) <= 3) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Fontelico.emo_unhappy, size: 15),
            Text("Geçerli bir şifre girin.",
                style: TextStyle(color: Colors.black)),
          ],
        ),
        width: 180,
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
    } else {
      kisiEkle(kAdiController.text, kMailController.text, kSifreController.text)
          .then(
            (value) => value.contains("true") ? kullaniciOlusturuldu() : (value.contains("kullanici") ? kullaniciVar() : mailVar()),
      );
    }
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
                          padding: EdgeInsets.only(bottom: ekranYuksekligi/20, top: ekranYuksekligi/20),
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
                            MfgLabs.users,
                            //Elusive.group,
                            size: 100,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, bottom: 8),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Kayıt Ol", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 20,
                            shadowColor: Colors.indigo,
                            child: TextField(
                              controller: kAdiController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: "Kullanıcı Adı",
                                  prefixIcon: Icon(Icons.person),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0)),
                                    borderSide: BorderSide(
                                        color: Color(0xff736e7e),
                                        width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0)),
                                    borderSide: BorderSide(
                                        color: Color(0xff736e7e),
                                        width: 2),
                                  )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: Colors.transparent,
                            elevation: 20,
                            shadowColor: Colors.indigo,
                            child: TextField(
                              controller: kMailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: "E-Posta",
                                  prefixIcon: Icon(Icons.person),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0)),
                                    borderSide: BorderSide(
                                        color: Color(0xff736e7e),
                                        width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0)),
                                    borderSide: BorderSide(
                                        color: Color(0xff736e7e),
                                        width: 2),
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
                              controller: kSifreController,
                              obscureText: sifreTiklama,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  hintText: "Şifre",
                                  prefixIcon: Icon(Icons.vpn_key),
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
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0)),
                                    borderSide: BorderSide(
                                        color: Color(0xff736e7e),
                                        width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0)),
                                    borderSide: BorderSide(
                                        color: Color(0xff736e7e),
                                        width: 2),
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
                              //kisiEkle(kAdiController.text, kMailController.text, kSifreController.text);
                            },
                            icon: Icon(Icons.save),
                            label: Text(
                              "KAYDET",
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
