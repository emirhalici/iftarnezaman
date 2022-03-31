class CityModel {
  int cityId;
  String cityName, cityNameEn;

  CityModel({required this.cityId, required this.cityName, required this.cityNameEn});

  @override
  String toString() {
    return '$cityId : $cityName';
  }
}
