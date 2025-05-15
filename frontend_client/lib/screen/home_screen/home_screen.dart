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

  Future<void> _onPressed({required BuildContext context, required CategoryLoaded state, required int index}) async {
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
          await UIHelper.showErrorDialog(context: context, message: state.message);
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
                  return await _onPressed(context: context, state: state, index: index);
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

  Widget _productWrap() {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) async {
        if (state is ProductLoadError) {
          await UIHelper.showErrorDialog(context: context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is ProductLoading) {
          return const SliverToBoxAdapter(child: CircularProgressIndicator());
        }
        if (state is ProductLoaded) {
          return ProductList(
            builder: (context, index) {
              final product = state[index];
              return ProductCard(
                imageUrl: product.productLink!,
                title: product.model!,
                price: product.price!.toString(),
                product: product,
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomAppbar(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.phone_android_rounded, color: theme.colorScheme.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  'PhoneSale',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_none_rounded, color: theme.colorScheme.onSurface),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.shopping_bag_outlined, color: theme.colorScheme.onSurface)),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Danh mục', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Xem tất cả',
                        style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ]),
            ),
          ),

          SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 20), sliver: _categoryGrid()),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sản phẩm mới', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Xem tất cả',
                        style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ]),
            ),
          ),

          SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 20), sliver: _productWrap()),

          // Extra space at bottom for better scrolling experience
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
