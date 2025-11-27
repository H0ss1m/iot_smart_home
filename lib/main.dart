import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_smart_home/firebase_options.dart';
import 'package:iot_smart_home/module/bedroom_page.dart';
import 'package:iot_smart_home/module/home_page2.dart';
import 'package:iot_smart_home/module/ketchin_page.dart';
import 'package:iot_smart_home/module/livingroom_page.dart';
import 'package:iot_smart_home/services/data/state_management/home_controller.dart';
import 'package:iot_smart_home/view/home.dart';
import 'package:iot_smart_home/view/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize GetX controllers
  Get.put(HomeController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xff101922),
          iconTheme: IconThemeData(color: Color(0xffffffff)),
          titleTextStyle: TextStyle(
            color: Color(0xffffffff),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xff101922),
        iconTheme: const IconThemeData(color: Color(0xffffffff)),
        useMaterial3: true,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: const Color(0xffffffff)),
          bodyMedium: TextStyle(color: const Color(0xffffffff)),
          bodySmall: TextStyle(color: const Color(0xffffffff)),
          titleLarge: TextStyle(color: const Color(0xffffffff)),
          titleMedium: TextStyle(color: const Color(0xffffffff)),
          titleSmall: TextStyle(color: const Color(0xffffffff)),
        ),
      ),
      initialRoute: '/splash',
      home: const Splash(),
      getPages: [
        GetPage(name: '/', page: () => const Home()),
        GetPage(name: '/livingroom', page: () => LivingroomPage()),
        GetPage(name: '/home2', page: () => HomePage2()),
        GetPage(name: '/kitchen', page: () => KitchenPage()),
        GetPage(name: '/bedroom', page: () => BedroomPage()),
        GetPage(name: '/splash', page: () => const Splash()),
      ],
    );
  }
}
