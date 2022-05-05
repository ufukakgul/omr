// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:omr/Dbo/Testler.dart';
import 'package:omr/Dbo/TestlerCevap.dart';
import 'package:omr/TestleriListele.dart';
import 'dart:convert';

class ManeulOkuma extends StatefulWidget {
  const ManeulOkuma(this.testId, this.soruSayisi, this.kAdi, this.kId,
      {Key? key})
      : super(key: key);
  final String testId;
  final int soruSayisi;
  final String kAdi;
  final String kId;
  @override
  State<ManeulOkuma> createState() => _ManeulOkumaState();
}

class _ManeulOkumaState extends State<ManeulOkuma> {
  var secenek = ["A", "B", "C", "D", "E"];
  var secilen = <int, int>{};
  var cevapAnahtari = <int, String>{};
  int eklenenSoruSayac = 0;
  var siralanmisCevapAnahtari = <int, String>{};
  int testSayisi = 1;
  bool durum = false;
  String finalStr = "";
  String finalStr2 = "";
  int dogru = 0;
  int yanlis = 0;
  int bos = 0;
  bool tamamla = false;
  var alinanPuan;
  var ogrenci_ismi = TextEditingController();
  var ogrenci_numarasi = TextEditingController();

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

  Future<String> testEkle(String test_id, String ogrenci_adi, String ogrenci_numarasi, String alinan_puan, String ogrenci_cevaplar) async {
    var url = Uri.parse("https://ufuk.site/omr/test_islemleri/test_sonuc_ekle.php");
    var veri = {
      "test_id": test_id,
      "ogrenci_adi": ogrenci_adi,
      "ogrenci_numarasi": ogrenci_numarasi,
      "alinan_puan": alinan_puan,
      "ogrenci_cevaplar": ogrenci_cevaplar,
    };
    var cevap = await http.post(url, body: veri);
    print("Cevap: ${cevap.body}");
    if (cevap.body.contains("true")) {
      return cevap.body.toString();
    } else if (cevap.body.contains("false")) {
      return cevap.body.toString();
    } else {
      return cevap.body.toString();
    }
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
                          builder: (context) => TestleriListele(
                              widget.kAdi, widget.kId)));
                },
                icon: Icon(Icons.arrow_back_ios_rounded,),
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
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      height: 70,
                      width: ekranGenisligi,
                      child: tamamla
                          ? Padding(padding: EdgeInsets.all(5), child: Row(
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
                            "${alinanPuan}",
                            // "${(100 / widget.soruSayisi * dogru).toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ): Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Sonuçlar",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            Text("(Sonuçları Görmek İçin Lütfen Tamamla Butonuna Basın)", style:
                            TextStyle(color: Colors.transparent.withOpacity(0.5), fontSize: 12),)
                          ],
                        )
                      ),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),),
                  ),
                  for (int i = 0; i < widget.soruSayisi; i++)
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      shadowColor: Colors.black,
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("${i + 1} -",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            for (int j = 1; j <= 5; j++)
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      secilen[i] = j;
                                      cevapAnahtari[i + 1] = secenek[j - 1];
                                      siralanmisCevapAnahtari =
                                          SplayTreeMap<int, String>.from(
                                              cevapAnahtari);
                                      eklenenSoruSayac++;
                                      dogru=0;
                                      yanlis =0 ;
                                      bos =0;
                                      alinanPuan = 0;
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: secilen[i] == j
                                          ? Colors.grey
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          side:
                                              BorderSide(color: Colors.black))),
                                  child: Text(
                                    secenek[j - 1],
                                    style: TextStyle(color: Colors.black),
                                  ))
                          ],
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ElevatedButton.icon(
                            onPressed: () async {
                              tamamla = true;
                              alinanPuan = (100 / widget.soruSayisi * dogru).toStringAsFixed(2);
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                            label: SizedBox(
                              height: 40,
                              width: 80,
                              child: Center(
                                child: Text(
                                  "Tamamla",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.grey,
                                textStyle: TextStyle(color: Colors.black),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    side: BorderSide(color: Colors.black)))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton.icon(
                            onPressed: () {
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
                                              "Öğrenci Bilgileri",
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
                                            child: Column(
                                              children: [
                                                Padding(padding: EdgeInsets.only(bottom: 8), child: TextField(
                                                  controller: ogrenci_ismi,
                                                  keyboardType: TextInputType.number,
                                                  textInputAction: TextInputAction.done,
                                                  //autofocus: true,
                                                  enabled: true,
                                                  showCursor: false,
                                                  maxLines: 1,
                                                  decoration: InputDecoration(
                                                    hintText: "Öğrenci İsmi",
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
                                                ),),
                                                TextField(
                                                  controller: ogrenci_numarasi,
                                                  keyboardType: TextInputType.number,
                                                  textInputAction: TextInputAction.done,
                                                  //autofocus: true,
                                                  enabled: true,
                                                  showCursor: false,
                                                  maxLines: 1,
                                                  decoration: InputDecoration(
                                                    hintText: "Öğrenci Numarası",
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
                                              ],
                                            )
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
                                                  testEkle(widget.testId, ogrenci_ismi.text,
                                                      ogrenci_numarasi.text, alinanPuan,
                                                      siralanmisCevapAnahtari.values.toString());
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text("Gönder",
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
                            },
                            icon: Icon(
                              Icons.keyboard_double_arrow_up_sharp,
                              color: Colors.black,
                            ),
                            label: SizedBox(
                              height: 40,
                              width: 80,
                              child: Center(
                                child: Text(
                                  "Gönder",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.grey,
                                textStyle: TextStyle(color: Colors.black),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    side: BorderSide(color: Colors.black)))),
                      )
                    ],
                  ),
                  SizedBox(
                    height: widget.soruSayisi*20,
                    child: FutureBuilder<List<Testler>>(
                        future: testOku(widget.testId),
                        builder: (context, snapshot) {
                          if (durum == false && snapshot.hasData) {
                            return Text("${snapshot.data}");
                          } else if (snapshot.hasData && durum == true) {
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
                            for (int i = 1; i < widget.soruSayisi + 1; i++) {
                              if (siralanmisCevapAnahtari[i] == null) {
                                bos++;
                              } else if (siralanmisCevapAnahtari[i] ==
                                  cevapAnahtariListe[i - 1]) {
                                dogru++;
                              } else if (siralanmisCevapAnahtari[i] !=
                                  cevapAnahtariListe[i - 1]) {
                                yanlis++;
                              }
                            }
                            print(siralanmisCevapAnahtari[1]);
                            print(cevapAnahtariListe[0]);
                            return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        childAspectRatio: 5 / 4),
                                itemCount: widget.soruSayisi,
                                itemBuilder: (context, indeks) {
                                  return Card(
                                      color: cevapAnahtariListe[indeks] ==
                                              siralanmisCevapAnahtari[
                                                  indeks + 1]
                                          ? (Colors.green)
                                          : siralanmisCevapAnahtari[
                                                      indeks + 1] ==
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
                                              siralanmisCevapAnahtari[
                                                          indeks + 1] ==
                                                      null
                                                  ? Text(" ")
                                                  : Text(
                                                      " - ${siralanmisCevapAnahtari[indeks + 1]}"),
                                            ],
                                          ),
                                        ],
                                      ));
                                });
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
