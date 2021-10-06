class CategoryModel {

  final String spotifyId;
  final String spotifyName;
  final String spotifyImage;

  CategoryModel({required this.spotifyId, required this.spotifyName, required this.spotifyImage});

  static CategoryModel fromJsonData(Map<String,dynamic> data){
    return CategoryModel(
      spotifyId: data['id'], 
      spotifyName: data['name'], 
      spotifyImage: data['icons'][0]['url']
    );
  }

}