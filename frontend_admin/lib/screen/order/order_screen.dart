import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_admin/bloc/customer/customer_bloc.dart';
import 'package:frontend_admin/bloc/order/order_bloc.dart';
import 'package:frontend_admin/model/request/order_request.dart';
import 'package:frontend_admin/service/ui_helper.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController _totalPriceController = TextEditingController();
  String _selectedCustomerId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderBloc>().add(const LoadOrderEvent());
      context.read<CustomerBloc>().add(const LoadCustomerEvent());
    });
  }

  @override
  void dispose() {
    _totalPriceController.dispose();
    super.dispose();
  }

  Future<void> _showAddOrderDialog(BuildContext context) async {
    _clearControllers();
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Thêm đơn hàng', style: Theme.of(context).textTheme.titleMedium),
            content: _buildOrderForm(context),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
              TextButton(
                onPressed: () async {
                  if (_validateForm()) {
                    final request = _buildOrderRequest();
                    context.read<OrderBloc>().add(AddOrderEvent(request: request));
                    Navigator.pop(context);
                    await UIHelper.showInfoSnackbar(context: context, message: 'Thêm đơn hàng thành công!');
                  }
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }

  Future<void> _showEditOrderDialog(BuildContext context, int id, double totalPrice, String customerId) async {
    _totalPriceController.text = totalPrice.toString();
    _selectedCustomerId = customerId;

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Sửa đơn hàng', style: Theme.of(context).textTheme.titleMedium),
            content: _buildOrderForm(context),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
              TextButton(
                onPressed: () async {
                  if (_validateForm()) {
                    final request = _buildOrderRequest();
                    context.read<OrderBloc>().add(EditOrderEvent(id: id, request: request));
                    Navigator.pop(context);
                    await UIHelper.showSuccessSnackbar(context: context, message: 'Cập nhật đơn hàng thành công!');
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
            content: const Text('Bạn có chắc chắn muốn xóa đơn hàng này không?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
              TextButton(
                onPressed: () async {
                  context.read<OrderBloc>().add(DeleteOrderEvent(id: id));
                  Navigator.pop(context);
                  await UIHelper.showSuccessSnackbar(context: context, message: 'Xóa đơn hàng thành công!');
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }

  void _clearControllers() {
    _totalPriceController.clear();
    _selectedCustomerId = '';
  }

  bool _validateForm() {
    return _totalPriceController.text.isNotEmpty && _selectedCustomerId.isNotEmpty;
  }

  OrderRequest _buildOrderRequest() {
    return OrderRequest(totalPrice: double.tryParse(_totalPriceController.text) ?? 0, customerId: _selectedCustomerId);
  }

  Widget _buildOrderForm(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _totalPriceController,
              decoration: const InputDecoration(labelText: 'Tổng tiền', hintText: 'Nhập tổng tiền đơn hàng'),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            BlocBuilder<CustomerBloc, CustomerState>(
              builder: (context, state) {
                if (state is CustomerLoaded) {
                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Khách hàng'),
                    value: _selectedCustomerId.isEmpty ? null : _selectedCustomerId,
                    hint: const Text('Chọn khách hàng'),
                    items:
                        state.customers.map((customer) {
                          return DropdownMenuItem<String>(
                            value: customer.customerId,
                            child: Text('${customer.firstName} ${customer.lastName} (${customer.email})'),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCustomerId = value!;
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
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is OrderError) {
              return Center(child: Text('Lỗi: ${state.message}'));
            }
            if (state is OrderLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quản lý đơn hàng', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Expanded(
                    child: DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 600,
                      columns: const [
                        DataColumn2(label: Text('Mã ĐH')),
                        DataColumn(label: Text('Ngày đặt')),
                        DataColumn(label: Text('Tổng tiền')),
                        DataColumn(label: Text('Mã KH')),
                        DataColumn(label: Text('Thao tác')),
                      ],
                      rows: List<DataRow>.generate(state.orders.length, (index) {
                        final order = state.orders[index];
                        return DataRow(
                          cells: [
                            DataCell(Text(order.orderId.toString())),
                            DataCell(
                              Text(
                                order.orderDate != null
                                    ? DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate!)
                                    : 'N/A',
                              ),
                            ),
                            DataCell(Text('${order.totalPrice ?? 0} VND')),
                            DataCell(Text(order.customerId ?? '')),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Symbols.edit),
                                    tooltip: 'Sửa',
                                    onPressed:
                                        () => _showEditOrderDialog(
                                          context,
                                          order.orderId!,
                                          order.totalPrice ?? 0,
                                          order.customerId ?? '',
                                        ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Symbols.delete, color: Colors.red),
                                    tooltip: 'Xóa',
                                    onPressed: () => _showDeleteConfirmationDialog(context, order.orderId!),
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
        onPressed: () async => await _showAddOrderDialog(context),
        label: const Text('Thêm đơn hàng'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
