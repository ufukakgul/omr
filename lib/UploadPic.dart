// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class UploadPic extends StatefulWidget {
  const UploadPic(this._image, {Key? key}) : super(key: key);
  final File? _image;

  @override
  State<UploadPic> createState() => _UploadPicState();
}

class _UploadPicState extends State<UploadPic> {

  var body = <String, dynamic>{};
  var icerik;

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
      body = json.decode(value);
      print(value);
      print(body.values);
    });
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
                Color(0xffd0d0d0).withOpacity(0.2),
                Color(0xffd0d0d0).withOpacity(0.1),
              ],
            )),
          child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: ekranGenisligi/2,
                  child: widget._image != null
                      ? Image.file(
                    widget._image!,
                    fit: BoxFit.contain,
                  )
                      : Text("no image"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    widget._image != null ? ElevatedButton.icon(
                      onPressed: () {Upload(widget._image!);
                        icerik = body.values;
                        setState(() {

                        });
                        },
                      icon: Icon(Icons.save),
                      label: Text(
                        "Onayla",
                        style: GoogleFonts.robotoMono(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff736e7e),
                          onPrimary: Colors.white,
                          shadowColor: Colors.grey,
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                    ) : Text(""),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.cancel),
                      label: Text(
                        "İptal Et",
                        style: GoogleFonts.robotoMono(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xff736e7e),
                          onPrimary: Colors.white,
                          shadowColor: Colors.grey,
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                    )
                  ],
                ),
                Text("$icerik"),
              ],
            ),
          )
      )
    );
  }
}
