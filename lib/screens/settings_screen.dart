import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iftarnezaman/models/city_model.dart';
import 'package:iftarnezaman/providers/main_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _switchValue = false;

  void setBool() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('ilce') == 9470) {
      setState(() {
        _switchValue = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Ayarlar"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save),
          onPressed: () async {
            // save the values
            final prefs = await SharedPreferences.getInstance();
            if (_switchValue) {
              // eskisehir 9470
              prefs.setInt('ilce', 9470);
            } else {
              // samsun 9819
              prefs.setInt('ilce', 9819);
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
            const Text(
              "Şehir",
              style: TextStyle(fontSize: 32),
            ),
            Row(
              children: [
                const Text('Samsun/Eskisehir'),
                Switch.adaptive(
                    activeColor: Theme.of(context).colorScheme.primary,
                    value: _switchValue,
                    onChanged: (val) {
                      setState(() {
                        _switchValue = val;
                      });
                    }),
              ],
            ),
            SizedBox(height: 16.h),
            const Text(
              "İlçe",
              style: TextStyle(fontSize: 32),
            ),
          ],
        ),
      ),
    );
  }
}
