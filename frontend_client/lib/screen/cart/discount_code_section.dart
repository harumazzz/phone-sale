import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/discount_bloc/discount_bloc_export.dart';
import '../../utils/currency_utils.dart';

class DiscountCodeSection extends StatefulWidget {
  const DiscountCodeSection({super.key, required this.cartTotal, required this.onDiscountApplied});
  final double cartTotal;
  final Function(double discountAmount, int? discountId) onDiscountApplied;

  @override
  State<DiscountCodeSection> createState() => _DiscountCodeSectionState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('cartTotal', cartTotal));
    properties.add(
      ObjectFlagProperty<Function(double discountAmount, int? discountId)>.has('onDiscountApplied', onDiscountApplied),
    );
  }
}

class _DiscountCodeSectionState extends State<DiscountCodeSection> {
  final TextEditingController _discountController = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.discount_outlined, color: Colors.deepPurple),
                const SizedBox(width: 8),
                const Text('Mã giảm giá', style: TextStyle(fontWeight: FontWeight.w500)),
                const Spacer(),
                Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          BlocBuilder<DiscountBloc, DiscountState>(
            builder: (context, state) {
              Widget? messageWidget;
              if (state is DiscountValidated) {
                final discountValue = state.discount.discountValue ?? 0.0;
                final isValid = state.discount.isActive == true;

                if (isValid) {
                  messageWidget = Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Giảm giá áp dụng:',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '- ${CurrencyUtils.formatVnd(discountValue)} (${state.discount.code ?? ""})',
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ); // Callback to parent with discount information
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    widget.onDiscountApplied(discountValue, state.discount.discountId);
                  });
                } else {
                  messageWidget = Text(
                    state.discount.description ?? 'Mã giảm giá không hợp lệ',
                    style: const TextStyle(color: Colors.red),
                  ); // Reset discount if invalid
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    widget.onDiscountApplied(0, null);
                  });
                }
              } else if (state is DiscountError) {
                messageWidget = Text(state.message, style: const TextStyle(color: Colors.red));

                // Reset discount on error
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onDiscountApplied(0, null);
                });
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _discountController,
                            decoration: InputDecoration(
                              hintText: 'Nhập mã giảm giá',
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            textCapitalization: TextCapitalization.characters,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildApplyButton(context),
                      ],
                    ),
                    if (messageWidget != null) Padding(padding: const EdgeInsets.only(top: 8.0), child: messageWidget),
                  ],
                ),
              );
            },
          ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return BlocBuilder<DiscountBloc, DiscountState>(
      builder: (context, state) {
        final bool isLoading = state is DiscountLoading;

        return ElevatedButton(
          onPressed: isLoading ? null : () => _applyDiscount(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child:
              isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                  : const Text('Áp dụng'),
        );
      },
    );
  }

  void _applyDiscount(BuildContext context) {
    final code = _discountController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập mã giảm giá')));
      return;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthLogin) {
      context.read<DiscountBloc>().add(
        DiscountValidateEvent(code: code, cartTotal: widget.cartTotal, customerId: authState.data.customerId!),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vui lòng đăng nhập để sử dụng mã giảm giá')));
    }
  }
}
