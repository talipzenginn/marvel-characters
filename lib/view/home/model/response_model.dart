import 'dart:collection';

class CharacterResponseModel {
  List? characterMapsList;
  int? count;

  CharacterResponseModel({this.characterMapsList, this.count});

  factory CharacterResponseModel.fromJson(Map<String, dynamic> json) {
    LinkedHashMap<dynamic, dynamic> map = json['data'];
    var hashMap = HashMap.from(map);
    var characterMapsList = hashMap['results'];
    return CharacterResponseModel(
      characterMapsList: characterMapsList,
      count: hashMap['total'],
    );
  }
}

class ComicResponseModel {
  List? comicsMapsList;
  ComicResponseModel({this.comicsMapsList});
  factory ComicResponseModel.fromJson(Map<String, dynamic> json) {
    LinkedHashMap<dynamic, dynamic> map = json['data'];
    var hashMap = HashMap.from(map);
    var comicsMapsList = hashMap['results'];
    return ComicResponseModel(
      comicsMapsList: comicsMapsList,
    );
  }
}
