// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
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
            // Colors.blue.shade600,
            // Colors.blue.shade200,
            // Colors.blue.shade100,
          ],
        )),
        child: Padding(
            padding: EdgeInsets.only(top: 50, left: 10, right: 10),
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
                            padding: EdgeInsets.only(top: ekranYuksekligi/6, bottom: ekranYuksekligi/50),
                            child: Icon(
                              MfgLabs.lock_alt,
                              size: 100,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Şifrenizi mi unuttunuz?",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 26,
                                color: Color(0xff736e7e),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, bottom: 20),
                            child: Text(
                              "Hesabınızla ilişkili e-posta adresinizi girip \n \"Şifreyi Sıfırla\" butonuna bastığınızda,"
                              "\n e-posta adresinize şifre sıfırlama bağlantısı gider",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xff736e7e),
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30.0, right: 30.0, bottom: 10.0),
                            child: TextField(
                              textInputAction: TextInputAction.next,
                              autocorrect: true,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  hintText: "E-Posta",
                                  prefixIcon: Icon(Icons.mail_outline),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    borderSide: BorderSide(
                                        color: Color(0xff736e7e), width: 3),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(
                                        color: Color(0xff736e7e), width: 2),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: SizedBox(
                                width: 180,
                                height: 45,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.arrow_forward),
                                  label: Text("    Şifreyi Sıfırla   "),
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xff736e7e),
                                      onPrimary: Colors.white,
                                      shadowColor: Colors.grey,
                                      elevation: 20,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10)),
                                      )),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
