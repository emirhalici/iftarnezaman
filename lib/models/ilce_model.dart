class IlceModel {
  int ilceId;
  String ilceName, ilceNameEn;

  IlceModel({required this.ilceId, required this.ilceName, required this.ilceNameEn});

  @override
  String toString() {
    return '$ilceId : $ilceName';
  }
}
