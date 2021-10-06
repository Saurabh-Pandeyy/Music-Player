import 'package:get/get.dart';
import 'package:music_player/Models/TrackModels/ArtistTracksModel.dart';
import 'package:music_player/Models/TrackModels/NewReleasesTracksModel.dart';
import 'package:music_player/Models/TrackModels/PlayListTrackModel.dart';
import 'package:music_player/Models/TrackModels/PodcastModel.dart';
import 'package:music_player/Services/DataServices.dart';

class DetailPageViewModel extends GetxController{

  //using observables due to futures

  final dataServices = Get.put(DataServices());

  var isLoading = true.obs;

  var indianPlaylistTracks = List<PlayListTracksModel>.empty(growable: true).obs;
  var internationalPlaylistsTracks = List<PlayListTracksModel>.empty(growable: true).obs;
  var podcastsTracks = List<PodcastModel>.empty(growable: true).obs;
  var newReleasesTracks = List<NewReleasesTracksModel>.empty(growable: true).obs;
  var artistsTracks = List<ArtistTracksModel>.empty(growable: true).obs;
  var myPlaylistsTracks = List<PlayListTracksModel>.empty(growable: true).obs;


  indianTracks(String playlistId) async { 

    isLoading(true);
    
    List data = await dataServices.getPlaylistTracks(playlistId).then((value) => value['items']) ;
    indianPlaylistTracks.value = data.map((e) {
      if(playlistId == '37i9dQZF1DWXJfnUiYjUKT'){
        print(e);
      }
      return PlayListTracksModel.fromJsonData(e);
    }).toList();
    
    isLoading(false);
    
  }

  internationalTracks(String playlistId) async {

    isLoading(true);

    List data = await dataServices.getPlaylistTracks(playlistId).then((value) => value['items']) ;
    internationalPlaylistsTracks.value = data.map((e) => PlayListTracksModel.fromJsonData(e)).toList();
    
    isLoading(false);
    
  }

  myTracks(String playlistId) async{

    isLoading(true);
    
    List data = await dataServices.getPlaylistTracks(playlistId).then((value) => value['items']);
    myPlaylistsTracks.value = data.isNotEmpty ? data.map((e) => PlayListTracksModel.fromJsonData(e)).toList() : [];
    
    isLoading(false);

  }

 

  popularPodcastTracks(String podcastId) async{

    isLoading(true);

    List data = await dataServices.getPodcastEpisodes(podcastId).then((value) => value['items']);
    podcastsTracks.value = data.map((e) => PodcastModel.fromJsonData(e)).toList();

    isLoading(false);
  }

  newReleasesTracksList(String albumId, String albumImage) async{

    isLoading(true);

    List data = await dataServices.getNewReleasesTracks(albumId).then((value) => value['items']);
    newReleasesTracks.value = data.map((e) => NewReleasesTracksModel.fromJsonData(e,albumImage)).toList();

    isLoading(false);
  }

  artistsList(String artistId) async{

    isLoading(true);

    List data = await dataServices.getArtistTracks(artistId).then((value) => value['tracks']);
    artistsTracks.value = data.map((e) => ArtistTracksModel.fromJsonData(e)).toList();

    isLoading(false);
  }

 
}