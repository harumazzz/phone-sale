import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_admin/bloc/category/category_bloc.dart';
import 'package:frontend_admin/bloc/product/product_bloc.dart';
import 'package:frontend_admin/model/request/product_request.dart';
import 'package:frontend_admin/service/ui_helper.dart';
import 'package:material_symbols_icons/symbols.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  int _selectedCategoryId = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBloc>().add(const LoadProductEvent());
      context.read<CategoryBloc>().add(const LoadCategoryEvent());
    });
  }

  @override
  void dispose() {
    _modelController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _showAddProductDialog(BuildContext context) async {
    _clearControllers();
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Symbols.add_circle_outline, color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Text(
                  'Thêm sản phẩm',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: _buildProductForm(context),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_validateForm()) {
                    final request = _buildProductRequest();
                    context.read<ProductBloc>().add(AddProductEvent(request: request));
                    Navigator.pop(context);
                    await UIHelper.showInfoSnackbar(context: context, message: 'Thêm sản phẩm thành công!');
                  }
                },
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }

  Future<void> _showEditProductDialog(
    BuildContext context,
    int id,
    String model,
    String description,
    double price,
    int stock,
    int categoryId,
    String? imageUrl,
  ) async {
    _modelController.text = model;
    _descriptionController.text = description;
    _priceController.text = price.toString();
    _stockController.text = stock.toString();
    _selectedCategoryId = categoryId;
    _imageUrlController.text = imageUrl ?? '';

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Symbols.edit_square, color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Text(
                  'Sửa sản phẩm',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: _buildProductForm(context),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_validateForm()) {
                    final request = _buildProductRequest();
                    context.read<ProductBloc>().add(EditProductEvent(id: id, request: request));
                    Navigator.pop(context);
                    await UIHelper.showSuccessSnackbar(context: context, message: 'Cập nhật sản phẩm thành công!');
                  }
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, int id) async {
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Symbols.delete_forever, color: Colors.red),
                ),
                const SizedBox(width: 12),
                Text(
                  'Xác nhận xóa',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bạn có chắc chắn muốn xóa sản phẩm này không?'),
                const SizedBox(height: 16),
                const Text(
                  'Hành động này không thể hoàn tác và sẽ xóa vĩnh viễn dữ liệu.',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  context.read<ProductBloc>().add(DeleteProductEvent(id: id));
                  Navigator.pop(context);
                  await UIHelper.showSuccessSnackbar(context: context, message: 'Xóa sản phẩm thành công!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }

  void _clearControllers() {
    _modelController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _stockController.clear();
    _imageUrlController.clear();
    _selectedCategoryId = 1;
  }

  bool _validateForm() {
    return _modelController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _stockController.text.isNotEmpty;
  }

  ProductRequest _buildProductRequest() {
    return ProductRequest(
      model: _modelController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? 0,
      stock: int.tryParse(_stockController.text) ?? 0,
      categoryId: _selectedCategoryId,
      productLink: _imageUrlController.text.isEmpty ? null : _imageUrlController.text,
    );
  }

  Widget _buildProductForm(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(labelText: 'Tên mẫu', hintText: 'Nhập tên mẫu sản phẩm'),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Mô tả', hintText: 'Nhập mô tả sản phẩm'),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Giá', hintText: 'Nhập giá sản phẩm'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _stockController,
              decoration: const InputDecoration(labelText: 'Tồn kho', hintText: 'Nhập số lượng tồn kho'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'URL hình ảnh', hintText: 'Nhập URL hình ảnh sản phẩm'),
            ),
            const SizedBox(height: 16),
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoaded) {
                  return DropdownButtonFormField<int>(
                    decoration: const InputDecoration(labelText: 'Danh mục'),
                    value: _selectedCategoryId,
                    items:
                        state.categories.map((category) {
                          return DropdownMenuItem<int>(value: category.id, child: Text(category.name ?? 'Unknown'));
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value!;
                      });
                    },
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProductError) {
              return Center(child: Text('Lỗi: ${state.message}'));
            }
            if (state is ProductLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quản lý sản phẩm', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Expanded(
                    child: DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 600,
                      columns: const [
                        DataColumn2(label: Text('Mã SP')),
                        DataColumn(label: Text('Tên mẫu')),
                        DataColumn(label: Text('Giá')),
                        DataColumn(label: Text('Tồn kho')),
                        DataColumn(label: Text('Mã DM')),
                        DataColumn(label: Text('Thao tác')),
                      ],
                      rows: List<DataRow>.generate(state.products.length, (index) {
                        final product = state.products[index];
                        return DataRow(
                          cells: [
                            DataCell(Text(product.productId.toString())),
                            DataCell(Text(product.model ?? '')),
                            DataCell(Text('${product.price ?? 0} VND')),
                            DataCell(Text(product.stock.toString())),
                            DataCell(Text(product.categoryId.toString())),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Symbols.edit),
                                    tooltip: 'Sửa',
                                    onPressed:
                                        () => _showEditProductDialog(
                                          context,
                                          product.productId!,
                                          product.model ?? '',
                                          product.description ?? '',
                                          product.price ?? 0,
                                          product.stock ?? 0,
                                          product.categoryId ?? 1,
                                          product.productLink,
                                        ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Symbols.delete, color: Colors.red),
                                    tooltip: 'Xóa',
                                    onPressed: () => _showDeleteConfirmationDialog(context, product.productId!),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async => await _showAddProductDialog(context),
        label: const Text('Thêm sản phẩm'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
