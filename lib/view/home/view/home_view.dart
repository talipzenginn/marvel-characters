import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view/home/view/lazy_listview.dart';
import '../../../../core/extension/context_extensions.dart';
import '../../../../core/constants/app_constants.dart';
import '../viewmodel/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: Padding(
          padding: context.paddingLowVertical,
          child: Column(
            children: [
              Expanded(
                child: Consumer<HomeViewmodel>(
                  builder: (context, viewModel, child) {
                    return LazyListView(
                      viewmodel: viewModel,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
