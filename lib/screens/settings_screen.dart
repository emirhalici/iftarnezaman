import 'package:flutter/material.dart';
import 'package:iftarnezaman/models/city_model.dart';
import 'package:iftarnezaman/models/ilce_model.dart';
import 'package:iftarnezaman/providers/main_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<CityModel> cityList = [];
  List<String> cityNameList = [];
  List<IlceModel> ilceList = [];
  List<String> ilceNameList = [];
  String dropdownButtonCityValue = 'Yükleniyor';
  String dropdownButtonIlceValue = 'Yükleniyor';

  @override
  void initState() {
    super.initState();
    getCityList();
  }

  void getCityList() async {
    cityList = await context.read<MainProvider>().getCityList();
    for (var city in cityList) {
      cityNameList.add(city.cityName);
    }
    String cityName = await context.read<MainProvider>().getCityName();

    if (mounted) {
      setState(() {
        //dropdownButtonCityValue = cityNameList[0];
        dropdownButtonCityValue = cityName;
      });
    }

    ilceList = [];
    ilceNameList = [];
    ilceList = await context.read<MainProvider>().getIlceList();
    for (var ilce in ilceList) {
      ilceNameList.add(ilce.ilceName);
    }

    //String ilceName = await context.read<MainProvider>().getIlceName();
    if (mounted) {
      setState(() {
        //dropdownButtonIlceValue = ilceNameList[0]; // first in list
        //dropdownButtonIlceValue = ilceName; // ilce name
        dropdownButtonIlceValue = cityName; // city name
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Ayarlar"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () async {
            // save the values
            final prefs = await SharedPreferences.getInstance();
            for (var ilce in ilceList) {
              if (ilce.ilceName == dropdownButtonIlceValue) {
                int ilceId = ilce.ilceId;
                prefs.setInt('ilce', ilceId);
              }
            }

            context.read<MainProvider>().cancelTimer();
            context.read<MainProvider>().startTimer();

            Navigator.pop(context);
          }),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (cityNameList.isEmpty)
              const CircularProgressIndicator.adaptive()
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Şehir",
                    style: TextStyle(fontSize: 32),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 64),
                    child: DropdownButton<String>(
                      value: dropdownButtonCityValue,
                      icon: const Icon(Icons.arrow_downward),
                      isExpanded: true,
                      elevation: 16,
                      style: const TextStyle(fontSize: 20),
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onChanged: (String? newValue) async {
                        setState(() {
                          dropdownButtonCityValue = newValue!;
                        });
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        int cityId = context.read<MainProvider>().getCityIdFromCityName(dropdownButtonCityValue)!;
                        prefs.setInt('il', cityId);
                        ilceList = [];
                        ilceNameList = [];
                        ilceList = await context.read<MainProvider>().getIlceList();
                        for (var ilce in ilceList) {
                          ilceNameList.add(ilce.ilceName);
                        }
                        setState(() {
                          dropdownButtonIlceValue = ilceNameList[0];
                        });
                      },
                      items: cityNameList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            if (ilceNameList.isEmpty)
              const CircularProgressIndicator.adaptive()
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "İlçe",
                    style: TextStyle(fontSize: 32),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 64),
                    child: DropdownButton<String>(
                      value: dropdownButtonIlceValue,
                      icon: const Icon(Icons.arrow_downward),
                      isExpanded: true,
                      elevation: 16,
                      style: const TextStyle(fontSize: 20),
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onChanged: (String? newValue) async {
                        setState(() {
                          dropdownButtonIlceValue = newValue!;
                        });
                      },
                      items: ilceNameList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
