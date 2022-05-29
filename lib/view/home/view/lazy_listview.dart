import 'package:flutter/material.dart';
import '../../../core/extension/context_extensions.dart';
import '../../../view/detail/viewmodel/detail_viewmodel.dart';
import '../../../view/home/viewmodel/home_viewmodel.dart';

class LazyListView extends StatefulWidget {
  final HomeViewmodel viewmodel;

  const LazyListView({required this.viewmodel, Key? key}) : super(key: key);
  @override
  State<LazyListView> createState() => _LazyListViewState();
}

class _LazyListViewState extends State<LazyListView> {
  late DetailViewmodel detailViewmodel;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    detailViewmodel = DetailViewmodel();
    scrollController.addListener(scrollListener);
    widget.viewmodel.fetchNextCharacters();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      if (widget.viewmodel.hasNext) {
        widget.viewmodel.fetchNextCharacters();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: context.paddingLowHorizontal,
      children: [
        ...widget.viewmodel.characters
            .map(
              (character) => GestureDetector(
                onTap: () => widget.viewmodel
                    .navigateToDetailView(character, detailViewmodel),
                child: ListTile(
                  title: Text(character.name!),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(character.photoURL!),
                  ),
                ),
              ),
            )
            .toList(),
        if (widget.viewmodel.hasNext)
          const Center(
            child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
