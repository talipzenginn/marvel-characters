import 'package:flutter/cupertino.dart';
import 'package:marvel_characters/view/home/model/character_model.dart';
import '../../../../core/init/network/network_manager.dart';
import '../../../core/init/navigation/router.gr.dart';
import '../../../main.dart';
import '../model/response_model.dart';

class HomeViewmodel extends ChangeNotifier {
  HomeViewmodel({this.offset = 0, this.countOfCharacters = 1000});

  List<CharacterModel> characterList = [];

  int offset;
  int countOfCharacters;
  Future<List> getCharacterList(offsetNumber) async {
    CharacterResponseModel response;
    try {
      response = await NetworkManager.instance!.get(
        'characters?ts=1653404188&apikey=13c8b0b85196e641d2f5148494f69e63&hash=c2d6e264a316e170aa1b2a5244eb88b8&offset=$offsetNumber&limit=30',
        CharacterResponseModel.fromJson,
      );
      print(offset);
      countOfCharacters = response.count!;
      print(countOfCharacters);
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

  nextPage(countOfCharacters) {
    offset < countOfCharacters - 30 ? offset += 30 : offset;
    notifyListeners();
  }

  previousPage() {
    offset >= 30 ? offset -= 30 : offset;
    notifyListeners();
  }

  tryAgain() {
    router.replace(
      const SplashRoute(),
    );
  }
}
