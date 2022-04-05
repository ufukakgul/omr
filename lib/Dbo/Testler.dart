class Testler {
  int sayac;
  String kullanici_id;
  String cevap_anahtari;
  String test_id;
  Testler(this.sayac, this.kullanici_id, this.cevap_anahtari, this.test_id);

  factory Testler.fromJson(Map<String, dynamic> json) {
    return Testler(
        json["sayac"] as int,
        json["kullanici_id"] as String,
        json["cevap_anahtari"] as String,
        json["test_id"] as String
    );
  }
}