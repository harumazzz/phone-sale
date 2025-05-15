import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../model/request/register_request.dart';
import '../../service/ui_helper.dart';
import '../log_in/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        RegisterEvent(
          data: RegisterRequest(
            email: _emailController.text,
            password: _passwordController.text,
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            address: _addressController.text,
            phoneNumber: _phoneController.text,
          ),
        ),
      );
    }
  }

  Future<void> _onListener(BuildContext context, AuthState state) async {
    Future<void> toLogin() async {
      // Clear navigation stack and push login screen
      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }

    Future<void> showDialog({required String title, required String content}) async {
      await UIHelper.showSimpleDialog(context: context, title: title, content: content);
    }

    if (state is AuthRegister) {
      await showDialog(title: 'Đăng ký thành công', content: 'Tài khoản của bạn đã được tạo. Vui lòng đăng nhập.');
      await toLogin();
    }
    if (state is AuthRegisterFailed) {
      await showDialog(title: 'Đăng ký thất bại', content: state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Removed AppBar for a cleaner look, back navigation can be handled by system or a custom button if needed
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    Symbols.person_add, // Using Material Symbols
                    size: 64, // Adjusted size
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tạo tài khoản mới',
                    style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vui lòng điền đầy đủ thông tin bên dưới.',
                    style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      hintText: 'Tên',
                      prefixIcon: const Icon(Symbols.person), // Corrected Icon
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      hintText: 'Họ',
                      prefixIcon: const Icon(Symbols.person), // Corrected Icon
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập họ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: const Icon(Symbols.email), // Corrected Icon
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Mật khẩu',
                      prefixIcon: const Icon(Symbols.lock), // Corrected Icon
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Symbols.visibility_off : Symbols.visibility, // Corrected Icons
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      }
                      if (value.length < 6) {
                        return 'Mật khẩu phải có ít nhất 6 ký tự';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Xác nhận mật khẩu',
                      prefixIcon: const Icon(Symbols.lock), // Corrected Icon
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Symbols.visibility_off : Symbols.visibility, // Corrected Icons
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng xác nhận mật khẩu';
                      } else if (value != _passwordController.text) {
                        return 'Mật khẩu không khớp';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'Địa chỉ',
                      prefixIcon: const Icon(Symbols.home), // Corrected Icon
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập địa chỉ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: 'Số điện thoại',
                      prefixIcon: const Icon(Symbols.phone), // Corrected Icon
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số điện thoại';
                      } else if (!RegExp(r'^[0-9]{10,11}$').hasMatch(value)) {
                        return 'Số điện thoại không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24), // Increased spacing before button
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: _onListener,
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        onPressed: _onRegister,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
                        child: const Text('Đăng ký'),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Đã có tài khoản? ',
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Đăng nhập',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushReplacement(
                                      // Use pushReplacement to avoid stacking signup screens
                                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
