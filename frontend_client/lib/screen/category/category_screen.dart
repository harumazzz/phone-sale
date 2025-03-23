import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/product_bloc/product_bloc.dart';
import '../../model/response/product_response.dart';
import '../../widget/custom_appbar/custom_appbar.dart';
import '../../widget/product_card/product_card.dart';
import '../../widget/product_list/product_list.dart';
import '../product_detail/product_detail_screen.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBloc>().add(ProductSearchByCategory(id: widget.id));
    });
  }

  Future<void> _onMove(ProductResponse product) async {
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
    return Scaffold(
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) async {
          if (state is ProductLoadError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lỗi: ${state.message}'),
                duration: const Duration(milliseconds: 400),
                shape: const OutlineInputBorder(),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            final products = state.products;
            if (products.isEmpty) {
              return const Center(
                child: Text('Không có sản phẩm trong danh mục này.'),
              );
            }
            return CustomScrollView(
              slivers: <Widget>[
                CustomAppbar(title: Text(widget.name)),
                ProductList(
                  builder: (context, index) {
                    return ProductCard(
                      product: products[index],
                      onPressed: () async {
                        return await _onMove(products[index]);
                      },
                    );
                  },
                  size: products.length,
                ),
              ],
            );
          } else {
            return const Center(child: Text('Đang tải dữ liệu...'));
          }
        },
      ),
    );
  }
}
