class PodcastModel {

  final String? trackImage;
  final String? trackName;
  final String? trackSubtitle;
  final int? trackDuration;
  final String? trackUrl;

  PodcastModel({
    required this.trackImage, required this.trackName, 
    required this.trackSubtitle, required this.trackDuration, required this.trackUrl
  });

  static PodcastModel fromJsonData(Map<String,dynamic> data){
    return PodcastModel(

      trackName: data['name'], 
      trackImage: data['images'][0]['url'], 
      trackSubtitle: data['release_date'],
      trackDuration: data['duration_ms'],
      trackUrl: data['audio_preview_url']
    );
  }

}