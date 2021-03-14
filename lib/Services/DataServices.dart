import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataServices{

  Future getData()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var accessToken = prefs.getString('access_token');


    Map<String,String> headers = {

      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken"
      
    };

    try{

      var result = await http.get( Uri.parse('https://api.spotify.com/v1/me'), headers: headers );

      return result;

    }catch(e){
      print(e.toString());
    }
  }
}
