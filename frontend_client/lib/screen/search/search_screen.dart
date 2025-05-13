import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../bloc/product_search_bloc/product_search_bloc.dart';
import '../../widget/product_card/product_card.dart';
import '../../widget/product_list/product_list.dart';
import 'debounce.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  late Debounce _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _debounce = Debounce(milliseconds: 500);
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = BlocProvider.of<ProductSearchBloc>(context).state;
      if (state is ProductSearchLoaded) {
        _searchController.text = state.query;
      }
      if (_searchController.text.isNotEmpty) {
        BlocProvider.of<ProductSearchBloc>(context).add(ProductTypedEvent(query: _searchController.text));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce.run(() {
      final query = _searchController.text;
      if (query.isNotEmpty) {
        context.read<ProductSearchBloc>().add(ProductTypedEvent(query: query));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm sản phẩm...',
            border: InputBorder.none,
            prefixIcon: Icon(Symbols.search),
          ),
        ),
      ),
      body: BlocBuilder<ProductSearchBloc, ProductSearchState>(
        builder: (context, state) {
          if (state is ProductSearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductSearchLoaded) {
            return CustomScrollView(
              slivers: [
                ProductList(
                  builder: (context, index) {
                    return ProductCard(
                      imageUrl: state.products[index].productLink!,
                      title: state.products[index].model!,
                      price: state.products[index].price!.toString(),
                      product: state.products[index],
                    );
                  },
                  size: state.products.length,
                ),
              ],
            );
          } else if (state is ProductSearchError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          } else {
            return const Center(child: Text('Nhập từ khóa để tìm kiếm sản phẩm'));
          }
        },
      ),
    );
  }
}
