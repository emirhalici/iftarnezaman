import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iftarnezaman/models/city_model.dart';
import 'package:iftarnezaman/models/ezan_model.dart';
import 'package:iftarnezaman/models/ilce_model.dart';

class ApiHelper {
  Future<List<CityModel>> getAllCities() async {
    List<CityModel> list = [];
    Uri url = Uri.parse('https://ezanvakti.herokuapp.com/sehirler/2');
    http.Response response = await http.get(url);
    if (response.statusCode != 200) {
      throw 'Network error';
    }

    var data = jsonDecode(response.body);
    for (var item in data) {
      String cityName = item['SehirAdi'];
      String cityNameEn = item['SehirAdiEn'];
      int cityId = int.parse(item['SehirID']);

      CityModel city = CityModel(cityId: cityId, cityName: cityName, cityNameEn: cityNameEn);
      list.add(city);
    }

    return list;
  }

  Future<List<IlceModel>> getIlce(int cityId) async {
    List<IlceModel> list = [];
    Uri url = Uri.parse('https://ezanvakti.herokuapp.com/ilceler/$cityId');
    http.Response response = await http.get(url);
    if (response.statusCode != 200) {
      throw 'Network error';
    }

    var data = jsonDecode(response.body);
    for (var item in data) {
      String ilceName = item['IlceAdi'];
      String ilceNameEn = item['IlceAdiEn'];
      int ilceId = int.parse(item['IlceID']);

      IlceModel ilce = IlceModel(ilceId: ilceId, ilceName: ilceName, ilceNameEn: ilceNameEn);
      list.add(ilce);
    }
    return list;
  }

  Future<List<EzanModel>> getEzan(int ilceId) async {
    List<EzanModel> list = [];
    Uri url = Uri.parse('https://ezanvakti.herokuapp.com/vakitler/$ilceId');
    http.Response response = await http.get(url);
    if (response.statusCode != 200) {
      throw 'Network error';
    }

    var data = jsonDecode(response.body);
    for (var item in data) {
      String date = item['MiladiTarihKisa'];
      String dateLong = item['MiladiTarihUzun'];
      String imsakEzan = item['Imsak'];
      String aksamEzan = item['Aksam'];
      String ikindiEzan = item['Ikindi'];
      String ogleEzan = item['Ogle'];
      String yatsiEzan = item['Yatsi'];
      EzanModel ezan = EzanModel(
        date: date,
        dateLong: dateLong,
        imsakEzan: imsakEzan,
        aksamEzan: aksamEzan,
        ikindiEzan: ikindiEzan,
        ogleEzan: ogleEzan,
        yatsiEzan: yatsiEzan,
        ilceId: ilceId,
      );
      list.add(ezan);
    }
    return list;
  }
}
