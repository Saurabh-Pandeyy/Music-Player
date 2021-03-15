import 'package:flutter/material.dart';
import 'package:music_player/Screens/HomePage.dart';
import 'package:music_player/Screens/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  bool isUserLoggedIn;

  @override
  void initState() {
    super.initState();
    checkIfUserIsLoggedIn();
  }

  Future checkIfUserIsLoggedIn() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    isUserLoggedIn = prefs.getBool('isLoggedIn') != null ? prefs.getBool('isLoggedIn') : false;
   
    return isUserLoggedIn;
    
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkIfUserIsLoggedIn(),
      builder: (context,snap){

        if(snap.connectionState == ConnectionState.waiting){
          return Center(child: Container(child: CircularProgressIndicator(),),);
        }
        if(snap.data != null ){
          return snap.data == true ? HomePage() : LoginPage();
        }
        else return Container();
      });
  }
}