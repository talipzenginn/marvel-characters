import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import '../../../view/detail/viewmodel/detail_viewmodel.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/secret_constants.dart';
import './/view/home/model/character_model.dart';
import '../../../../core/init/network/network_manager.dart';
import '../../../core/init/navigation/router.gr.dart';
import '../../../main.dart';
import '../model/response_model.dart';

class HomeViewmodel extends ChangeNotifier {
  int offset = -30;

  int countOfCharacters = 1000;

  int limit = 30;

  bool _isFetchingCharacters = false;

  bool _hasNext = true;

  bool get hasNext => _hasNext;

  final _characterMaps = [];

  List<CharacterModel> get characters => _characterMaps
      .map(
        (characterMap) => CharacterModel(
          id: characterMap['id'],
          name: characterMap['name'],
          description: characterMap['description'],
          photoURL: characterMap['thumbnail']['path'] +
              '/standard_xlarge.' +
              characterMap['thumbnail']['extension'],
        ),
      )
      .toList();

  Future fetchNextCharacters() async {
    if (_isFetchingCharacters) return;
    _isFetchingCharacters = true;

    int timeStamp = DateTime.now().millisecondsSinceEpoch;

    String input = timeStamp.toString() +
        SecretConstants.privateKey +
        AppConstants.publicKey;

    String hashCode = md5.convert(utf8.encode(input)).toString();

    CharacterResponseModel response;
    try {
      offset += 30;

      response = await NetworkManager.instance!.get(
        'characters?ts=$timeStamp&apikey=${AppConstants.publicKey}&hash=$hashCode&offset=$offset&limit=$limit',
        CharacterResponseModel.fromJson,
      );

      _characterMaps.addAll(response.characterMapsList!);
      countOfCharacters = response.count!;
      if (response.characterMapsList!.length < limit) _hasNext = false;
      notifyListeners();
    } catch (e) {
      notifyListeners();
      rethrow;
    }
    _isFetchingCharacters = false;
  }

  navigateToDetailView(CharacterModel character, DetailViewmodel viewmodel) {
    router.push(
      DetailRoute(characterModel: character, detailViewmodel: viewmodel),
    );
  }
}
