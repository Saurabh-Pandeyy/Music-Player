import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/Screens/HomePage.dart';
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
              style: GoogleFonts.libreBaskerville(fontSize: 20),),
            ),

            Padding(
              padding: const EdgeInsets.all(50),
              child: ElevatedButton(
                
                child: Text('Sign In with Spotify',style: TextStyle(fontSize: 16),),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xff3024e0)),
                  elevation: MaterialStateProperty.all(7),
                  padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(30, 10, 30, 10)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                ),

                onPressed: () async{

                  var authCode = await AuthServices().signInWithSpotify();

                  if(authCode != null){

                   Navigator.pushReplacement(context, MaterialPageRoute(
                     builder:(context) => HomePage()
                   ));
                  
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

//#3024e0