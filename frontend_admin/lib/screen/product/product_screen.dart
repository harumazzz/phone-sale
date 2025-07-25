import 'dart:typed_data';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_admin/bloc/category/category_bloc.dart';
import 'package:frontend_admin/bloc/product/product_bloc.dart';
import 'package:frontend_admin/model/request/product_request.dart';
import 'package:frontend_admin/repository/upload_repository.dart';
import 'package:frontend_admin/service/service_locator.dart';
import 'package:frontend_admin/service/ui_helper.dart';
import 'package:frontend_admin/utils/currency_utils.dart';
import 'package:frontend_admin/widget/image_picker_widget.dart';
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

  int _selectedCategoryId = 1;
  String? _imageUrl;
  Uint8List? _selectedImageBytes;
  String? _selectedImageFileName;

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
                    await _handleProductSubmission(isEditing: false);
                    if (context.mounted) {
                      Navigator.pop(context);
                      await UIHelper.showInfoSnackbar(context: context, message: 'Thêm sản phẩm thành công!');
                    }
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
    _imageUrl = imageUrl;

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
                    await _handleProductSubmission(isEditing: true, productId: id);
                    if (context.mounted) {
                      Navigator.pop(context);
                      await UIHelper.showSuccessSnackbar(context: context, message: 'Cập nhật sản phẩm thành công!');
                    }
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
    _selectedCategoryId = 1;
    _imageUrl = null;
    _selectedImageBytes = null;
    _selectedImageFileName = null;
  }

  bool _validateForm() {
    return _modelController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _stockController.text.isNotEmpty;
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
            const SizedBox(height: 16),
            ImagePickerWidget(
              initialImageUrl: _imageUrl,
              onImageSelected: _onImageSelected,
              onImageCleared: _onImageCleared,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleProductSubmission({required bool isEditing, int? productId}) async {
    try {
      String? imageUrl = _imageUrl;

      // Upload image if a new one is selected
      if (_selectedImageBytes != null && _selectedImageFileName != null) {
        final uploadRepository = ServiceLocator.get<UploadRepository>();
        imageUrl = await uploadRepository.uploadImage(
          fileBytes: _selectedImageBytes!,
          fileName: _selectedImageFileName!,
        );
      }

      final request = ProductRequest(
        model: _modelController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        stock: int.tryParse(_stockController.text) ?? 0,
        categoryId: _selectedCategoryId,
        productLink: imageUrl,
      );

      if (isEditing && productId != null && context.mounted) {
        context.read<ProductBloc>().add(EditProductEvent(id: productId, request: request));
      } else {
        if (context.mounted) {
          context.read<ProductBloc>().add(AddProductEvent(request: request));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red));
      }
    }
  }

  void _onImageSelected(Uint8List imageBytes, String fileName) {
    setState(() {
      _selectedImageBytes = imageBytes;
      _selectedImageFileName = fileName;
      _imageUrl = null; // Clear existing URL when new image is selected
    });
  }

  void _onImageCleared() {
    setState(() {
      _selectedImageBytes = null;
      _selectedImageFileName = null;
      _imageUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Symbols.shopping_bag, color: theme.colorScheme.primary, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quản lý sản phẩm',
                            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Xem và quản lý tất cả sản phẩm trong cửa hàng',
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, spreadRadius: 1),
                          ],
                        ),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: DataTable2(
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            minWidth: 600,
                            headingRowColor: WidgetStateProperty.resolveWith<Color>((states) => Colors.grey.shade100),
                            dataRowHeight: 60,
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
                                  DataCell(Text(CurrencyUtils.formatVnd(product.price ?? 0))),
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
                      ),
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
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
