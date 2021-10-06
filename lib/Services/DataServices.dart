import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class DataServices{

  GetStorage storage = GetStorage();

  Future getMyPlayListData() async{
    return await getRequest('https://api.spotify.com/v1/me/playlists?limit=50').then((value) => jsonDecode(value.body) );
  }

  Future getPopularPodcastsData() async{
    return await getRequest('https://api.spotify.com/v1/shows?ids=4rOoJ6Egrf8K2IrywzwOMk%2C6ZcvVBPQ2ToLXEWVbaw59P%2C2JXFCMLGVhTBtdz1WYxd4H%2C4BuXlpcana6xU2ctfZ3qgZ%2C12jUp5Aa63c5BYx3wVZeMA').then((value) => jsonDecode(value.body));
  }

  Future getNewReleasesData() async{
    return await getRequest('https://api.spotify.com/v1/browse/new-releases?country=IN&limit=20').then((value) => jsonDecode(value.body));
  }

  Future getIndianFeaturedPlaylists() async{
    return await getRequest('https://api.spotify.com/v1/browse/featured-playlists?country=IN&limit=20').then((value) => jsonDecode(value.body));
  }

  Future getInternationalFeaturedPlaylists() async{
    return await getRequest('https://api.spotify.com/v1/browse/featured-playlists?limit=20').then((value) => jsonDecode(value.body));
  }

  Future getCategoriesData() async{
    return await getRequest('https://api.spotify.com/v1/browse/categories?country=IN').then((value) => jsonDecode(value.body));
  }

  Future getArtists() async{
    return await getRequest('https://api.spotify.com/v1/artists?ids=4YRxDV8wJFPHPTeXepOstw%2C1uNFoZAHBGtllmzznpCI3s%2C1wRPtKGflJrBx9BmLsSwlU%2C06HL4z0CvFAxyc27GXpf02%2C5f4QpKfy7ptCHwTqspnSJI').then((value) => jsonDecode(value.body));
  }









  //------------------------------------------------------------------------------------------------------------------------------------------------







  Future getPlaylistTracks(String playlistId) async{
    
    return await getRequest('https://api.spotify.com/v1/playlists/$playlistId/tracks?limit=50').then((value) => jsonDecode(value.body));
  }

  Future getPodcastEpisodes(String podcastId) async{
    return await getRequest('https://api.spotify.com/v1/shows/$podcastId/episodes?limit=50').then((value) => jsonDecode(value.body));
  }

  Future getNewReleasesTracks(String albumId)async{
    return await getRequest('https://api.spotify.com/v1/albums/$albumId/tracks?limit=50').then((value) => jsonDecode(value.body));
  }

  Future getArtistTracks(String artistId) async{
    return await getRequest('https://api.spotify.com/v1/artists/$artistId/top-tracks?market=IN').then((value) => jsonDecode(value.body));
  }









  
 
  Future getRequest(String url) async{

    var accessToken = storage.read('access_token');

    var result = await http.get( Uri.parse(url),
     headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken"
    });

    if(result.statusCode == 401){   //accesstoken gets expired
      result = await createNewAccessTokenWithRefreshToken(url);
    }
    return result;
  }

  //if accesstoken gets expired 
  Future createNewAccessTokenWithRefreshToken(String url) async{

    var refreshToken = storage.read('refresh_token');

    var result = await http.post(Uri.parse('https://accounts.spotify.com/api/token'),body: {
      'grant_type' : 'refresh_token',
      'refresh_token' : '$refreshToken',
      'client_id' : '1e8e4a39b691401d83380d4d9f7a5959',
      'client_secret' : 'f73e179e707c480d8fc09530bfa17fd2'
    });
      
    storage.write('access_token', jsonDecode(result.body)['access_token']); 
    return getRequest(url);
  }
}
