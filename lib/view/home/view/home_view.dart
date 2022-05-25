import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../core/init/navigation/router.gr.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/extension/context_extensions.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../core/components/button_style.dart';
import '../../../core/components/custom_future_builder.dart';
import '../../../main.dart';
import '../viewmodel/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  late HomeViewmodel viewModel;
  @override
  void initState() {
    super.initState();
    viewModel = HomeViewmodel();
  }

  Widget buildGridView(List characterList) {
    List<Widget> widgets = characterList
        .map(
          (e) => Padding(
            padding: const EdgeInsets.all(1),
            child: GestureDetector(
              onTap: () {
                router.push(
                  DetailRoute(characterModel: e),
                );
              },
              child: Column(
                children: [
                  Expanded(flex: 5, child: patchOfCharacter(e)),
                  Expanded(flex: 1, child: nameOfCharacter(e)),
                ],
              ),
            ),
          ),
        )
        .toList();
    return GridView.count(
      scrollDirection: Axis.vertical,
      crossAxisCount: 2,
      shrinkWrap: false,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: Padding(
          padding: context.paddingLowVertical,
          child: CustomFutureBuilder(
            future: viewModel.getCharacterList(),
            loading: shimmerForAll(),
            notFoundWidget: notFoundWidget(),
            onSuccess: (data) {
              dynamic response = data;
              return Column(
                children: [
                  Expanded(
                    child: buildGridView(response),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      previousPageButton(),
                      nextPageButton(),
                    ],
                  ),
                ],
              );
            },
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

  Widget nextPageButton() {
    return Padding(
      padding: context.paddingLow,
      child: TextButton(
           onPressed: () {
          viewModel.nextPage();
          setState(() {});
        },
        style: buttonStyle(context),
        child: Padding(
          padding: context.paddingLow,
          child: Text(
            AppConstants.nextPageButtonText,
            style: context.textTheme.button,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget previousPageButton() {
    return Padding(
      padding: context.paddingLow,
      child: FloatingActionButton(
        onPressed: () {
          viewModel.previousPage();
          setState(() {});
        },
        child: Padding(
          padding: context.paddingLow,
          child: Text(
            AppConstants.previousPageButtonText,
            style: context.textTheme.button,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget tryAgainButton() {
    return Padding(
      padding: context.paddingLow,
      child: FloatingActionButton(
        onPressed: viewModel.tryAgain,
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

  SizedBox patchOfCharacter(response) {
    return SizedBox(
      height: context.highValue * 3,
      child: CachedNetworkImage(
        imageUrl: response.photoURL,
        placeholder: (context, url) => imageShimmer(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  Widget nameOfCharacter(response) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        response.name ?? AppConstants.emptyText,
        style: context.textTheme.subtitle1,
      ),
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
      automaticallyImplyLeading: false,
      title: const Text(AppConstants.appBarTitle),
    );
  }
}
