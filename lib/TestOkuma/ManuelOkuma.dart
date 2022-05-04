// ignore_for_file: prefer_const_constructors
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:omr/Dbo/Testler.dart';
import 'package:omr/Dbo/TestlerCevap.dart';
import 'package:omr/main.dart';
import 'package:omr/TestleriListele.dart';
import 'dart:convert';


class ManeulOkuma extends StatefulWidget {
  const ManeulOkuma(this.testId, this.soruSayisi, this.kAdi, this.kId, {Key? key}) : super(key: key);
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
  var siralanmisCevapAnahtari;
  int testSayisi = 1;
  bool durum = false;
  List cevapAnahtariListe = [];

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
    // if (cevap.body.contains("true")) {
    //   return parseTestlerCevap(cevap.body);
    // } else if (cevap.body.contains("false")) {
    //   return cevap.body;
    // } else {
    //   return cevap.body.toString();
    // }
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {},
                icon: Icon(Icons.add),
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
                                      siralanmisCevapAnahtari = SplayTreeMap<int, String>.from(cevapAnahtari);
                                      eklenenSoruSayac++;
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
                              print(cevapAnahtari.values.toString());
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
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TestleriListele(widget.kAdi, widget.kId)));
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.black,
                            ),
                            label: SizedBox(
                              height: 40,
                              width: 80,
                              child: Center(
                                child: Text(
                                  "Geri Dön",
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
                  FutureBuilder<List<Testler>>(
                    future: testOku(widget.testId),
                      builder: (context, snapshot){
                        if (durum == false && snapshot.hasData){
                          return Text("${snapshot.data} -1");
                        }
                        else if (snapshot.hasData && durum == true){
                          List<Testler> testListesi = snapshot.data!;
                          for(int i =1; i<=testListesi[0].cevap_anahtari.length; i+=3){
                            cevapAnahtariListe.add(testListesi[0].cevap_anahtari[i]);
                          }
                          return Column(
                            children: [
                              Text("${cevapAnahtariListe}"),
                              Text("${cevapAnahtariListe[0]}"),
                              Text("${cevapAnahtariListe[1]}"),
                              Text("${cevapAnahtariListe[2]}"),
                              // Text("${testListesi[0].cevap_anahtari}"),
                              // Text("${testListesi[0].cevap_anahtari[1]}"),
                              // Text("${testListesi[0].cevap_anahtari[4]}"),
                              // Text("${testListesi[0].cevap_anahtari[7]}"),
                              // Text("${testListesi[0].cevap_anahtari[10]}"),
                              // Text("${testListesi[0].cevap_anahtari[13]}"),
                            ],
                          );
                        }else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }
                  )
                ],
              ),
            ),
          ),
        )
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Center(
      //       child: Text(widget.testId),
      //     ),
      //     ElevatedButton(onPressed: (){
      //       testOku(widget.testId);
      //     }, child: Text("Verileri Al")),
      //   ],
      // )
    );
  }
}
