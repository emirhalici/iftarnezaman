import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iftarnezaman/helpers/api_helper.dart';
import 'package:iftarnezaman/models/city_model.dart';
import 'package:iftarnezaman/providers/main_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iftar Ne Zamandir Lo"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Test',
              style: TextStyle(fontSize: 44.sp),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              //context.read<MainProvider>().getTimeDifference(dateTime);
              ApiHelper helper = ApiHelper();
              helper.getEzan(9206);
            },
            child: const Text("Press me"),
          ),
        ],
      ),
    );
  }
}
