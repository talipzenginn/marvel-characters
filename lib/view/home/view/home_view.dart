import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import './/./core/constants/enums/page_button_enum.dart';
import 'package:provider/provider.dart';
import '../../../core/components/button_related/button_style.dart';
import '../../../core/components/not_found_widget.dart';
import '../../../core/components/shimmers.dart';
import '../../../core/init/navigation/router.gr.dart';
import '../../../../core/extension/context_extensions.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../core/components/custom_future_builder.dart';
import '../../../main.dart';
import '../viewmodel/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewmodel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (viewModel.offset != 0)
                pageButton(
                  context,
                  viewModel,
                  PageButtonEnum.previous,
                  AppConstants.previousPageButtonText,
                ),
              const SizedBox(
                width: 20,
              ),
              if (viewModel.countOfCharacters - 30 >= viewModel.offset)
                pageButton(
                  context,
                  viewModel,
                  PageButtonEnum.next,
                  AppConstants.nextPageButtonText,
                )
            ],
          ),
          appBar: appBar(),
          body: SafeArea(
            child: Padding(
              padding: context.paddingLowVertical,
              child: CustomFutureBuilder(
                future: viewModel.getCharacterList(viewModel.offset),
                loading: const ShimmerForAll(),
                notFoundWidget: NotFoundWidget(onPressed: viewModel.tryAgain),
                onSuccess: (data) {
                  dynamic response = data;
                  return Column(
                    children: [
                      Expanded(
                        child: buildGridView(
                          response,
                          viewModel,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  TextButton pageButton(
    BuildContext context,
    HomeViewmodel viewModel,
    PageButtonEnum pageButtonEnum,
    String buttonTitle,
  ) {
    return TextButton(
      style: buttonStyle(context),
      onPressed: () {
        viewModel.changeThePage(viewModel.countOfCharacters, pageButtonEnum);
      },
      child: Padding(
        padding: context.paddingLow,
        child: Text(
          buttonTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget buildGridView(List characterList, viewModel) {
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

  SizedBox patchOfCharacter(response) {
    return SizedBox(
      height: context.highValue * 3,
      child: CachedNetworkImage(
        imageUrl: response.photoURL,
        placeholder: (context, url) => const ImageShimmer(),
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

  AppBar appBar() {
    return AppBar(
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: const Text(AppConstants.appBarTitle),
    );
  }
}
