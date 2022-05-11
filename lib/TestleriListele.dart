// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:omr/Dbo/Testler.dart';
import 'package:omr/Dbo/TestlerCevap.dart';
import 'package:omr/SonuclarListesi.dart';
import 'package:omr/TestOkuma/GoruntudenOkuma.dart';
import 'package:omr/TestOkuma/ManuelOkuma.dart';
import 'package:omr/UploadPic.dart';
import 'package:omr/KullaniciIslemleri/Login.dart';
import 'package:omr/TestEkle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class TestleriListele extends StatefulWidget {
  const TestleriListele(this.kAdi, this.kId, {Key? key}) : super(key: key);
  final String kAdi;
  final String kId;
  @override
  State<TestleriListele> createState() => _TestleriListeleState();
}

class _TestleriListeleState extends State<TestleriListele> {
  late String girisYapanKullaniciTestId;
  late String girisYapanKullaniciId;
  int testSayisi = 1;
  bool durum = false;
  File? _image;
  final picker = ImagePicker();
  bool kontrol = true;
  int? testId;
  String testBaslik ="";


  Future fromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UploadPic(_image, widget.kId)));
      } else {
        print('No image selected.');
      }
    });
  }

  Future fromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UploadPic(_image, widget.kId)));
      } else {
        print('No image selected.');
      }
    });
  }
  Future testOkuFromCamera(String testId, int soruSayisi) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GoruntudenOkuma(_image, widget.kId, widget.kAdi, testId, soruSayisi)));
      } else {
        print('No image selected.');
      }
    });
  }
  Future testOkuFromGallery(String testId, int soruSayisi) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GoruntudenOkuma(_image, widget.kId, widget.kAdi, testId, soruSayisi)));

      } else {
        print('No image selected.');
      }
    });
  }

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
        this.context, MaterialPageRoute(builder: (context) => Login()));
  }

  List<Testler> parseTestlerCevap(String cevap) {
    var jsonVeri = json.decode(cevap);
    var testlerCevap = TestlerCevap.fromJson(jsonVeri);
    List<Testler> testlerListesi = testlerCevap.testlerListesi;
    durum = testlerCevap.durum;
    testSayisi = testlerCevap.toplam_test_sayisi;
    return testlerListesi;
  }

  Future<List<Testler>> testleriListele(String kullanici_id) async {
    var url =
        Uri.parse("http://ufuk.site/omr/test_islemleri/testleri_listele.php");
    var veri = {
      "kullanici_id": kullanici_id,
    };
    var cevap = await http.post(url, body: veri);
    return parseTestlerCevap(cevap.body);
  }

  Future<String> testSil(String kullanici_id, String test_id) async {
    var url = Uri.parse("http://ufuk.site/omr/test_islemleri/test_sil.php");
    var veri = {
      "kullanici_id": kullanici_id,
      "test_id": test_id,
    };
    var cevap = await http.post(url, body: veri);
    return cevap.body;
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
    var eklenenSoruSayisi = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff5e4d91).withOpacity(0.8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Optik Form Okuma Sistemi",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            IconButton(
                onPressed: () {
                  cikisYap();
                },
                icon: Icon(Icons.logout))
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
                )),
          ),
        ),
      ),
      body: CircularMenu(
        alignment: Alignment.bottomCenter,
        radius: 90,
        toggleButtonMargin: 5.0,
        toggleButtonBoxShadow: [
          BoxShadow(
            color: Color(0xff927898),
            blurRadius: 100,
          ),
        ],
        toggleButtonColor: Color(0xffbcb8ce),
        toggleButtonAnimatedIconData: AnimatedIcons.menu_close,
        backgroundWidget: FutureBuilder<List<Testler>>(
          future: testleriListele(widget.kId),
          builder: (context, snapshot) {
            if (durum == false && snapshot.hasData) {
              return Container(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Text(
                        "Testiniz bulunmuyor.\nAşağıdaki butona basarak test ekleyebilirsiniz.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.robotoMono(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData && durum == true) {
              List<Testler> testListesi = snapshot.data!;
              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        for (int i = 0; i < testSayisi; i++)
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            shadowColor: Colors.black,
                            elevation: 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 4),
                                      child: Text(
                                          "Test ID: ${testListesi[i].test_id}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 8, bottom: 8),
                                      child: Text(
                                          "Soru Sayısı: ${testListesi[i].cevap_anahtari.length ~/ 3}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, bottom: 4),
                                      child: Text(testListesi[i].test_baslik, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: ekranGenisligi/2.3,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    border: Border.all(
                                      color: Colors.grey.shade500,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(50))
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManeulOkuma(testListesi[i].test_id, testListesi[i].cevap_anahtari.length ~/ 3, widget.kAdi, widget.kId)));
                                          },
                                          icon:
                                              Icon(LineariconsFree.spell_check),
                                          iconSize: 30),
                                      IconButton(
                                        onPressed: () {
                                          testOkuFromCamera(testListesi[i].test_id, testListesi[i].cevap_anahtari.length ~/ 3);
                                        },
                                        icon: Icon(Icons.camera_alt_outlined),
                                        iconSize: 30,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          testOkuFromGallery(testListesi[i].test_id, testListesi[i].cevap_anahtari.length ~/ 3);
                                        },
                                        icon: Icon(Icons.upload),
                                        iconSize: 30,
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton(
                                  child: Icon(Icons.more_vert),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(value: 2, child: Text("Sonuçları Gör")),
                                    PopupMenuItem(value: 1, child: Text("Sil")),
                                  ],
                                  onSelected: (menuItemValue) async {
                                    if (menuItemValue == 1) {
                                      testSil(widget.kId,
                                              testListesi[i].test_id.toString())
                                          .then((value) => value
                                                  .contains("true")
                                              ? ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Kayıt Silindi")))
                                              : ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Kayıt Silinemedi"))));
                                      await Future.delayed(
                                          Duration(seconds: 3));
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TestleriListele(widget.kAdi,
                                                      widget.kId)));
                                    }else if(menuItemValue == 2){
                                      testId = int.parse(testListesi[i].test_id);
                                      testBaslik = testListesi[i].test_baslik;
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SonuclarListesi(testId!, testBaslik)));
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        items: [
          CircularMenuItem(
              // icon: FontAwesome5.spell_check,
              icon: LineariconsFree.spell_check,
              color: Color(0xff927898),
              margin: 30.0,
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        contentPadding: EdgeInsets.only(top: 0.0),
                        content: (Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              decoration: BoxDecoration(
                                color: Color(0xff5e4d91),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(32.0),
                                    topRight: Radius.circular(32.0)),
                              ),
                              child: Text(
                                "Soru Ekle",
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, left: 12, right: 12),
                              child: TextField(
                                controller: eklenenSoruSayisi,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                //autofocus: true,
                                enabled: true,
                                showCursor: false,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  hintText: "Soru Sayısı",
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    eklenenSoruSayisi.text == "" || eklenenSoruSayisi.text.contains(RegExp(r'[A-Z]'))
                                        || eklenenSoruSayisi.text.contains(RegExp(r'[a-z]')) ?
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lütfen geçerli bir değer giriniz."))) :
                                    int.parse(eklenenSoruSayisi.text) > 50 || int.parse(eklenenSoruSayisi.text) <1 ?
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("1 ile 50 arası soru eklenebilir."))) :
                                    int.parse(eklenenSoruSayisi.text) >= 1 || int.parse(eklenenSoruSayisi.text) <=50 ?
                                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                        TestEkle(eklenenSoruSayisi.text, widget.kAdi, widget.kId))): Text("Hata");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Ekle",
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xff5e4d91),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      )),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TestleriListele(
                                              widget.kAdi, widget.kId)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("İptal",
                                      style: TextStyle(fontSize: 16)),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xff5e4d91),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    )),
                              ),
                            ],
                          )
                        ],
                      );
                    });
              }),
          CircularMenuItem(
              icon: Icons.camera_alt_outlined,
              //margin: 30.0,
              color: Color(0xff927898),
              onTap: () {
                fromCamera();
              }),
          CircularMenuItem(
              icon: Icons.upload,
              margin: 30.0,
              color: Color(0xff927898),
              onTap: () {
                fromGallery();
              }),
        ],
      ),
    );
  }
}
