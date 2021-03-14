import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;

class AuthServices{

  var authCode;
  var accessToken;


  Future signInWithSpotify() async{

    await FlutterWebAuth.authenticate(

      url: "https://accounts.spotify.com/authorize?client_id=1e8e4a39b691401d83380d4d9f7a5959&response_type=code&redirect_uri=musicplayer:/&scope=user-read-private%20user-read-email%20user-modify-playback-state", 
      callbackUrlScheme: "musicplayer"

    ).then((value){
      authCode = Uri.parse(value).queryParameters['code'];
    });

    return authCode;
  }

  Future getAccessTokenDetails(String authCode) async{

    Map<String,String> body = {
      'grant_type' : 'authorization_code',
      'code' : authCode,
      'redirect_uri' : 'musicplayer:/',
      'client_id' : '1e8e4a39b691401d83380d4d9f7a5959',
      'client_secret' : 'f73e179e707c480d8fc09530bfa17fd2'

    };

    var result = await http.post(Uri.parse('https://accounts.spotify.com/api/token'),body: body);

    return result;
  }
}
