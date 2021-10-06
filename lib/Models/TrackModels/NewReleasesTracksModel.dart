class NewReleasesTracksModel {

  final String? trackImage;
  final String? trackName;
  final String? trackSubtitle;
  final int? trackDuration;
  final String? trackUrl;

  NewReleasesTracksModel({
    required this.trackImage, required this.trackName, 
    required this.trackSubtitle, required this.trackDuration, required this.trackUrl
  });

  static NewReleasesTracksModel fromJsonData(Map<String,dynamic> data,String trackImage){

    List subtitle = [];

    for(int i = 0; i < data['artists'].length; i++){

      if(!subtitle.contains(data['artists'][i]['name'])){
        
        subtitle.add(data['artists'][i]['name']);
      }
    }

    return NewReleasesTracksModel(

      trackName: data['name'], 
      trackImage: trackImage, 
      trackSubtitle: subtitle.toString().split('[').last.split(']').first,
      trackDuration: data['duration_ms'],
      trackUrl: data['preview_url']
    );
  }
}