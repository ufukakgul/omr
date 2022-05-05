import 'package:omr/Dbo/Sonuclar.dart';

class SonuclarCevap{
  bool durum;
  int toplam_test_sayisi;
  List<Sonuclar> sonuclarListesi;

  SonuclarCevap(this.durum, this.toplam_test_sayisi, this.sonuclarListesi);

  factory SonuclarCevap.fromJson(Map<String, dynamic> json){
    var jsonArray = json["kayitlar"] as List;
    List<Sonuclar> sonuclarListesi = jsonArray.map((jsonArrayNesnesi) => Sonuclar.fromJson(jsonArrayNesnesi)).toList();

    return SonuclarCevap(json["durum"] as bool, json["toplam_test_sayisi"] as int, sonuclarListesi);
  }
}