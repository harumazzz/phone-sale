import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../bloc/category_bloc/category_bloc.dart';
import '../../service/ui_helper.dart';
import '../../widget/category_button/category_button.dart';
import '../../widget/category_grid/category_grid.dart';
import '../../widget/custom_appbar/custom_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomAppbar(title: Text('Shop bán hàng')),
          BlocConsumer<CategoryBloc, CategoryState>(
            listener: (context, state) async {
              if (state is CategoryError) {
                await UIHelper.showErrorDialog(
                  context: context,
                  message: state.message,
                );
              }
            },
            builder: (context, state) {
              if (state is CategoryLoading) {
                return const SliverToBoxAdapter(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (state is CategoryLoaded) {
                return CategoryGrid(
                  builder: (context, index) {
                    return CategoryButton(
                      title: state[index].name!,
                      onTap: () {},
                      icon: const Icon(Symbols.abc),
                    );
                  },
                  size: state.size,
                );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }
}
