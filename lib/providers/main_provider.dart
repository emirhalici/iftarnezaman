import 'package:flutter/material.dart';
import 'package:iftarnezaman/helpers/api_helper.dart';
import 'package:iftarnezaman/models/city_model.dart';
import 'package:iftarnezaman/models/ilce_model.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/ezan_model.dart';

class MainProvider with ChangeNotifier {
  ApiHelper apiHelper = ApiHelper();
  List<CityModel> cityList = [];
  List<IlceModel> ilceList = [];
  late Timer timer;
  late Timer timer2;
  EzanModel? _ezan;

  EzanModel? get ezan => _ezan;

  Future<List<CityModel>> getCityList() async {
    if (cityList.isEmpty) {
      cityList = await apiHelper.getAllCities();
    }
    return cityList;
  }

  Future<List<IlceModel>> getIlceList() async {
    final prefs = await SharedPreferences.getInstance();
    int cityId = prefs.getInt('il') ?? 506;
    ilceList = await apiHelper.getIlce(cityId);
    return ilceList;
  }

  int? getCityIdFromCityName(String cityName) {
    for (var city in cityList) {
      if (city.cityName == cityName) {
        return city.cityId;
      }
    }
    return null;
  }

  Duration getTimeDifference(DateTime dateTime) {
    DateTime now = DateTime.now();
    Duration diff = dateTime.difference(now);
    return diff;
  }

  Duration timeLeftForNextAksam = const Duration(seconds: 10);
  Duration timeLeftForNextImsak = const Duration(seconds: 10);

  EzanModel? getEzanFromDate(DateTime date, List<EzanModel> list) {
    const String pattern = 'dd.MM.yyyy';
    final String day = DateFormat(pattern).format(date);
    for (var ezan in list) {
      if (day == ezan.date) {
        return ezan;
      }
    }
    return null;
  }

  Future<String> getCityName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String city = 'Ankara';
    int ilce = pref.getInt('ilce') ?? 9206;
    if (ilce == 9206) {
      city = 'Ankara';
    } else if (ilce == 9819) {
      city = 'Samsun';
    } else if (ilce == 9470) {
      city = 'Eskişehir';
    }
    return city;
  }

  void startTimer() async {
    final prefs = await SharedPreferences.getInstance();
    int ilceId = prefs.getInt('ilce') ?? 9206;
    if (prefs.getInt('ilce') == null) {
      prefs.setInt('ilce', 9206);
    }

    const String pattern = 'dd.MM.yyyy';
    DateTime today = DateTime.now();
    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    final String tomorrowDay = DateFormat(pattern).format(tomorrow);
    final String day = DateFormat(pattern).format(today);
    List<EzanModel> ezanList = await apiHelper.getEzan(ilceId);

    _ezan = getEzanFromDate(DateTime.now(), ezanList)!;
    EzanModel ezanTomorrow = getEzanFromDate(tomorrow, ezanList)!;
    String aksam = '${ezan!.aksamEzan} $day';
    String imsak = '${ezan!.imsakEzan} $day';
    final formatter = DateFormat('hh:mm dd.MM.yyyy');

    DateTime aksamDateTime = formatter.parse(aksam);
    DateTime imsakDateTime = formatter.parse(imsak);

    Duration aksamDifference = aksamDateTime.difference(today);
    Duration imsakDifference = imsakDateTime.difference(today);

    if (aksamDifference.inMinutes < 0) {
      String aksam = '${ezanTomorrow.aksamEzan} $tomorrowDay';
      aksamDateTime = formatter.parse(aksam);
      aksamDifference = aksamDateTime.difference(today);
    }

    if (imsakDifference.inMinutes < 0) {
      String imsak = '${ezanTomorrow.imsakEzan} $tomorrowDay';
      imsakDateTime = formatter.parse(imsak);
      imsakDifference = imsakDateTime.difference(today);
    }

    timeLeftForNextAksam = aksamDifference;
    timeLeftForNextImsak = imsakDifference;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeftForNextAksam.inSeconds <= 0) {
        timer.cancel();
      }
      timeLeftForNextAksam = Duration(seconds: timeLeftForNextAksam.inSeconds - 1);
      notifyListeners();
    });

    timer2 = Timer.periodic(const Duration(seconds: 1), (timer2) {
      if (timeLeftForNextImsak.inSeconds <= 0) {
        timer2.cancel();
      }
      timeLeftForNextImsak = Duration(seconds: timeLeftForNextImsak.inSeconds - 1);
      notifyListeners();
    });
  }

  void cancelTimer() {
    timer.cancel();
    timer2.cancel();
  }
}
