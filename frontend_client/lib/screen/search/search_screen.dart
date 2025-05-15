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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Search Header
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tìm kiếm', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm sản phẩm...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: theme.colorScheme.primary),
                          ),
                          prefixIcon: Icon(Symbols.search, color: theme.colorScheme.primary),
                          suffixIcon:
                              _searchController.text.isNotEmpty
                                  ? IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      context.read<ProductSearchBloc>().add(const ProductTypedEvent(query: ''));
                                    },
                                    icon: const Icon(Symbols.close),
                                    color: Colors.grey[400],
                                  )
                                  : null,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Search Results
            BlocBuilder<ProductSearchBloc, ProductSearchState>(
              builder: (context, state) {
                if (state is ProductSearchLoading) {
                  return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                } else if (state is ProductSearchLoaded) {
                  if (state.products.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Symbols.search_off, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Không tìm thấy sản phẩm nào',
                              style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: ProductList(
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
                  );
                } else if (state is ProductSearchError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Symbols.error_outline, size: 64, color: Colors.red[300]),
                          const SizedBox(height: 16),
                          Text(
                            'Lỗi: ${state.message}',
                            style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Symbols.search, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'Nhập từ khóa để tìm kiếm sản phẩm',
                            style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
