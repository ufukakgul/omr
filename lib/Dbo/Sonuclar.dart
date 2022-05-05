class Sonuclar{
  int sayac;
  String test_id;
  String ogrenci_adi;
  String ogrenci_numarasi;
  String alinan_puan;
  String ogrenci_cevaplar;

  Sonuclar(this.sayac, this.test_id, this.ogrenci_adi, this.ogrenci_numarasi,
      this.alinan_puan, this.ogrenci_cevaplar);

  factory Sonuclar.fromJson(Map<String, dynamic> json){
    return Sonuclar(
        json["sayac"] as int,
        json["test_id"] as String,
        json["ogrenci_adi"] as String,
        json["ogrenci_numarasi"] as String,
        json["alinan_puan"] as String,
        json["ogrenci_cevaplar"] as String);
  }
}