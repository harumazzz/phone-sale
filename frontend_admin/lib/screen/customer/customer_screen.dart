import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_admin/bloc/customer/customer_bloc.dart';
import 'package:frontend_admin/model/request/customer_request.dart';
import 'package:frontend_admin/service/ui_helper.dart';
import 'package:material_symbols_icons/symbols.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerBloc>().add(const LoadCustomerEvent());
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _showAddCustomerDialog(BuildContext context) async {
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
                    color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Symbols.person_add, color: Theme.of(context).colorScheme.secondary),
                ),
                const SizedBox(width: 12),
                Text(
                  'Thêm khách hàng',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: _buildCustomerForm(context),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_validateForm()) {
                    final request = _buildCustomerRequest();
                    context.read<CustomerBloc>().add(AddCustomerEvent(request: request));
                    Navigator.pop(context);
                    await UIHelper.showInfoSnackbar(context: context, message: 'Thêm khách hàng thành công!');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Thêm'),
              ),
            ],
          ),
    );
  }

  Future<void> _showEditCustomerDialog(
    BuildContext context,
    String id,
    String firstName,
    String lastName,
    String email,
    String address,
    String phoneNumber,
  ) async {
    _firstNameController.text = firstName;
    _lastNameController.text = lastName;
    _emailController.text = email;
    _passwordController.text = ''; // Password is not included in edit form
    _addressController.text = address;
    _phoneController.text = phoneNumber;

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Sửa thông tin khách hàng', style: Theme.of(context).textTheme.titleMedium),
            content: _buildCustomerForm(context, isEditing: true),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
              TextButton(
                onPressed: () async {
                  if (_validateForm(isEditing: true)) {
                    final request = _buildCustomerRequest(isEditing: true);
                    context.read<CustomerBloc>().add(EditCustomerEvent(id: int.parse(id), request: request));
                    Navigator.pop(context);
                    await UIHelper.showSuccessSnackbar(
                      context: context,
                      message: 'Cập nhật thông tin khách hàng thành công!',
                    );
                  }
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, String id) async {
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
                const Text('Bạn có chắc chắn muốn xóa khách hàng này không?'),
                const SizedBox(height: 16),
                const Text(
                  'Xóa thông tin khách hàng sẽ xóa cả lịch sử mua hàng và thông tin thanh toán.',
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
                  context.read<CustomerBloc>().add(DeleteCustomerEvent(id: int.parse(id)));
                  Navigator.pop(context);
                  await UIHelper.showSuccessSnackbar(context: context, message: 'Xóa khách hàng thành công!');
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
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _addressController.clear();
    _phoneController.clear();
  }

  bool _validateForm({bool isEditing = false}) {
    if (!isEditing) {
      return _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _addressController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty;
    } else {
      return _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _addressController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty;
    }
  }

  CustomerRequest _buildCustomerRequest({bool isEditing = false}) {
    return CustomerRequest(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      password: isEditing ? null : _passwordController.text,
      address: _addressController.text,
      phoneNumber: _phoneController.text,
    );
  }

  Widget _buildCustomerForm(BuildContext context, {bool isEditing = false}) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'Tên', hintText: 'Nhập tên khách hàng'),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Họ', hintText: 'Nhập họ khách hàng'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', hintText: 'Nhập email khách hàng'),
              keyboardType: TextInputType.emailAddress,
            ),
            if (!isEditing) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Mật khẩu', hintText: 'Nhập mật khẩu'),
                obscureText: true,
              ),
            ],
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Địa chỉ', hintText: 'Nhập địa chỉ khách hàng'),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Số điện thoại', hintText: 'Nhập số điện thoại khách hàng'),
              keyboardType: TextInputType.phone,
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
        child: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            if (state is CustomerLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CustomerError) {
              return Center(child: Text('Lỗi: ${state.message}'));
            }
            if (state is CustomerLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Symbols.person, color: theme.colorScheme.secondary, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quản lý khách hàng',
                            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Xem và quản lý thông tin khách hàng',
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
                            DataColumn2(label: Text('ID')),
                            DataColumn(label: Text('Họ tên')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Địa chỉ')),
                            DataColumn(label: Text('Số điện thoại')),
                            DataColumn(label: Text('Thao tác')),
                          ],
                          rows: List<DataRow>.generate(state.customers.length, (index) {
                            final customer = state.customers[index];
                            final fullName = '${customer.firstName ?? ''} ${customer.lastName ?? ''}';
                            return DataRow(
                              cells: [
                                DataCell(Text(customer.customerId.toString())),
                                DataCell(Text(fullName)),
                                DataCell(Text(customer.email ?? '')),
                                DataCell(Text(customer.address ?? '')),
                                DataCell(Text(customer.phoneNumber ?? '')),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Symbols.edit, color: theme.colorScheme.primary),
                                        tooltip: 'Sửa',
                                        onPressed:
                                            () => _showEditCustomerDialog(
                                              context,
                                              customer.customerId.toString(),
                                              customer.firstName ?? '',
                                              customer.lastName ?? '',
                                              customer.email ?? '',
                                              customer.address ?? '',
                                              customer.phoneNumber ?? '',
                                            ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Symbols.delete, color: Colors.red),
                                        tooltip: 'Xóa',
                                        onPressed:
                                            () =>
                                                _showDeleteConfirmationDialog(context, customer.customerId.toString()),
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
        onPressed: () => _showAddCustomerDialog(context),
        label: const Text('Thêm khách hàng'),
        icon: const Icon(Icons.add),
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
