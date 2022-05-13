// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:omr/Dbo/Testler.dart';
import 'package:omr/Dbo/TestlerCevap.dart';
import 'package:http/http.dart' as http;
import 'package:omr/main.dart';

class SonucAyrinti extends StatefulWidget {
  SonucAyrinti(
      this.cevaplarId,
      this.testId,
      this.ogrenciAdi,
      this.ogrenciNo,
      this.alinanPuan,
      this.ogrenciCevaplar,
      {Key? key}) : super(key: key);

  String cevaplarId;
  String testId;
  String ogrenciAdi;
  String ogrenciNo;
  String alinanPuan;
  String ogrenciCevaplar;

  @override
  State<SonucAyrinti> createState() => _SonucAyrintiState();
}

class _SonucAyrintiState extends State<SonucAyrinti> {
  int testSayisi = 1;
  bool durum = false;
  // var siralanmisCevapAnahtari = <int, String>{};

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

  @override
  Widget build(BuildContext context) {
    List cevapAnahtariListe = [];
    List siralanmisCevapAnahtari = [];
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.indigoAccent.shade700.withOpacity(0.5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${widget.ogrenciNo} - ${widget.ogrenciAdi}", style: TextStyle(fontSize: 16),),
                Text("Sınav Detayları", style: TextStyle(color: Colors.white, fontSize: 16),),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyApp()));
              },
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ),
              hoverColor: Colors.white,
            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text(widget.cevaplarId),
              Text(widget.testId),
              Text(widget.ogrenciAdi),
              Text(widget.ogrenciNo),
              Text(widget.alinanPuan),
              Text(widget.ogrenciCevaplar),
              SizedBox(
                height: 5 * 20,
                child: FutureBuilder<List<Testler>>(
                    future: testOku(widget.testId),
                    builder: (context, snapshot) {
                      if (durum == false && snapshot.hasData) {
                        return Text("${snapshot.data}");
                      } else if (snapshot.hasData && durum == true) {
                        List<Testler> testListesi = snapshot.data!;
                        cevapAnahtariListe.clear();
                        for (int i = 1; i <= testListesi[0].cevap_anahtari.length; i += 3) {
                          siralanmisCevapAnahtari.add(widget.ogrenciCevaplar[i]);
                          cevapAnahtariListe.add(testListesi[0].cevap_anahtari[i]);
                        }
                        return GridView.builder(
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                childAspectRatio: 5 / 4),
                            itemCount: 5,
                            itemBuilder: (context, indeks) {
                              return Card(
                                  color: cevapAnahtariListe[indeks] == siralanmisCevapAnahtari[indeks]
                                      ? (Colors.green) : siralanmisCevapAnahtari[indeks] == null
                                      ? Colors.white : siralanmisCevapAnahtari[indeks] == "#" ? Colors.blue : Colors.red,
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
                                          indeks] ==
                                              null
                                              ? Text(" ")
                                              : Text(
                                              " - ${siralanmisCevapAnahtari[indeks]}"),
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
    );
  }
}
