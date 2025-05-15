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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Symbols.add_circle, color: Theme.of(context).colorScheme.tertiary),
                ),
                const SizedBox(width: 12),
                Text(
                  'Thêm đơn hàng',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: _buildOrderForm(context),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_validateForm()) {
                    final request = _buildOrderRequest();
                    context.read<OrderBloc>().add(AddOrderEvent(request: request));
                    Navigator.pop(context);
                    await UIHelper.showInfoSnackbar(context: context, message: 'Thêm đơn hàng thành công!');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Symbols.edit, color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Text(
                  'Sửa đơn hàng',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: _buildOrderForm(context),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_validateForm()) {
                    final request = _buildOrderRequest();
                    context.read<OrderBloc>().add(EditOrderEvent(id: id, request: request));
                    Navigator.pop(context);
                    await UIHelper.showSuccessSnackbar(context: context, message: 'Cập nhật đơn hàng thành công!');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
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
                const Text('Bạn có chắc chắn muốn xóa đơn hàng này không?'),
                const SizedBox(height: 16),
                const Text(
                  'Xóa đơn hàng sẽ xóa tất cả thông tin liên quan của đơn hàng này.',
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
                  context.read<OrderBloc>().add(DeleteOrderEvent(id: id));
                  Navigator.pop(context);
                  await UIHelper.showSuccessSnackbar(context: context, message: 'Xóa đơn hàng thành công!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
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
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Symbols.info, color: theme.colorScheme.tertiary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Nhập thông tin đơn hàng cơ bản. Các sản phẩm có thể được thêm sau khi tạo đơn hàng.',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              controller: _totalPriceController,
              decoration: InputDecoration(
                labelText: 'Tổng tiền',
                hintText: 'Nhập tổng tiền đơn hàng',
                prefixIcon: Icon(Symbols.attach_money, color: theme.colorScheme.tertiary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.colorScheme.tertiary),
                ),
              ),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
            const SizedBox(height: 20),
            BlocBuilder<CustomerBloc, CustomerState>(
              builder: (context, state) {
                if (state is CustomerLoaded) {
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Khách hàng',
                      prefixIcon: Icon(Symbols.person, color: theme.colorScheme.secondary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: theme.colorScheme.secondary),
                      ),
                    ),
                    value: _selectedCustomerId.isEmpty ? null : _selectedCustomerId,
                    hint: const Text('Chọn khách hàng'),
                    isExpanded: true,
                    icon: Icon(Symbols.keyboard_arrow_down, color: theme.colorScheme.secondary),
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
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(color: theme.colorScheme.secondary),
                  ),
                );
              },
            ),
          ],
        ),
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Symbols.receipt_long, color: theme.colorScheme.tertiary, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quản lý đơn hàng',
                            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          const SizedBox(height: 4),
                          Text('Xem và quản lý các đơn hàng', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
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
                            DataColumn2(label: Text('Mã đơn hàng')),
                            DataColumn(label: Text('Ngày đặt')),
                            DataColumn(label: Text('Tổng tiền')),
                            DataColumn(label: Text('Mã khách hàng')),
                            DataColumn(label: Text('Thao tác')),
                          ],
                          rows: List<DataRow>.generate(state.orders.length, (index) {
                            final order = state.orders[index];
                            final formattedDate =
                                order.orderDate != null ? DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate!) : '';
                            final formattedPrice = NumberFormat.currency(
                              locale: 'vi_VN',
                              symbol: '₫',
                            ).format(order.totalPrice);
                            return DataRow(
                              cells: [
                                DataCell(Text(order.orderId.toString())),
                                DataCell(Text(formattedDate)),
                                DataCell(Text(formattedPrice)),
                                DataCell(Text(order.customerId.toString())),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Symbols.edit, color: theme.colorScheme.primary),
                                        tooltip: 'Sửa',
                                        onPressed:
                                            () => _showEditOrderDialog(
                                              context,
                                              order.orderId!,
                                              order.totalPrice!,
                                              order.customerId!,
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
        onPressed: () => _showAddOrderDialog(context),
        label: const Text('Thêm đơn hàng'),
        icon: const Icon(Icons.add),
        backgroundColor: theme.colorScheme.tertiary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
