import 'dart:collection';

class ResponseModel {
  List? characterMapsList;

  ResponseModel({this.characterMapsList});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    LinkedHashMap<dynamic, dynamic> map = json['data'];
    var hashMap = HashMap.from(map);
    var characterMapsList = hashMap['results'];
    return ResponseModel(
      characterMapsList: characterMapsList,
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
