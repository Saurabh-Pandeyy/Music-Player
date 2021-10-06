import 'dart:convert';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:music_player/Widgets/SnackBarWidget.dart';

class AuthServices{

  String? authorizationCode;

  Future<String?> signInWithSpotify() async{

    await FlutterWebAuth.authenticate(

      url: "https://accounts.spotify.com/authorize?client_id=1e8e4a39b691401d83380d4d9f7a5959&response_type=code&redirect_uri=musicplayer:/&scope=user-read-private%20user-read-email%20user-modify-playback-state%20user-read-recently-played", 
      callbackUrlScheme: "musicplayer"

    ).then((value){

      authorizationCode = Uri.parse(value).queryParameters['code'];
      authorizationCode != null ? getAccessTokenDetails(authorizationCode!) : snackBarWidget('Some error occured! Please try again.');

    });

    return authorizationCode;
  }

  Future getAccessTokenDetails(String authCode) async{

    GetStorage storage = GetStorage();
 
    //Post request to spotify for getting accessToken by exchanging authCode

    var result = await http.post( Uri.parse('https://accounts.spotify.com/api/token'), 

      body: {
        'grant_type' : 'authorization_code',
        'code' : authorizationCode,
        'redirect_uri' : 'musicplayer:/',
        'client_id' : '1e8e4a39b691401d83380d4d9f7a5959',
        'client_secret' : 'f73e179e707c480d8fc09530bfa17fd2'
      });

    if(jsonDecode(result.body)['error'] == null){

      //storing AT and RT in local Storage

      storage.write('access_token', jsonDecode(result.body)['access_token']);     
      storage.write('refresh_token', jsonDecode(result.body)['refresh_token']);     
      
    }

    //if above response gives error then re-Login
    
    if(jsonDecode(result.body)['error'] != null){
      signInWithSpotify();
    }
  }
}
