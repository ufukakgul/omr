import 'package:omr/Dbo/Testler.dart';

class TestlerCevap {
  bool durum;
  int toplam_test_sayisi;
  List<Testler> testlerListesi;

  TestlerCevap(this.durum, this.toplam_test_sayisi, this.testlerListesi);

  factory TestlerCevap.fromJson(Map<String, dynamic> json){
    var jsonArray = json["kayitlar"] as List;
    List<Testler> testlerListesi = jsonArray.map((jsonArrayNesnesi) => Testler.fromJson(jsonArrayNesnesi)).toList();
   return TestlerCevap(json["durum"] as bool, json["toplam_test_sayisi"] as int, testlerListesi);
  }
}
