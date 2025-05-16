import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ShippingInformation extends StatefulWidget {
  const ShippingInformation({
    super.key,
    required this.checkoutData,
    required this.onUpdateData,
    required this.onNext,
    required this.onBack,
  });
  final Map<String, dynamic> checkoutData;
  final Function(Map<String, dynamic>) onUpdateData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  State<ShippingInformation> createState() => _ShippingInformationState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<String, dynamic>>('checkoutData', checkoutData));
    properties.add(ObjectFlagProperty<Function(Map<String, dynamic> p1)>.has('onUpdateData', onUpdateData));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onNext', onNext));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onBack', onBack));
  }
}

class _ShippingInformationState extends State<ShippingInformation> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _cityController;
  late TextEditingController _zipCodeController;
  bool _saveAddressForFuture = true;

  @override
  void initState() {
    super.initState();

    final shippingAddress = widget.checkoutData['shippingAddress'] ?? {};

    _fullNameController = TextEditingController(text: shippingAddress['fullName'] ?? '');
    _addressController = TextEditingController(text: shippingAddress['address'] ?? '');
    _phoneController = TextEditingController(text: shippingAddress['phone'] ?? '');
    _emailController = TextEditingController(text: shippingAddress['email'] ?? '');
    _cityController = TextEditingController(text: shippingAddress['city'] ?? '');
    _zipCodeController = TextEditingController(text: shippingAddress['zipCode'] ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _saveShippingInfo() {
    if (_formKey.currentState!.validate()) {
      final shippingInfo = {
        'shippingAddress': {
          'fullName': _fullNameController.text,
          'address': _addressController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'city': _cityController.text,
          'zipCode': _zipCodeController.text,
          'saveForFuture': _saveAddressForFuture,
        },
      };

      widget.onUpdateData(shippingInfo);
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, 'Thông tin giao hàng', Symbols.local_shipping),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField(
                        label: 'Họ và tên người nhận',
                        controller: _fullNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập họ tên người nhận';
                          }
                          return null;
                        },
                      ),
                      _buildInputField(
                        label: 'Số điện thoại',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập số điện thoại';
                          }
                          if (!RegExp(r'^\d{9,11}$').hasMatch(value)) {
                            return 'Số điện thoại không hợp lệ';
                          }
                          return null;
                        },
                      ),
                      _buildInputField(
                        label: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Email không hợp lệ';
                          }
                          return null;
                        },
                      ),
                      _buildInputField(
                        label: 'Địa chỉ',
                        controller: _addressController,
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập địa chỉ';
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Expanded(child: _buildInputField(label: 'Thành phố', controller: _cityController)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInputField(
                              label: 'Mã bưu điện',
                              controller: _zipCodeController,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Lưu địa chỉ này cho lần sau'),
                        value: _saveAddressForFuture,
                        onChanged: (value) {
                          setState(() {
                            _saveAddressForFuture = value;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildDeliveryOptions(context),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onBack,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.colorScheme.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'QUAY LẠI',
                        style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveShippingInfo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('TIẾP TỤC', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDeliveryOptions(BuildContext context) {
    final theme = Theme.of(context);

    // Default to standard shipping option
    if (!widget.checkoutData.containsKey('deliveryOption')) {
      widget.onUpdateData({'deliveryOption': 'standard'});
    }

    String selectedOption = widget.checkoutData['deliveryOption'] ?? 'standard';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phương thức giao hàng', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildDeliveryOption(
              context,
              'standard',
              'Giao hàng tiêu chuẩn',
              'Giao hàng trong 3-5 ngày',
              'Miễn phí',
              selectedOption == 'standard',
              (value) {
                if (value != null && value) {
                  widget.onUpdateData({'deliveryOption': 'standard'});
                  setState(() {
                    selectedOption = 'standard';
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            _buildDeliveryOption(
              context,
              'express',
              'Giao hàng nhanh',
              'Giao hàng trong 1-2 ngày',
              '30.000 ₫',
              selectedOption == 'express',
              (value) {
                if (value != null && value) {
                  widget.onUpdateData({'deliveryOption': 'express'});
                  setState(() {
                    selectedOption = 'express';
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryOption(
    BuildContext context,
    String value,
    String title,
    String description,
    String price,
    bool isSelected,
    // ignore: avoid_positional_boolean_parameters
    Function(bool? value) onChanged,
  ) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? theme.colorScheme.primary : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: RadioListTile<String>(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              price,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: price.contains('Miễn phí') ? Colors.green[700] : null,
              ),
            ),
          ],
        ),
        subtitle: Text(description),
        value: value,
        groupValue: isSelected ? value : null,
        onChanged: (String? newValue) {
          onChanged(newValue == value);
        },
        activeColor: theme.colorScheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
