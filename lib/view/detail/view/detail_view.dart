import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marvel_characters/view/home/model/character_model.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/extension/context_extensions.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../core/components/button_style.dart';
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
                loading: shimmerForAll(),
                notFoundWidget: notFoundWidget(),
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

  Column notFoundWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: context.highValue * 3.3,
        ),
        Text(
          AppConstants.emptyText,
          style: context.textTheme.subtitle1,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: context.lowValue,
        ),
        tryAgainButton(),
      ],
    );
  }

  Widget tryAgainButton() {
    return Padding(
      padding: context.paddingLow,
      child: TextButton(
        onPressed: viewModel.tryAgain,
        style: buttonStyle(context),
        child: Padding(
          padding: context.paddingLow,
          child: Text(
            AppConstants.tryAgainButtonText,
            style: context.textTheme.button,
            textAlign: TextAlign.center,
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
        placeholder: (context, url) => imageShimmer(),
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
                  e.title ?? AppConstants.noComics,
                  style: context.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            )
            .toList()
        : [];
    return Column(
      children: widgets,
    );
  }

  Shimmer shimmerForAll() {
    return Shimmer.fromColors(
      baseColor: context.colorScheme.background,
      highlightColor: context.colorScheme.tertiary,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            width: context.highValue * 3,
            height: context.highValue * 3,
          ),
          Container(
              margin: EdgeInsets.only(top: context.normalValue),
              color: Colors.transparent,
              width: context.highValue * 4,
              height: context.mediumValue),
        ],
      ),
    );
  }

  Shimmer imageShimmer() {
    return Shimmer.fromColors(
      baseColor: context.colorScheme.background,
      highlightColor: context.colorScheme.tertiary,
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.tertiary,
          borderRadius: BorderRadius.circular(10),
        ),
        width: context.highValue * 3,
        height: context.highValue * 3,
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      centerTitle: false,
      title: const Text(AppConstants.appBarTitle),
    );
  }
}
