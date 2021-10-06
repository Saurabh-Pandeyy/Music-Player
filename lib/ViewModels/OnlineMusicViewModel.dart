import 'package:get/get.dart';
import 'package:music_player/Models/CategoryModel.dart';
import 'package:music_player/Models/CommonDataModel.dart';
import 'package:music_player/Services/DataServices.dart';

class OnlineMusicViewModel extends GetxController{

  var isLoading = true.obs;
  var indianPlaylists = List<CommonDataModel>.empty(growable: true).obs;
  var internationalPlaylists = List<CommonDataModel>.empty(growable: true).obs;
  var podcasts = List<CommonDataModel>.empty(growable: true).obs;
  var newReleases = List<CommonDataModel>.empty(growable: true).obs;
  var artists = List<CommonDataModel>.empty(growable: true).obs;
  var myPlaylists = List<CommonDataModel>.empty(growable: true).obs;

  @override
  onInit(){
    indianFeaturedPlaylist();
    internationalFeaturedPlaylist();
    popularPodcastList();
    newReleasesList();
    artistsList();
    myPlaylist();
    super.onInit();
  }

  indianFeaturedPlaylist() async {

    isLoading(true);
    
    if(await DataServices().getIndianFeaturedPlaylists() != null){

      List data = await DataServices().getIndianFeaturedPlaylists().then((value) => value['playlists']['items']) ;
      indianPlaylists.value = data.map((e) => CommonDataModel.fromJsonData(e)).toList();

    }
    
    isLoading(false);
    
  }

  internationalFeaturedPlaylist() async {

    isLoading(true);

    if(await DataServices().getInternationalFeaturedPlaylists() != null){
      List data = await DataServices().getInternationalFeaturedPlaylists().then((value) => value['playlists']['items']) ;
      internationalPlaylists.value = data.map((e) => CommonDataModel.fromJsonData(e)).toList();

    }
    
    isLoading(false);
    
  }

  

  popularPodcastList() async{

    isLoading(true);

    if(await DataServices().getPopularPodcastsData() != null){

      List data = await DataServices().getPopularPodcastsData().then((value) => value['shows']);
      podcasts.value = data.map((e) => CommonDataModel.fromJsonData(e)).toList();
    }

    isLoading(false);
  }

  newReleasesList() async{

    isLoading(true);

    if(await DataServices().getNewReleasesData() != null){

      List data = await DataServices().getNewReleasesData().then((value) => value['albums']['items']);
      newReleases.value = data.map((e) => CommonDataModel.fromJsonData(e)).toList();
    }

    isLoading(false);
  }

  artistsList() async{

    isLoading(true);

    if(await DataServices().getArtists() != null){

      List data = await DataServices().getArtists().then((value) => value['artists']);
      artists.value = data.map((e) => CommonDataModel.fromJsonData(e)).toList();
    }

    isLoading(false);
  }

  myPlaylist() async{

    isLoading(true);
    
    if(await DataServices().getMyPlayListData() != null){

      List data = await DataServices().getMyPlayListData().then((value) => value['items']);
      myPlaylists.value = data.isNotEmpty ? data.map((e) => CommonDataModel.fromJsonData(e)).toList() : [];

    }
    
    isLoading(false);

  }
  
}