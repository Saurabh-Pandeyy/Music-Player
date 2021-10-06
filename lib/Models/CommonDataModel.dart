class CommonDataModel {

  final String spotifyId;
  final String spotifyName;
  final String spotifyImage;

  CommonDataModel({required this.spotifyId, required this.spotifyName, required this.spotifyImage});

  static CommonDataModel fromJsonData(Map<String,dynamic> data){
    return CommonDataModel(
      spotifyId: data['id'], 
      spotifyName: data['name'], 
      spotifyImage: data['images'][0]['url']
    );
  }

}