import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/cart_bloc/cart_bloc.dart';
import '../../utils/currency_utils.dart';
import 'shipping_information.dart';
import 'order_summary.dart';
import 'payment_method.dart';
import 'order_confirmation.dart';
import 'package:material_symbols_icons/symbols.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, this.discountAmount = 0, this.discountId});
  final double discountAmount;
  final int? discountId;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('discountAmount', discountAmount));
    properties.add(IntProperty('discountId', discountId));
  }
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  final PageController _pageController = PageController();
  final Map<String, dynamic> _checkoutData = {};

  @override
  void initState() {
    super.initState();
    _loadCheckoutData();
  }

  void _loadCheckoutData() {
    // Initialize checkout data with user info from auth state
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthLogin) {
      _checkoutData['customer'] = authState.data;

      // Pre-fill shipping address from customer data
      _checkoutData['shippingAddress'] = {
        'fullName': '${authState.data.firstName} ${authState.data.lastName}',
        'address': authState.data.address ?? '',
        'phone': authState.data.phoneNumber ?? '',
        'email': authState.data.email ?? '',
        'city': '',
        'zipCode': '',
      };
    } // Initialize with cart items
    final cartState = BlocProvider.of<CartBloc>(context).state;
    if (cartState is CartLoaded) {
      _checkoutData['cartItems'] = cartState.carts; // Calculate total
      final double subtotal = cartState.carts.fold(
        0.0,
        (sum, item) => sum + (item.product.price ?? 0) * item.quantity,
      ); // Apply discount if available - convert VND discount back to USD for calculations
      final double discountAmountUsd = CurrencyUtils.vndToUsd(widget.discountAmount) ?? 0.0;

      _checkoutData['discountAmount'] = widget.discountAmount; // Keep VND for display
      _checkoutData['discountAmountUsd'] = discountAmountUsd; // USD for calculations
      _checkoutData['discountId'] = widget.discountId;
      _checkoutData['originalPrice'] = subtotal;
      _checkoutData['finalPrice'] = subtotal - discountAmountUsd; // USD calculation

      _checkoutData['subtotal'] = subtotal;
      _checkoutData['shippingFee'] = 0.0; // Default: Free shipping
      _checkoutData['total'] = subtotal - discountAmountUsd; // Use discounted total in USD

      // Default to COD payment method
      _checkoutData['paymentMethod'] = 'cod';
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updateCheckoutData(Map<String, dynamic> data) {
    setState(() {
      _checkoutData.addAll(data);
    });
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(_currentStep, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: _previousStep),
        title: Text('Thanh toán', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildCheckoutStepper(context),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                OrderSummary(checkoutData: _checkoutData, onUpdateData: _updateCheckoutData, onNext: _nextStep),
                ShippingInformation(
                  checkoutData: _checkoutData,
                  onUpdateData: _updateCheckoutData,
                  onNext: _nextStep,
                  onBack: _previousStep,
                ),
                PaymentMethod(
                  checkoutData: _checkoutData,
                  onUpdateData: _updateCheckoutData,
                  onNext: _nextStep,
                  onBack: _previousStep,
                ),
                OrderConfirmation(checkoutData: _checkoutData, onBack: _previousStep),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutStepper(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 2), blurRadius: 6)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepIndicator(context, 0, 'Giỏ hàng', Symbols.shopping_cart),
          _buildStepConnector(0),
          _buildStepIndicator(context, 1, 'Thông tin giao hàng', Symbols.local_shipping),
          _buildStepConnector(1),
          _buildStepIndicator(context, 2, 'Thanh toán', Symbols.payments),
          _buildStepConnector(2),
          _buildStepIndicator(context, 3, 'Xác nhận', Symbols.check_circle),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context, int step, String label, IconData icon) {
    final theme = Theme.of(context);
    final isActive = step <= _currentStep;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? theme.colorScheme.primary : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: isActive ? Colors.white : Colors.grey[500], size: 22),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? theme.colorScheme.primary : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(int step) {
    final isActive = step < _currentStep;

    return Container(
      width: 30,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey[300],
    );
  }
}
