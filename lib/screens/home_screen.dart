import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iftarnezaman/models/ezan_model.dart';
import 'package:iftarnezaman/providers/main_provider.dart';
import 'package:iftarnezaman/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String city = 'Ankara';

  @override
  void initState() {
    super.initState();
    context.read<MainProvider>().startTimer();
  }

  void getCity() async {
    String _city = await context.watch<MainProvider>().getCityName();
    setState(() {
      city = _city;
    });
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    getCity();

    Duration aksam = context.watch<MainProvider>().timeLeftForNextAksam;
    Duration imsak = context.watch<MainProvider>().timeLeftForNextImsak;

    EzanModel? ezan = context.watch<MainProvider>().ezan;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iftar Ne Zamandir Lo"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const SettingsScreen()),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Sehir: $city'),
          if (ezan == null)
            const Center(child: CircularProgressIndicator.adaptive())
          else
            Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  '$city İçin Ezan Saatleri',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'İmsak',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ezan.imsakEzan,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Öğle',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ezan.ogleEzan,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'İkindi',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ezan.ikindiEzan,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Akşam',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ezan.aksamEzan,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Yatsı',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            ezan.yatsiEzan,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 32),
          const Text(
            'Bir sonraki iftara kalan sure:',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            format(aksam),
            style: const TextStyle(fontSize: 44),
          ),
          const SizedBox(height: 40),
          const Text(
            'Bir sonraki sahura kalan sure:',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            format(imsak),
            style: const TextStyle(fontSize: 44),
          ),
        ],
      ),
    );
  }
}
