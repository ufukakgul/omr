// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:async/async.dart';
import 'package:omr/main.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class UploadPic extends StatefulWidget {
  const UploadPic(this._image, this.kId, {Key? key}) : super(key: key);
  final File? _image;
  final String kId;

  @override
  State<UploadPic> createState() => _UploadPicState();
}

class _UploadPicState extends State<UploadPic> {
  var icerik;
  var body = <String, dynamic>{};

  Upload(File imageFile) async {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("http://192.168.1.103:5000/getAnswers");
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      body = json.decode(value);
      print(value);
    });
  }

  Future<String> testEkle(String kullanici_id, String cevap_anahtari) async {
    var url = Uri.parse("https://ufuk.site/omr/test_islemleri/test_ekle.php");
    var veri = {
      "kullanici_id": kullanici_id,
      "cevap_anahtari": cevap_anahtari,
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
                Color(0xffd0d0d0).withOpacity(0.7),
                Color(0xffd0d0d0).withOpacity(0.6),
                Color(0xff5e4d91).withOpacity(0.2),
                Color(0xff5e4d91).withOpacity(0.1),
              ],
            )),
            child: Padding(
              padding: EdgeInsets.only(top: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Container(
                        height: ekranYuksekligi/2,
                        width: ekranGenisligi / 2,
                        child: widget._image != null
                            ? Image.file(
                          widget._image!,
                          fit: BoxFit.contain,
                        )
                            : Text("no image"),
                      ),
                      Text("\n"),
                      Text(
                        body.values.join(" | "),
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      width: ekranGenisligi,
                      height: ekranYuksekligi/2,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomRight,
                            stops: const [
                              0.3,
                              0.4,
                              0.8,
                              0.9,
                            ],
                            colors: [
                              Color(0xff5e4d91).withOpacity(0.1),
                              Color(0xff5e4d91).withOpacity(0.2),
                              Color(0xff5e4d91).withOpacity(0.6),
                              Color(0xff5e4d91).withOpacity(0.7),
                            ],
                          ),
                          // color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(100),
                              topRight: Radius.circular(100))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget._image != null
                              ? ElevatedButton.icon(
                                  onPressed: () async {
                                    testEkle(
                                        widget.kId, body.values.toString());
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            content: Text(
                                      "Cevaplarınız Kaydedildi",
                                    )));
                                    await Future.delayed(Duration(seconds: 5));
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyApp()));
                                  },
                                  icon: Icon(
                                    Icons.save,
                                    color: Colors.black,
                                  ),
                                  label: Text(
                                    "Onayla",
                                    style: GoogleFonts.robotoMono(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: Size(ekranGenisligi / 3.2, 50),
                                      side: BorderSide(
                                          color: Colors.grey, width: 2),
                                      primary: Colors.grey.withOpacity(0.1),
                                      onPrimary: Colors.white,
                                      shadowColor: Colors.grey,
                                      elevation: 20,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      )),
                                )
                              : Text(""),
                          Padding(padding: EdgeInsets.only(top: 10, bottom: 10), child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.black,
                            ),
                            label: Text(
                              "İptal",
                              style: GoogleFonts.robotoMono(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              //minimumSize: Size(150,50),
                                side: BorderSide(color: Colors.grey, width: 2),
                                fixedSize: Size(ekranGenisligi / 3.2, 50),
                                primary: Colors.grey.withOpacity(0.1),
                                onPrimary: Colors.white,
                                shadowColor: Colors.grey,
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                )),
                          ),),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {});
                            },
                            icon:
                                Icon(Icons.remove_red_eye, color: Colors.black),
                            label: Text(
                              "Göster",
                              style: GoogleFonts.robotoMono(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(color: Colors.grey, width: 2),
                                fixedSize: Size(ekranGenisligi / 3.2, 50),
                                primary: Colors.grey.withOpacity(0.1),
                                onPrimary: Colors.white,
                                shadowColor: Colors.grey,
                                elevation: 20,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                )),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
