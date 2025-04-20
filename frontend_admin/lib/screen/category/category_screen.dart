import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_admin/bloc/category/category_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryBloc>().add(LoadCategoryEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const CircularProgressIndicator();
          }
          if (state is CategoryError) {
            return Text(state.message);
          }
          if (state is CategoryLoaded) {
            return DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 600,
              columns: [
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
                            onPressed: () {
                              context.read<CategoryBloc>().add(
                                EditCategoryEvent(
                                  id: category.id!,
                                  name: category.name!,
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Symbols.delete),
                            onPressed: () {
                              context.read<CategoryBloc>().add(
                                DeleteCategoryEvent(id: category.id!),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
