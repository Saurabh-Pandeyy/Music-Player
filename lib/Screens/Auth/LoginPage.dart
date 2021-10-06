import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/Screens/HomePage/HomePage.dart';
import 'package:music_player/Services/AuthServices.dart';

class LoginPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Card(
              shape: CircleBorder(),
              shadowColor: Colors.purple, 
              child: CircleAvatar(
                backgroundImage: AssetImage('lib/Images/logo.png'),
                radius: 40,
              ),
              elevation: 5,
            ),
 
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text('Music Player', 
              style: GoogleFonts.croissantOne(fontSize: 27),), 
            ),

            Padding(
              padding: const EdgeInsets.all(50),
              child: ElevatedButton(
                
                child: Text('Sign In with Spotify',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 16,))), 
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xff3024e0)),
                  elevation: MaterialStateProperty.all(7),
                  padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(30, 10, 30, 10)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                ),

                onPressed: () async{

                  String? authCode = await AuthServices().signInWithSpotify();

                  if(authCode != null){

                    GetStorage storage = GetStorage();
                    storage.write('isLoggedIn', true);
                  
                    Get.to(() => HomePage());
                  
                  }
                }, 
              ),
            )
          ],
        )
      ),
    );
  }
}