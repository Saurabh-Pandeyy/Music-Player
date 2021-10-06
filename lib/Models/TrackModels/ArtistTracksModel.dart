class ArtistTracksModel {

  final String? trackImage;
  final String? trackName;
  final String? trackSubtitle;
  final int? trackDuration;
  final String? trackUrl;

  ArtistTracksModel({
    required this.trackImage, required this.trackName, 
    required this.trackSubtitle, required this.trackDuration, required this.trackUrl
  });

  static ArtistTracksModel fromJsonData(Map<String,dynamic> data){

    List subtitle = [];

    for(int i = 0; i < data['artists'].length; i++){

      if(!subtitle.contains(data['artists'][i]['name'])){
        
        subtitle.add(data['artists'][i]['name']);
      }
    }

    return ArtistTracksModel(

      trackName: data['name'], 
      trackImage: data['album']['images'][0]['url'], 
      trackSubtitle: subtitle.toString().split('[').last.split(']').first,
      trackDuration: data['duration_ms'],
      trackUrl: data['preview_url']
    );
  }
}