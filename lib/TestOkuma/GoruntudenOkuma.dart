// ignore_for_file: unnecessary_new, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:omr/Dbo/Testler.dart';
import 'package:omr/Dbo/TestlerCevap.dart';
import 'package:omr/TestleriListele.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class GoruntudenOkuma extends StatefulWidget {
  const GoruntudenOkuma(
      this._image, this.kId, this.kAdi, this.testId, this.soruSayisi,
      {Key? key})
      : super(key: key);
  final File? _image;
  final String kId;
  final String kAdi;
  final String testId;
  final int soruSayisi;

  @override
  State<GoruntudenOkuma> createState() => _GoruntudenOkumaState();
}

class _GoruntudenOkumaState extends State<GoruntudenOkuma> {
  var body = <String, dynamic>{};
  int dogru = 0;
  int yanlis = 0;
  int bos = 0;
  bool tamamla = false;
  var alinanPuan;
  int testSayisi = 1;
  bool durum = false;
  var siralanmisCevapAnahtari = <int, String>{};

  List<Testler> parseTestlerCevap(String cevap) {
    var jsonVeri = json.decode(cevap);
    var testlerCevap = TestlerCevap.fromJson(jsonVeri);
    List<Testler> testlerListesi = testlerCevap.testlerListesi;
    durum = testlerCevap.durum;
    testSayisi = testlerCevap.toplam_test_sayisi;
    return testlerListesi;
  }

  Future<List<Testler>> testOku(String testId) async {
    var url = Uri.parse("https://ufuk.site/omr/test_islemleri/test_oku.php");
    var veri = {
      "test_id": testId,
    };
    var cevap = await http.post(url, body: veri);
    print("Cevap: ${cevap.body}");
    return parseTestlerCevap(cevap.body);
  }

  Upload(File imageFile) async {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("http://185.106.208.106:5000/getAnswers");
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      value.contains("ERR")
          ? body = {"1": "Hatalı Resim"}
          : body = json.decode(value);
      print("value");
      print(value);
      print("value");
    });

    setState(() {});
  }

  @override
  void initState() {
    Upload(widget._image!);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    List cevapAnahtariListe = [];
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TestleriListele(widget.kAdi, widget.kId)));
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                ),
                hoverColor: Colors.white,
              )
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
        body: SizedBox(
          height: ekranYuksekligi,
          width: ekranGenisligi,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  height: ekranYuksekligi / 12,
                  width: ekranGenisligi,
                  child: tamamla
                      ? Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Doğru: "),
                                  Text("Yanlış: "),
                                  Text("Boş: "),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("$dogru"),
                                  Text("$yanlis"),
                                  Text("$bos"),
                                ],
                              ),
                              Spacer(),
                              Text(
                                (100 / widget.soruSayisi * dogru)
                                    .toStringAsFixed(2),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ))
                      : Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Sonuçlar",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(
                              "(Sonuçları Görmek İçin Lütfen Tamamla Butonuna Basın)",
                              style: TextStyle(
                                  color: Colors.transparent.withOpacity(0.5),
                                  fontSize: 12),
                            )
                          ],
                        )),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                ),
              ),
              SizedBox(
                height: ekranYuksekligi / 2.5,
                child: Column(
                  children: [
                    SizedBox(
                      height: ekranYuksekligi / 3,
                      child: widget._image != null
                          ? Image.file(
                              widget._image!,
                              fit: BoxFit.contain,
                            )
                          : Text("no image"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        body.values.join(" | "),
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              body.values.length == widget.soruSayisi
                  ? SizedBox(
                      height: widget.soruSayisi * 11.5,
                      child: FutureBuilder<List<Testler>>(
                          future: testOku(widget.testId),
                          builder: (context, snapshot) {
                            if (durum == false && snapshot.hasData) {
                              return Text("${snapshot.data}");
                            } else if (snapshot.hasData && durum == true) {
                              if (body.values.toString().contains("Hata") ||
                                  body.values.toString() == "(EMPTY)") {
                                return Text("Hatalı Resim");
                              } else if (body.isNotEmpty ||
                                  body.values.length == widget.soruSayisi) {
                                List<Testler> testListesi = snapshot.data!;
                                cevapAnahtariListe.clear();
                                for (int i = 1;
                                    i <= testListesi[0].cevap_anahtari.length;
                                    i += 3) {
                                  cevapAnahtariListe
                                      .add(testListesi[0].cevap_anahtari[i]);
                                }
                                bos = 0;
                                dogru = 0;
                                yanlis = 0;
                                for (int i = 0; i < widget.soruSayisi; i++) {
                                  if (body.values.toList()[i] == null) {
                                    bos++;
                                  } else if (body.values.toList()[i] ==
                                      cevapAnahtariListe[i]) {
                                    dogru++;
                                  } else if (body.values.toList()[i] !=
                                      cevapAnahtariListe[i]) {
                                    yanlis++;
                                  }
                                }
                                return GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 5,
                                            childAspectRatio: 6 / 4),
                                    itemCount: widget.soruSayisi,
                                    itemBuilder: (context, indeks) {
                                      return Card(
                                          color: cevapAnahtariListe[indeks] ==
                                                  body.values.toList()[indeks]
                                              ? (Colors.green)
                                              : body.values.toList()[indeks] ==
                                                      null
                                                  ? Colors.white
                                                  : Colors.red,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("${indeks + 1}"),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      "${cevapAnahtariListe[indeks]}"),
                                                  body.values.toList()[
                                                              indeks] ==
                                                          null
                                                      ? Text(" ")
                                                      : Text(
                                                          " - ${body.values.toList()[indeks]}"),
                                                ],
                                              ),
                                            ],
                                          ));
                                    });
                              } else {
                                return CircularProgressIndicator();
                              }
                            } else {
                              return Center(child: Text(""));
                            }
                          }),
                    )
                  : Center(
                      child: Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 10),
                          child: Column(
                            children: [
                              Icon(Icons.warning_amber_outlined,
                                  size: 30, color: Color(0xff5e4d91)),
                              Text(
                                "Cevap anahtarındaki soru sayısı ile seçtiğiniz optik formdaki cevap sayısı eşit değil. "
                                "\nLütfen kontrol ederek tekrar deneyin.",
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.black,
                                  ),
                                  label: Text(
                                    "Çıkış",
                                    style: GoogleFonts.robotoMono(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      //minimumSize: Size(150,50),
                                      side: BorderSide(
                                          color: Colors.grey, width: 2),
                                      fixedSize: Size(ekranGenisligi / 3.2, 50),
                                      primary: Colors.grey.withOpacity(0.1),
                                      onPrimary: Colors.white,
                                      shadowColor: Colors.grey,
                                      elevation: 20,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      )),
                                ),
                              )
                            ],
                          ))),
              Spacer(),
              body.values.length == widget.soruSayisi
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: SizedBox(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      "İptal",
                                      style: GoogleFonts.robotoMono(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            color: Colors.grey, width: 2),
                                        fixedSize: Size(ekranGenisligi / 3.2, 50),
                                        primary: Color(0xff5e4d91).withOpacity(0.8),
                                        onPrimary: Colors.white,
                                        shadowColor: Colors.grey,
                                        elevation: 20,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        )),
                                  ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    tamamla = true;
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.remove_red_eye,
                                      color: Colors.white),
                                  label: Text(
                                    "Göster",
                                    style: GoogleFonts.robotoMono(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      side: BorderSide(
                                          color: Colors.grey, width: 2),
                                      fixedSize: Size(ekranGenisligi / 3.2, 50),
                                      primary: Color(0xff5e4d91).withOpacity(0.8),
                                      onPrimary: Colors.white,
                                      shadowColor: Colors.grey,
                                      elevation: 20,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      )),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                  },
                                  icon: Icon(
                                      Icons.keyboard_double_arrow_up_sharp,
                                      color: Colors.white),
                                  label: Text(
                                    "Gönder",
                                    style: GoogleFonts.robotoMono(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      side: BorderSide(
                                          color: Colors.grey, width: 2),
                                      fixedSize: Size(ekranGenisligi / 3.2, 50),
                                      primary: Color(0xff5e4d91).withOpacity(0.8),
                                      onPrimary: Colors.white,
                                      shadowColor: Colors.grey,
                                      elevation: 20,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : Text(""),
            ],
          ),
        ));
  }
}
