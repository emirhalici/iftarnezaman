class EzanModel {
  String date;
  String dateLong;
  String imsakEzan, aksamEzan, ikindiEzan, ogleEzan, yatsiEzan;
  int ilceId;

  EzanModel({
    required this.date,
    required this.dateLong,
    required this.imsakEzan,
    required this.aksamEzan,
    required this.ikindiEzan,
    required this.ogleEzan,
    required this.yatsiEzan,
    required this.ilceId,
  });

  @override
  String toString() {
    return 'ilce: $ilceId $date aksam: $aksamEzan imsak: $imsakEzan';
  }
}
