import 'package:marvel_characters/view/home/model/character_model.dart';
import '../../../../core/init/network/network_manager.dart';
import '../../../core/init/navigation/router.gr.dart';
import '../../../main.dart';
import '../model/response_model.dart';

class HomeViewmodel {
  List<CharacterModel> characterList = [];

  int offset = 120;
  int countOfCharacters = 0;
  Future<List> getCharacterList() async {
    CharacterResponseModel response;
    try {
      response = await NetworkManager.instance!.get(
        'characters?ts=1653404188&apikey=13c8b0b85196e641d2f5148494f69e63&hash=c2d6e264a316e170aa1b2a5244eb88b8&offset=$offset&limit=30',
        CharacterResponseModel.fromJson,
      );
      print(offset);
      response.count = countOfCharacters;
      characterList.clear();
      for (int i = 0; i < response.characterMapsList!.length; i++) {
        var characterMap = response.characterMapsList![i];

        characterList.add(
          CharacterModel(
            id: characterMap['id'],
            name: characterMap['name'],
            description: characterMap['description'],
            photoURL: characterMap['thumbnail']['path'] +
                '/standard_xlarge.' +
                characterMap['thumbnail']['extension'],
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
    return characterList;
  }

  nextPage() {
    offset += 30;
  }

  previousPage() {
    offset -= 30;
  }

  tryAgain() {
    router.replace(
      const SplashRoute(),
    );
  }
}
