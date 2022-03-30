// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestEkle extends StatefulWidget {
  const TestEkle(this.eklenenSoruSayisi, this.kAdi, this.kId, {Key? key})
      : super(key: key);
  final String eklenenSoruSayisi;
  final String kAdi;
  final String kId;

  @override
  State<TestEkle> createState() => _TestEkleState();
}

class _TestEkleState extends State<TestEkle> {
  var secenek = ["A", "B", "C", "D", "E"];
  var secilen = <int, int>{};
  var cevapAnahtari = <int, String>{};

  Future<String> testEkle(String kullanici_id, String cevap_anahtari) async {
    var url = Uri.parse("https://ufuk.site/omr/test_islemleri/test_ekle.php");
    var veri = {
      "kullanici_id": kullanici_id,
      "cevap_anahtari": cevap_anahtari,
    };
    var cevap = await http.post(url, body: veri);
    print("Cevap: ${cevap.body}");
    if(cevap.body.contains("true")) {
      return cevap.body.toString();
    } else if (cevap.body.contains("false")) {
      return cevap.body.toString();
    } else return cevap.body.toString();
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
                  for (int i = 0; i < int.parse(widget.eklenenSoruSayisi); i++)
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      shadowColor: Colors.black,
                      elevation: 20,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${i + 1} -",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            for (int j = 1; j <= 5; j++)
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      secilen[i] = j;
                                      cevapAnahtari[i+1]=secenek[j-1];
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
                  ElevatedButton.icon(
                      onPressed: () {
                        testEkle(widget.kId, cevapAnahtari.values.toString());
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      label: SizedBox(
                        width: 80,
                        height: 50,
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
                ],
              ),
            ),
          ),
        ));
  }
}
