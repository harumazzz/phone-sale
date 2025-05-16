import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({
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
  State<PaymentMethod> createState() => _PaymentMethodState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<String, dynamic>>('checkoutData', checkoutData));
    properties.add(ObjectFlagProperty<Function(Map<String, dynamic> p1)>.has('onUpdateData', onUpdateData));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onNext', onNext));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onBack', onBack));
  }
}

class _PaymentMethodState extends State<PaymentMethod> {
  String _selectedPaymentMethod = 'cod';

  @override
  void initState() {
    super.initState();
    _selectedPaymentMethod = widget.checkoutData['paymentMethod'] ?? 'cod';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Phương thức thanh toán', Symbols.payments),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPaymentOption(
                      'cod',
                      'Thanh toán khi nhận hàng (COD)',
                      'Thanh toán bằng tiền mặt khi nhận hàng',
                      Icons.money,
                    ),
                    const Divider(height: 1),
                    _buildPaymentOption(
                      'bank_transfer',
                      'Chuyển khoản ngân hàng',
                      'Chuyển khoản đến tài khoản ngân hàng của chúng tôi',
                      Icons.account_balance,
                    ),
                    const Divider(height: 1),
                    _buildPaymentOption(
                      'credit_card',
                      'Thẻ tín dụng / Ghi nợ',
                      'Thanh toán an toàn với thẻ của bạn',
                      Icons.credit_card,
                    ),
                    const Divider(height: 1),
                    _buildPaymentOption(
                      'momo',
                      'Ví điện tử MoMo',
                      'Thanh toán qua ví MoMo',
                      Icons.account_balance_wallet,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_selectedPaymentMethod == 'bank_transfer') _buildBankTransferInformation(context),
            if (_selectedPaymentMethod == 'credit_card') _buildCreditCardForm(context),
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
                    onPressed: () {
                      // Save selected payment method
                      widget.onUpdateData({'paymentMethod': _selectedPaymentMethod});
                      widget.onNext();
                    },
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

  Widget _buildPaymentOption(String value, String title, String subtitle, IconData icon) {
    final isSelected = _selectedPaymentMethod == value;
    final theme = Theme.of(context);

    return RadioListTile<String>(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isSelected ? theme.colorScheme.primary : Colors.grey[600], size: 20),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      subtitle: Padding(padding: const EdgeInsets.only(left: 40.0), child: Text(subtitle)),
      value: value,
      groupValue: _selectedPaymentMethod,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedPaymentMethod = newValue;
          });
        }
      },
      activeColor: theme.colorScheme.primary,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );
  }

  Widget _buildBankTransferInformation(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thông tin chuyển khoản', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildBankDetail('Ngân hàng', 'Vietcombank'),
            _buildBankDetail('Số tài khoản', '1234567890'),
            _buildBankDetail('Chủ tài khoản', 'CÔNG TY TNHH PHONE SALE'),
            _buildBankDetail(
              'Nội dung chuyển khoản',
              'Thanh toan don hang #${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber[800]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Vui lòng chuyển khoản và chụp lại biên lai để xác nhận đơn hàng.',
                      style: TextStyle(color: Colors.amber[900]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 140, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildCreditCardForm(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin thẻ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTextField('Số thẻ', '1234 5678 9012 3456'),
            Row(
              children: [
                Expanded(child: _buildTextField('Ngày hết hạn', 'MM/YY')),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField('CVV', '123', isPassword: true)),
              ],
            ),
            _buildTextField('Tên chủ thẻ', 'NGUYEN VAN A'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock_outline, color: Colors.green[800]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Thông tin thẻ của bạn được mã hóa và bảo mật.',
                      style: TextStyle(color: Colors.green[900]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
