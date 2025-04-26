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
            title: Text('Thêm danh mục', style: Theme.of(context).textTheme.titleMedium),
            content: TextField(
              controller: _categoryNameController,
              decoration: const InputDecoration(labelText: 'Tên danh mục', hintText: 'Nhập tên danh mục'),
              autofocus: true,
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
              TextButton(
                onPressed: () async {
                  if (_categoryNameController.text.isNotEmpty) {
                    context.read<CategoryBloc>().add(AddCategoryEvent(name: _categoryNameController.text));
                    Navigator.pop(context);
                    await UIHelper.showInfoSnackbar(context: context, message: 'Thêm danh mục thành công!');
                  }
                },
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
            title: Text('Sửa danh mục', style: Theme.of(context).textTheme.titleMedium),
            content: TextField(
              controller: _categoryNameController,
              decoration: const InputDecoration(labelText: 'Tên danh mục', hintText: 'Nhập tên danh mục mới'),
              autofocus: true,
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
              TextButton(
                onPressed: () async {
                  if (_categoryNameController.text.isNotEmpty) {
                    context.read<CategoryBloc>().add(EditCategoryEvent(id: id, name: _categoryNameController.text));
                    Navigator.pop(context);
                    await UIHelper.showSuccessSnackbar(context: context, message: 'Cập nhật danh mục thành công!');
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
            title: Text('Xác nhận xóa', style: Theme.of(context).textTheme.titleMedium),
            content: const Text('Bạn có chắc chắn muốn xóa danh mục này không?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
              TextButton(
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
    return Scaffold(
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
                  Text('Quản lý danh mục', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Expanded(
                    child: DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 600,
                      columns: const [
                        DataColumn2(label: Text('Mã danh mục')),
                        DataColumn(label: Text('Tên danh mục')),
                        DataColumn(label: Text('Thao tác')),
                      ],
                      rows: List<DataRow>.generate(state.length, (index) {
                        final category = state[index];
                        return DataRow(
                          cells: [
                            DataCell(Text(category.id.toString())),
                            DataCell(Text(category.name!)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Symbols.edit),
                                    tooltip: 'Sửa',
                                    onPressed: () => _showEditCategoryDialog(context, category.id!, category.name!),
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
      ),
    );
  }
}
