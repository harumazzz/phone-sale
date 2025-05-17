import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Màn hình quên mật khẩu cho phép người dùng yêu cầu đặt lại mật khẩu
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _requestSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // TODO: Tích hợp API đặt lại mật khẩu tại đây
  Future<void> _requestPasswordReset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // TODO: Gọi API đặt lại mật khẩu
      // Ví dụ:
      // final response = await apiService.resetPassword(_emailController.text);

      // Mô phỏng độ trễ của mạng
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _requestSent = true; // Hiển thị thông báo thành công
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Không thể gửi yêu cầu. Vui lòng thử lại sau.';
        // TODO: Xử lý các loại lỗi cụ thể từ API
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Quên mật khẩu'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _requestSent ? _buildSuccessMessage() : _buildRequestForm(theme),
        ),
      ),
    );
  }

  Widget _buildRequestForm(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Icon(Symbols.lock_reset, size: 70, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            'Đặt lại mật khẩu',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Nhập email đăng ký của bạn. Chúng tôi sẽ gửi một liên kết để đặt lại mật khẩu.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Nhập email đăng ký của bạn',
              prefixIcon: const Icon(Symbols.mail),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
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
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isLoading ? null : _requestPasswordReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              disabledBackgroundColor: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            child:
                _isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                    )
                    : const Text('GỬI YÊU CẦU', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Quay lại đăng nhập')),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Icon(Symbols.check_circle, size: 80, color: Colors.green[600]),
        const SizedBox(height: 24),
        Text(
          'Yêu cầu đã được gửi',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Chúng tôi đã gửi email mật khẩu đến địa chỉ email của bạn. '
            'Vui lòng kiểm tra hộp thư đến.',
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('QUAY LẠI ĐĂNG NHẬP'),
        ),
      ],
    );
  }
}
