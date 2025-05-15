import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_admin/bloc/category/category_bloc.dart';
import 'package:frontend_admin/service/ui_helper.dart';
import 'package:material_symbols_icons/symbols.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryBloc>().add(const LoadCategoryEvent());
    });
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  Future<void> _showAddCategoryDialog(BuildContext context) async {
    _categoryNameController.clear();
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
                  'Thêm danh mục',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: TextField(
              controller: _categoryNameController,
              decoration: const InputDecoration(labelText: 'Tên danh mục', hintText: 'Nhập tên danh mục'),
              autofocus: true,
            ),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_categoryNameController.text.isNotEmpty) {
                    context.read<CategoryBloc>().add(AddCategoryEvent(name: _categoryNameController.text));
                    Navigator.pop(context);
                    await UIHelper.showInfoSnackbar(context: context, message: 'Thêm danh mục thành công!');
                  }
                },
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }

  Future<void> _showEditCategoryDialog(BuildContext context, int id, String currentName) async {
    _categoryNameController.text = currentName;

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
                  'Sửa danh mục',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: TextField(
              controller: _categoryNameController,
              decoration: const InputDecoration(labelText: 'Tên danh mục', hintText: 'Nhập tên danh mục mới'),
              autofocus: true,
            ),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_categoryNameController.text.isNotEmpty) {
                    context.read<CategoryBloc>().add(EditCategoryEvent(id: id, name: _categoryNameController.text));
                    Navigator.pop(context);
                    await UIHelper.showSuccessSnackbar(context: context, message: 'Cập nhật danh mục thành công!');
                  }
                },
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
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
                const Text('Bạn có chắc chắn muốn xóa danh mục này không?'),
                const SizedBox(height: 16),
                const Text(
                  'Xóa danh mục có thể ảnh hưởng đến các sản phẩm liên quan.',
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
                  context.read<CategoryBloc>().add(DeleteCategoryEvent(id: id));
                  Navigator.pop(context);
                  await UIHelper.showSuccessSnackbar(context: context, message: 'Xóa danh mục thành công!');
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CategoryError) {
              return Center(child: Text('Lỗi: ${state.message}'));
            }
            if (state is CategoryLoaded) {
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
                        child: Icon(Symbols.category, color: theme.colorScheme.primary, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quản lý danh mục',
                            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Xem và quản lý các danh mục sản phẩm',
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: DataTable2(
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          minWidth: 600,
                          headingRowColor: WidgetStateProperty.resolveWith<Color>((states) => Colors.grey.shade100),
                          dataRowHeight: 60,
                          columns: const [
                            DataColumn2(label: Text('Mã DM')),
                            DataColumn(label: Text('Tên danh mục')),
                            DataColumn(label: Text('Thao tác')),
                          ],
                          rows: List<DataRow>.generate(state.categories.length, (index) {
                            final category = state.categories[index];
                            return DataRow(
                              cells: [
                                DataCell(Text(category.id.toString())),
                                DataCell(Text(category.name ?? '')),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Symbols.edit),
                                        tooltip: 'Sửa',
                                        onPressed:
                                            () => _showEditCategoryDialog(context, category.id!, category.name ?? ''),
                                      ),
                                      IconButton(
                                        icon: const Icon(Symbols.delete, color: Colors.red),
                                        tooltip: 'Xóa',
                                        onPressed: () => _showDeleteConfirmationDialog(context, category.id!),
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
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async => await _showAddCategoryDialog(context),
        label: const Text('Thêm danh mục'),
        icon: const Icon(Icons.add),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
