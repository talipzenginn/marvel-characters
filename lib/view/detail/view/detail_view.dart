import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/components/not_found_widget.dart';
import '../../../core/components/shimmers.dart';
import './/view/home/model/character_model.dart';
import '../../../../core/extension/context_extensions.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../core/components/custom_future_builder.dart';
import '../viewmodel/detail_viewmodel.dart';

class DetailView extends StatefulWidget {
  const DetailView({Key? key, required this.characterModel}) : super(key: key);
  final CharacterModel characterModel;

  @override
  DetailViewState createState() => DetailViewState();
}

class DetailViewState extends State<DetailView> {
  late DetailViewmodel viewModel;
  @override
  void initState() {
    super.initState();
    viewModel = DetailViewmodel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: Padding(
          padding: context.paddingLowVertical,
          child: SingleChildScrollView(
            child: Center(
              child: CustomFutureBuilder(
                future: viewModel.getResponse(widget.characterModel),
                loading: const ShimmerForAll(),
                notFoundWidget: NotFoundWidget(
                  onPressed: viewModel.tryAgain,
                ),
                onSuccess: (data) {
                  dynamic response = data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      photoOfCharacter(response),
                      nameOfCharacter(response),
                      detailOfCharacter(response),
                      comicsOfTheCharacter(response),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox photoOfCharacter(response) {
    return SizedBox(
      height: context.highValue * 3,
      child: CachedNetworkImage(
        imageUrl: widget.characterModel.photoURL!,
        placeholder: (context, url) => const ImageShimmer(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  Text nameOfCharacter(response) {
    return Text(
      widget.characterModel.name ?? AppConstants.emptyText,
      style: context.textTheme.headline5,
    );
  }

  Widget detailOfCharacter(response) {
    return Padding(
      padding: context.paddingNormal,
      child: Text(
        widget.characterModel.description!.isNotEmpty
            ? widget.characterModel.description!
            : AppConstants.noDetail,
        style: context.textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget comicsOfTheCharacter(List response) {
    List<Widget> widgets = response.isNotEmpty
        ? response
            .map(
              (e) => Padding(
                padding: context.paddingNormal,
                child: Text(
                  '${e.title} ----- ${e.onsaleDate.day}.${e.onsaleDate.month}.${e.onsaleDate.year}',
                  style: context.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            )
            .toList()
        : [const Text(AppConstants.noComics)];
    return Column(
      children: widgets,
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: false,
      title: const Text(AppConstants.appBarTitle),
    );
  }
}
