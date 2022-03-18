// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
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
              Color(0xffccd5ae),
              Color(0xffe9edc9),
              Color(0xfffefae0),
              Color(0xffccd5ae),

            ],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: ekranGenisligi / 15 * 14,
                height: ekranYuksekligi / 15 * 14,
                decoration: BoxDecoration(
                    // color: Colors.white.withOpacity(0.3),
                    color: Color(0xffccd5ae),
                    //borderRadius: BorderRadius.all(Radius.circular(60))
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )),
                child: Column(
                  children: [
                    Text(
                      "\nOptik Form\nOkuma Sistemi",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoMono(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image(
                              image: AssetImage("resimler/optikForm.jpg"),
                              // image: NetworkImage(
                              //     "https://ufuk.site/omr/assets/optikForm.jpg"),
                              color: Colors.white.withOpacity(0.7),
                              colorBlendMode: BlendMode.modulate,
                            ),
                            // Text(
                            //   "\nOptik Form\nOkuma Sistemi",
                            //   textAlign: TextAlign.center,
                            //   style: GoogleFonts.robotoMono(
                            //       color: Colors.blue.shade900,
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 25),
                            // ),
                          ],
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
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "Kullanıcı Mail",
                              prefixIcon: Icon(Icons.person),
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                    color: Colors.blue.shade700, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(
                                    color: Colors.blue.shade700, width: 2),
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 16),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 20,
                        shadowColor: Colors.indigo,
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              hintText: "Şifre",
                              prefixIcon: Icon(Icons.vpn_key),
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide: BorderSide(
                                    color: Colors.blue.shade700, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(
                                    color: Colors.blue.shade700, width: 2),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 180,
                      height: 45,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_forward),
                        label: Text("GİRİŞ YAP", style: GoogleFonts.robotoMono(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                        ),),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue.shade600,
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
                      height: ekranYuksekligi/14,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Hesabınız Yok Mu?   ", style: TextStyle(color: Colors.black),),
                        TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {},
                            child: Text("Üye Ol", style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),)),
                      ],
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.only(top: 5),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {},
                        child: Text("Şifrenizi mi unuttunuz?", style: TextStyle(color: Colors.black , decoration: TextDecoration.underline),)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
