import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iftarnezaman/providers/main_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MainProvider>().startTimer();
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    Duration aksam = context.watch<MainProvider>().timeLeftForNextAksam;
    Duration imsak = context.watch<MainProvider>().timeLeftForNextImsak;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iftar Ne Zamandir Lo"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      margin: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ayarlar',
                            style: TextStyle(fontSize: 34.sp),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 400.h),
                        ],
                      ),
                    );
                  });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bir sonraki iftara kalan sure:',
              style: TextStyle(fontSize: 24.sp),
            ),
            Text(
              format(aksam),
              style: TextStyle(fontSize: 44.sp),
            ),
            SizedBox(height: 40.h),
            Text(
              'Bir sonraki sahura kalan sure:',
              style: TextStyle(fontSize: 24.sp),
            ),
            Text(
              format(imsak),
              style: TextStyle(fontSize: 44.sp),
            ),
          ],
        ),
      ),
    );
  }
}
