import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_admin/bloc/discount/discount_bloc.dart';
import 'package:frontend_admin/model/request/discount_request.dart';
import 'package:frontend_admin/service/ui_helper.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:intl/intl.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _discountValueController = TextEditingController();
  final TextEditingController _minOrderValueController = TextEditingController();
  final TextEditingController _maxUsesController = TextEditingController();

  int _selectedDiscountType = 0; // 0 = Percentage, 1 = FixedAmount
  bool _isActive = true;
  DateTime? _validFrom;
  DateTime? _validTo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DiscountBloc>().add(const LoadDiscountEvent());
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    _discountValueController.dispose();
    _minOrderValueController.dispose();
    _maxUsesController.dispose();
    super.dispose();
  }

  Future<void> _showAddDiscountDialog(BuildContext context) async {
    _clearControllers();
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Symbols.local_offer, color: Colors.green),
                SizedBox(width: 8),
                Text('Thêm mã giảm giá mới'),
              ],
            ),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(_codeController, 'Mã giảm giá', Symbols.code),
                    const SizedBox(height: 16),
                    _buildTextField(_descriptionController, 'Mô tả', Symbols.description),
                    const SizedBox(height: 16),
                    _buildDiscountTypeDropdown(),
                    const SizedBox(height: 16),
                    _buildTextField(_discountValueController, 'Giá trị giảm', Symbols.percent, isNumber: true),
                    const SizedBox(height: 16),
                    _buildTextField(
                      _minOrderValueController,
                      'Giá trị đơn hàng tối thiểu',
                      Symbols.attach_money,
                      isNumber: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(_maxUsesController, 'Số lần sử dụng tối đa', Symbols.counter_1, isNumber: true),
                    const SizedBox(height: 16),
                    _buildActiveSwitch(),
                    const SizedBox(height: 16),
                    _buildDatePickers(),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Hủy')),
              ElevatedButton(onPressed: () => _submitDiscount(context), child: const Text('Thêm')),
            ],
          ),
    );
  }

  Future<void> _showEditDiscountDialog(BuildContext context, dynamic discount) async {
    _populateControllers(discount);
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [Icon(Symbols.edit, color: Colors.blue), SizedBox(width: 8), Text('Chỉnh sửa mã giảm giá')],
            ),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextField(_codeController, 'Mã giảm giá', Symbols.code),
                    const SizedBox(height: 16),
                    _buildTextField(_descriptionController, 'Mô tả', Symbols.description),
                    const SizedBox(height: 16),
                    _buildDiscountTypeDropdown(),
                    const SizedBox(height: 16),
                    _buildTextField(_discountValueController, 'Giá trị giảm', Symbols.percent, isNumber: true),
                    const SizedBox(height: 16),
                    _buildTextField(
                      _minOrderValueController,
                      'Giá trị đơn hàng tối thiểu',
                      Symbols.attach_money,
                      isNumber: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(_maxUsesController, 'Số lần sử dụng tối đa', Symbols.counter_1, isNumber: true),
                    const SizedBox(height: 16),
                    _buildActiveSwitch(),
                    const SizedBox(height: 16),
                    _buildDatePickers(),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Hủy')),
              ElevatedButton(
                onPressed: () => _submitEditDiscount(context, discount.discountId),
                child: const Text('Cập nhật'),
              ),
            ],
          ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildDiscountTypeDropdown() {
    return DropdownButtonFormField<int>(
      value: _selectedDiscountType,
      decoration: InputDecoration(
        labelText: 'Loại giảm giá',
        prefixIcon: const Icon(Symbols.category),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: const [
        DropdownMenuItem(value: 0, child: Text('Phần trăm (%)')),
        DropdownMenuItem(value: 1, child: Text('Số tiền cố định (VND)')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedDiscountType = value ?? 0;
        });
      },
    );
  }

  Widget _buildActiveSwitch() {
    return Row(
      children: [
        const Icon(Symbols.toggle_on),
        const SizedBox(width: 8),
        const Text('Trạng thái hoạt động'),
        const Spacer(),
        Switch(
          value: _isActive,
          onChanged: (value) {
            setState(() {
              _isActive = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDatePickers() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context, true),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Ngày bắt đầu',
                    prefixIcon: const Icon(Symbols.calendar_today),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(_validFrom != null ? DateFormat('dd/MM/yyyy').format(_validFrom!) : 'Chọn ngày'),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context, false),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Ngày kết thúc',
                    prefixIcon: const Icon(Symbols.calendar_today),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(_validTo != null ? DateFormat('dd/MM/yyyy').format(_validTo!) : 'Chọn ngày'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_validFrom ?? DateTime.now()) : (_validTo ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _validFrom = picked;
        } else {
          _validTo = picked;
        }
      });
    }
  }

  void _clearControllers() {
    _codeController.clear();
    _descriptionController.clear();
    _discountValueController.clear();
    _minOrderValueController.clear();
    _maxUsesController.clear();
    _selectedDiscountType = 0;
    _isActive = true;
    _validFrom = null;
    _validTo = null;
  }

  void _populateControllers(dynamic discount) {
    _codeController.text = discount.code ?? '';
    _descriptionController.text = discount.description ?? '';
    _discountValueController.text = discount.discountValue?.toString() ?? '';
    _minOrderValueController.text = discount.minOrderValue?.toString() ?? '';
    _maxUsesController.text = discount.maxUses?.toString() ?? '';
    _selectedDiscountType = discount.discountType ?? 0;
    _isActive = discount.isActive ?? true;
    _validFrom = discount.validFrom;
    _validTo = discount.validTo;
  }

  void _submitDiscount(BuildContext context) {
    if (_validateInput()) {
      final request = DiscountRequest(
        code: _codeController.text,
        description: _descriptionController.text,
        discountType: _selectedDiscountType,
        discountValue: double.tryParse(_discountValueController.text),
        minOrderValue: double.tryParse(_minOrderValueController.text),
        isActive: _isActive,
        validFrom: _validFrom,
        validTo: _validTo,
        maxUses: int.tryParse(_maxUsesController.text),
      );

      context.read<DiscountBloc>().add(AddDiscountEvent(request: request));
      Navigator.of(context).pop();
      UIHelper.showSuccessSnackbar(context: context, message: 'Đã thêm mã giảm giá thành công!');
    }
  }

  void _submitEditDiscount(BuildContext context, int id) {
    if (_validateInput()) {
      final request = DiscountRequest(
        code: _codeController.text,
        description: _descriptionController.text,
        discountType: _selectedDiscountType,
        discountValue: double.tryParse(_discountValueController.text),
        minOrderValue: double.tryParse(_minOrderValueController.text),
        isActive: _isActive,
        validFrom: _validFrom,
        validTo: _validTo,
        maxUses: int.tryParse(_maxUsesController.text),
      );

      context.read<DiscountBloc>().add(EditDiscountEvent(id: id, request: request));
      Navigator.of(context).pop();
      UIHelper.showSuccessSnackbar(context: context, message: 'Đã cập nhật mã giảm giá thành công!');
    }
  }

  bool _validateInput() {
    if (_codeController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _discountValueController.text.isEmpty ||
        _minOrderValueController.text.isEmpty ||
        _validFrom == null ||
        _validTo == null) {
      UIHelper.showErrorSnackbar(context: context, message: 'Vui lòng điền đầy đủ thông tin!');
      return false;
    }

    if (_validTo!.isBefore(_validFrom!)) {
      UIHelper.showErrorSnackbar(context: context, message: 'Ngày kết thúc phải sau ngày bắt đầu!');
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quản lý mã giảm giá',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                    Text(
                      'Quản lý các mã giảm giá cho cửa hàng',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddDiscountDialog(context),
                  icon: const Icon(Symbols.add),
                  label: const Text('Thêm mã giảm giá'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: BlocBuilder<DiscountBloc, DiscountState>(
                  builder: (context, state) {
                    if (state is DiscountLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is DiscountError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Symbols.error, size: 64, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            Text('Lỗi: ${state.message}'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => context.read<DiscountBloc>().add(const LoadDiscountEvent()),
                              child: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      );
                    } else if (state is DiscountLoaded) {
                      return DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        minWidth: 900,
                        columns: const [
                          DataColumn2(label: Text('Mã'), size: ColumnSize.S),
                          DataColumn2(label: Text('Mô tả'), size: ColumnSize.L),
                          DataColumn2(label: Text('Loại'), size: ColumnSize.S),
                          DataColumn2(label: Text('Giá trị'), size: ColumnSize.S),
                          DataColumn2(label: Text('Đơn tối thiểu'), size: ColumnSize.S),
                          DataColumn2(label: Text('Trạng thái'), size: ColumnSize.S),
                          DataColumn2(label: Text('Hạn sử dụng'), size: ColumnSize.M),
                          DataColumn2(label: Text('Lượt dùng'), size: ColumnSize.S),
                          DataColumn2(label: Text('Thao tác'), size: ColumnSize.S),
                        ],
                        rows:
                            state.discounts.map((discount) {
                              return DataRow2(
                                cells: [
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        discount.code ?? '',
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(discount.description ?? '')),
                                  DataCell(Text(discount.discountTypeText)),
                                  DataCell(
                                    Text(
                                      discount.discountType == 0
                                          ? '${discount.discountValue?.toStringAsFixed(0)}%'
                                          : NumberFormat.currency(
                                            locale: 'vi_VN',
                                            symbol: '₫',
                                          ).format(discount.discountValue),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'vi_VN',
                                        symbol: '₫',
                                      ).format(discount.minOrderValue),
                                    ),
                                  ),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: discount.isActive == true ? Colors.green[50] : Colors.red[50],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        discount.statusText,
                                        style: TextStyle(
                                          color: discount.isActive == true ? Colors.green : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Từ: ${discount.validFrom != null ? DateFormat('dd/MM/yyyy').format(discount.validFrom!) : 'N/A'}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          'Đến: ${discount.validTo != null ? DateFormat('dd/MM/yyyy').format(discount.validTo!) : 'N/A'}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(Text('${discount.currentUses ?? 0}/${discount.maxUses ?? '∞'}')),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Symbols.edit, size: 20),
                                          onPressed: () => _showEditDiscountDialog(context, discount),
                                          tooltip: 'Chỉnh sửa',
                                        ),
                                        IconButton(
                                          icon: const Icon(Symbols.delete, size: 20, color: Colors.red),
                                          onPressed:
                                              () => _showDeleteConfirmation(
                                                context,
                                                discount.discountId!,
                                                discount.code!,
                                              ),
                                          tooltip: 'Xóa',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                      );
                    }
                    return const Center(child: Text('Không có dữ liệu'));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int id, String code) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: Text('Bạn có chắc chắn muốn xóa mã giảm giá "$code"?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Hủy')),
              ElevatedButton(
                onPressed: () {
                  context.read<DiscountBloc>().add(DeleteDiscountEvent(id: id));
                  Navigator.of(context).pop();
                  UIHelper.showSuccessSnackbar(context: context, message: 'Đã xóa mã giảm giá thành công!');
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Xóa', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }
}
