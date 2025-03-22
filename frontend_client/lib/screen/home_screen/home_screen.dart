import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../bloc/category_bloc/category_bloc.dart';
import '../../bloc/product_bloc/product_bloc.dart';
import '../../service/ui_helper.dart';
import '../../widget/category_button/category_button.dart';
import '../../widget/category_grid/category_grid.dart';
import '../../widget/custom_appbar/custom_appbar.dart';
import '../../widget/product_card/product_card.dart';
import '../../widget/product_list/product_list.dart';
import '../category/category_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _categoryGrid() {
    return BlocConsumer<CategoryBloc, CategoryState>(
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
          return const SliverToBoxAdapter(child: CircularProgressIndicator());
        }
        if (state is CategoryLoaded) {
          return CategoryGrid(
            builder: (context, index) {
              return CategoryButton(
                title: state[index].name!,
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return CategoryScreen(
                          id: state[index].id!,
                          name: state[index].name!,
                        );
                      },
                    ),
                  );
                },
                icon: const Icon(Symbols.abc),
              );
            },
            size: state.size,
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _productWrap() {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) async {
        if (state is ProductLoadError) {
          await UIHelper.showErrorDialog(
            context: context,
            message: state.message,
          );
        }
      },
      builder: (context, state) {
        if (state is ProductLoading) {
          return const SliverToBoxAdapter(child: CircularProgressIndicator());
        }
        if (state is ProductLoaded) {
          return ProductList(
            builder: (context, index) {
              return ProductCard(product: state[index]);
            },
            size: state.size,
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomAppbar(title: Text('Shop bán hàng')),
          _categoryGrid(),
          _productWrap(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Symbols.home),
            selectedIcon: Icon(Symbols.home_filled),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Symbols.search),
            selectedIcon: Icon(Symbols.search_activity),
            label: 'Tìm kiếm',
          ),
          NavigationDestination(
            icon: Icon(Symbols.settings),
            selectedIcon: Icon(Symbols.settings_sharp),
            label: 'Cài đặt',
          ),
        ],
        onDestinationSelected: (value) {},
      ),
    );
  }
}
