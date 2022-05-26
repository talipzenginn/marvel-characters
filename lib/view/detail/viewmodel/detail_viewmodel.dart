import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/secret_constants.dart';
import '../../../view/home/model/character_model.dart';
import '../../../../core/init/network/network_manager.dart';
import '../../../core/init/navigation/router.gr.dart';
import '../../../main.dart';
import '../../home/model/comic_model.dart';
import '../../home/model/response_model.dart';

class DetailViewmodel {
  List<ComicModel> comicList = [];

  int limit = 10;

  String orderByParameter = '-onsaleDate';

  Future getResponse(CharacterModel characterModel) async {
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

      comicList.clear();
      for (int i = 0; i < comicResponse.comicsMapsList!.length; i++) {
        var comicsMap = comicResponse.comicsMapsList![i];
        DateTime dateTime = DateTime.parse(comicsMap['dates'][0]['date']);

        if (dateTime.isAfter(DateTime(2005))) {
          comicList.add(
            ComicModel(
              title: comicsMap['title'],
              onsaleDate: dateTime,
            ),
          );
        }
      }
    } catch (e) {
      rethrow;
    }
    return comicList;
  }

  tryAgain() {
    router.replace(
      const SplashRoute(),
    );
  }
}
