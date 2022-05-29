import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/secret_constants.dart';
import '../../../view/home/model/character_model.dart';
import '../../../../core/init/network/network_manager.dart';
import '../../home/model/comic_model.dart';
import '../../home/model/response_model.dart';

class DetailViewmodel {
  final _comicsMaps = [];

  bool _isFetchingComics = false;

  int limit = 10;

  String orderByParameter = '-onsaleDate';
  List<ComicModel?> _comics = [];
  List<ComicModel?> get comics => _comics;

  Future fetchComics(CharacterModel characterModel) async {
    if (_isFetchingComics) return;
    _isFetchingComics = true;

    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    String input = timeStamp.toString() +
        SecretConstants.privateKey +
        AppConstants.publicKey;

    String hashCode = md5.convert(utf8.encode(input)).toString();

    ComicResponseModel comicResponse;
    try {
      comicResponse = await NetworkManager.instance!.get(
        'characters/${characterModel.id}/comics?ts=$timeStamp&apikey=${AppConstants.publicKey}&hash=$hashCode&limit=$limit&orderBy=$orderByParameter',
        ComicResponseModel.fromJson,
      );
      _comicsMaps.clear();

      _comicsMaps.addAll(comicResponse.comicsMapsList!);
      _comics = _comicsMaps.map(
        (comicsMap) {
          DateTime dateTime = DateTime.parse(comicsMap['dates'][0]['date']);

          if (dateTime.isAfter(DateTime(2005))) {
            return ComicModel(
              title: comicsMap['title']??'No title',
              onsaleDate: dateTime,
            );
          } else {
            return null;
          }
        },
      ).toList();
    } catch (e) {
      rethrow;
    }
    _isFetchingComics = false;
    return _comics;
  }
}
