import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../bloc/category_search_bloc/category_search_bloc.dart';
import '../../widget/product_card/product_card.dart';
import '../../widget/product_list/product_list.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.id, required this.name});
  final int id;
  final String name;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('id', id));
    properties.add(StringProperty('name', name));
  }
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _sortCriteria = 'Mặc định';
  final List<String> _sortOptions = ['Mặc định', 'Giá: Thấp đến cao', 'Giá: Cao đến thấp', 'Tên: A-Z', 'Tên: Z-A'];

  RangeValues _priceRange = const RangeValues(0, 50000000);
  RangeValues _currentPriceRange = const RangeValues(0, 50000000);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategorySearchBloc>().add(CategorySearchByIdEvent(id: widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: BlocConsumer<CategorySearchBloc, CategorySearchState>(
          listener: (context, state) async {
            if (state is CategorySearchError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Symbols.error_outline, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Lỗi: ${state.message}')),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red[700],
                  duration: const Duration(seconds: 3),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                // Custom header with back button
                SliverAppBar(
                  pinned: true,
                  title: Text(widget.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  leading: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back, color: theme.colorScheme.primary, size: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () => _showFilterDialog(context),
                      icon: Icon(Icons.filter_list, color: theme.colorScheme.primary),
                      tooltip: 'Lọc sản phẩm',
                    ),
                    IconButton(
                      onPressed: () => _showSortOptions(context),
                      icon: Icon(Icons.sort, color: theme.colorScheme.primary),
                      tooltip: 'Sắp xếp',
                    ),
                  ],
                ),

                // Category banner
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: theme.colorScheme.primary.withValues(alpha: 0.9),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Opacity(
                              opacity: 0.2,
                              child: Image.network(
                                'https://img.freepik.com/free-vector/abstract-background_53876-43362.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const SizedBox(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.name,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (state is CategorySearchLoaded)
                                Text(
                                  '${state.products.length} sản phẩm',
                                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // State management for products
                if (state is CategorySearchLoading)
                  const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                else if (state is CategorySearchLoaded)
                  state.products.isEmpty
                      ? SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.category_outlined, size: 80, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              Text(
                                'Không có sản phẩm nào trong danh mục này',
                                style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                                child: const Text('Quay lại'),
                              ),
                            ],
                          ),
                        ),
                      )
                      : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: ProductList(
                          builder: (context, index) {
                            final sortedProducts = _sortProducts(state.products);
                            final filteredProducts = _filterProducts(sortedProducts);

                            return ProductCard(
                              imageUrl: filteredProducts[index].productLink!,
                              title: filteredProducts[index].model!,
                              price: filteredProducts[index].price!.toString(),
                              product: filteredProducts[index],
                            );
                          },
                          size: _getSortedAndFilteredProductsCount(state),
                        ),
                      )
                else
                  const SliverFillRemaining(child: Center(child: Text('Đang tải dữ liệu...'))),

                // Extra space at bottom
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text('Sắp xếp theo', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng')),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _sortOptions.length,
                  itemBuilder: (context, index) {
                    final option = _sortOptions[index];
                    return ListTile(
                      title: Text(option),
                      trailing:
                          _sortCriteria == option ? Icon(Icons.check_circle, color: theme.colorScheme.primary) : null,
                      onTap: () {
                        setState(() {
                          _sortCriteria = option;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Lọc sản phẩm', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Khoảng giá')),
                  RangeSlider(
                    values: _currentPriceRange,
                    max: 50000000,
                    divisions: 20,
                    labels: RangeLabels(
                      '${(_currentPriceRange.start / 1000000).toStringAsFixed(0)}tr',
                      '${(_currentPriceRange.end / 1000000).toStringAsFixed(0)}tr',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentPriceRange = values;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(_currentPriceRange.start / 1000000).toStringAsFixed(0)}tr VNĐ',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${(_currentPriceRange.end / 1000000).toStringAsFixed(0)}tr VNĐ',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentPriceRange = const RangeValues(0, 50000000);
                    });
                  },
                  child: const Text('Đặt lại'),
                ),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
                FilledButton(
                  onPressed: () {
                    this.setState(() {
                      _priceRange = _currentPriceRange;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Áp dụng'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<dynamic> _sortProducts(List<dynamic> products) {
    final List<dynamic> sortedProducts = List.from(products);

    switch (_sortCriteria) {
      case 'Giá: Thấp đến cao':
        sortedProducts.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
        break;
      case 'Giá: Cao đến thấp':
        sortedProducts.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
        break;
      case 'Tên: A-Z':
        sortedProducts.sort((a, b) => (a.model ?? '').compareTo(b.model ?? ''));
        break;
      case 'Tên: Z-A':
        sortedProducts.sort((a, b) => (b.model ?? '').compareTo(a.model ?? ''));
        break;
      default:
        // Default sorting, no change
        break;
    }

    return sortedProducts;
  }

  List<dynamic> _filterProducts(List<dynamic> products) {
    return products.where((product) {
      final price = product.price ?? 0;
      return price >= _priceRange.start && price <= _priceRange.end;
    }).toList();
  }

  int _getSortedAndFilteredProductsCount(CategorySearchLoaded state) {
    final sortedProducts = _sortProducts(state.products);
    final filteredProducts = _filterProducts(sortedProducts);
    return filteredProducts.length;
  }
}
