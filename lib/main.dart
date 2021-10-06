import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music_player/Screens/HomePage/HomePage.dart';
import 'package:music_player/Screens/Auth/LoginPage.dart';

void main() {
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    GetStorage storage = GetStorage();

    bool isUserLoggedIn = storage.read('isLoggedIn') ?? false;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: isUserLoggedIn ? HomePage() : LoginPage(),
    );
  }
}