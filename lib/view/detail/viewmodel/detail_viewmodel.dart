import '../../../view/home/model/character_model.dart';
import '../../../../core/init/network/network_manager.dart';
import '../../../core/init/navigation/router.gr.dart';
import '../../../main.dart';
import '../../home/model/comic_model.dart';
import '../../home/model/response_model.dart';

class DetailViewmodel {
  List<ComicModel> comicList = [];

  Future getResponse(CharacterModel characterModel) async {
    ComicResponseModel comicResponse;
    try {
      comicResponse = await NetworkManager.instance!.get(
        'http://gateway.marvel.com/v1/public/characters/${characterModel.id}/comics?ts=1653404188&apikey=13c8b0b85196e641d2f5148494f69e63&hash=c2d6e264a316e170aa1b2a5244eb88b8&modifiedSince=Sat, 1 Jan 2005 00:00:00 GMT&limit=10&orderBy=-onsaleDate',
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
