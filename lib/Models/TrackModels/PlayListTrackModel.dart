class PlayListTracksModel {

  final String? trackImage;
  final String? trackName;
  final String? trackSubtitle;
  final int? trackDuration;
  final String? trackUrl;

  PlayListTracksModel({
    required this.trackImage, required this.trackName, 
    required this.trackSubtitle, required this.trackDuration, required this.trackUrl
  });

  static PlayListTracksModel fromJsonData(Map<String,dynamic> data){
    return PlayListTracksModel(

      trackName: data['track']['name'], 
      trackImage: data['track']['album']['images'][0]['url'], 
      trackSubtitle: data['track']['artists'][0]['name'],
      trackDuration: data['track']['duration_ms'],
      trackUrl: data['track']['preview_url']
    );
  }
}