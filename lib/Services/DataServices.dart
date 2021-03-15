import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataServices{

  Future getData()async{


    SharedPreferences prefs = await SharedPreferences.getInstance();

    var accessToken = prefs.getString('access_token');
    print('getData AT - $accessToken');

    var result = await http.get( Uri.parse('https://api.spotify.com/v1/me/playlists'),
     headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken"
    });

    if(jsonDecode(result.body)['error'] != null && jsonDecode(result.body)['error']['status'] == 401){
      result = await createNewAccessTokenWithRefreshToken('https://api.spotify.com/v1/me/playlists');
    }
  
    return result;
  }

  Future createNewAccessTokenWithRefreshToken(String url) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var refreshToken = prefs.getString('refresh_token');

    var result = await http.post(Uri.parse('https://accounts.spotify.com/api/token'),body: {
      'grant_type' : 'refresh_token',
      'refresh_token' : '$refreshToken',
      'client_id' : '1e8e4a39b691401d83380d4d9f7a5959',
      'client_secret' : 'f73e179e707c480d8fc09530bfa17fd2'
    });
      
    prefs.setString('access_token', jsonDecode(result.body)['access_token']); 

    return await http.get( Uri.parse(url),
     headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${jsonDecode(result.body)['access_token']}"
    });
  }
}
