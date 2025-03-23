import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/category_bloc/category_bloc.dart';
import '../../bloc/product_bloc/product_bloc.dart';
import '../../service/convert_helper.dart';
import '../../service/ui_helper.dart';
import '../../widget/category_button/category_button.dart';
import '../../widget/category_grid/category_grid.dart';
import '../../widget/custom_appbar/custom_appbar.dart';
import '../../widget/product_card/product_card.dart';
import '../../widget/product_list/product_list.dart';
import '../category/category_screen.dart';
import '../product_detail/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBloc>().add(const ProductFetch());
      context.read<CategoryBloc>().add(const LoadCategoryEvent());
    });
  }

  Future<void> _onPressed({
    required BuildContext context,
    required CategoryLoaded state,
    required int index,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return CategoryScreen(id: state[index].id!, name: state[index].name!);
        },
      ),
    );
  }

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
                  return await _onPressed(
                    context: context,
                    state: state,
                    index: index,
                  );
                },
                icon: ConvertHelper.exchangeSymbols(state[index].name!),
              );
            },
            size: state.size,
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Future<void> _onMove(ProductLoaded state, int index) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ProductDetailScreen(product: state[index]);
        },
      ),
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
              return ProductCard(
                product: state[index],
                onPressed: () async => await _onMove(state, index),
              );
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
    return CustomScrollView(
      slivers: [
        const CustomAppbar(title: Text('Shop bán hàng')),
        _categoryGrid(),
        _productWrap(),
      ],
    );
  }
}
