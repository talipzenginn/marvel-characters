import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import './/./core/constants/enums/page_button_enum.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/secret_constants.dart';
import './/view/home/model/character_model.dart';
import '../../../../core/init/network/network_manager.dart';
import '../../../core/init/navigation/router.gr.dart';
import '../../../main.dart';
import '../model/response_model.dart';

class HomeViewmodel extends ChangeNotifier {
  HomeViewmodel({this.offset = 0, this.countOfCharacters = 1000});

  List<CharacterModel> characterList = [];

  int offset;

  int countOfCharacters;

  int limit = 30;

  Future<List> getCharacterList(offsetNumber) async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    String input = timeStamp.toString() +
        SecretConstants.privateKey +
        AppConstants.publicKey;

    String hashCode = md5.convert(utf8.encode(input)).toString();

    CharacterResponseModel response;

    try {
      response = await NetworkManager.instance!.get(
        'characters?ts=$timeStamp&apikey=${AppConstants.publicKey}&hash=$hashCode&offset=$offsetNumber&limit=$limit',
        CharacterResponseModel.fromJson,
      );

      countOfCharacters = response.count!;

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

  changeThePage(int countOfCharacters, PageButtonEnum pageButtonEnum) {
    if (pageButtonEnum == PageButtonEnum.previous) {
      offset >= 30 ? offset -= 30 : offset;
    } else if (pageButtonEnum == PageButtonEnum.next) {
      offset < countOfCharacters - 30 ? offset += 30 : offset;
    }
    notifyListeners();
  }

  tryAgain() {
    router.replace(
      const SplashRoute(),
    );
  }
}
