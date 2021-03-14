import 'package:flutter/material.dart';
import 'package:music_player/Services/AuthServices.dart';
import 'package:music_player/Services/DataServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  

  @override
  void initState() {
    super.initState();
    getAT();
  }

  Future getAT()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var atData = await AuthServices().getAccessTokenDetails(prefs.getString('authCode'));
    storeAccessTokenInSP(atData);

  }

  Future storeAccessTokenInSP(var data)async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('access_token', data['access_token']);
    prefs.setString('refresh_token', data['refresh_token']);

  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            Card(
              elevation: 8,
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              child: ListTile(
                leading: Icon(Icons.search),
                title: Text('Search'),
                trailing: CircleAvatar(),
              ),
            ),

            FutureBuilder(
              future: DataServices().getData(),
              builder: (context,snap){
                return Container();
              })
          ],
        ),
      ),
    );
  }
}