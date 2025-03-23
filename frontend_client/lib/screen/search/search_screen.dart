import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../bloc/product_search_bloc/product_search_bloc.dart';
import '../../model/response/product_response.dart';
import '../../widget/product_card/product_card.dart';
import '../../widget/product_list/product_list.dart';
import '../product_detail/product_detail_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm sản phẩm'),
        actions: [
          IconButton(
            icon: const Icon(Symbols.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: ProductSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: const SearchBody(),
    );
  }
}

class SearchBody extends StatelessWidget {
  const SearchBody({super.key});

  Future<void> _onMove(BuildContext context, ProductResponse product) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ProductDetailScreen(product: product);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductSearchBloc, ProductSearchState>(
      builder: (context, state) {
        if (state is ProductSearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductSearchLoaded) {
          return CustomScrollView(
            slivers: [
              ProductList(
                builder: (context, index) {
                  return ProductCard(
                    product: state[index],
                    onPressed: () async {
                      return await _onMove(context, state[index]);
                    },
                  );
                },
                size: state.size,
              ),
            ],
          );
        } else if (state is ProductSearchError) {
          return Center(child: Text('Lỗi: ${state.message}'));
        } else {
          return const Center(child: Text('Hãy bắt đầu tìm kiếm!'));
        }
      },
    );
  }
}

class ProductSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Nhập từ khóa tìm kiếm...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  Future<void> _onMove(BuildContext context, ProductResponse product) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ProductDetailScreen(product: product);
        },
      ),
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    BlocProvider.of<ProductSearchBloc>(
      context,
    ).add(ProductTypedEvent(query: query));
    return BlocBuilder<ProductSearchBloc, ProductSearchState>(
      builder: (context, state) {
        if (state is ProductSearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductSearchLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: state.products[index],
                  onPressed: () async {
                    return await _onMove(context, state[index]);
                  },
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.8,
              ),
            ),
          );
        } else if (state is ProductSearchError) {
          return Center(child: Text('Lỗi: ${state.message}'));
        } else {
          return const Center(child: Text('Không có kết quả'));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<ProductSearchBloc, ProductSearchState>(
      builder: (context, state) {
        if (state is ProductSearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductSearchLoaded) {
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(state.products[index].model!));
            },
          );
        } else {
          return const Center(child: Text('Không có gợi ý'));
        }
      },
    );
  }
}
