import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../model/request/login_request.dart';
import '../../service/ui_helper.dart';
import '../root_screen.dart';
import '../sign_up/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogIn() async {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(data: LoginRequest(email: _emailController.text, password: _passwordController.text)),
      );
    }
  }

  Future<void> _onListener(BuildContext context, AuthState state) async {
    Future<void> toHome() async {
      await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) {
            return const RootScreen();
          },
        ),
        (Route<dynamic> route) => false,
      );
    }

    Future<void> showDialog({required String title, required String content}) async {
      await UIHelper.showSimpleDialog(context: context, title: title, content: content);
    }

    if (state is AuthLogin) {
      await toHome();
    }
    if (state is AuthLoginFailed) {
      await showDialog(title: 'Đăng nhập thất bại', content: state.message);
    }
  }

  Widget _emailTextField() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text('Email', style: TextStyle(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
        ),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: 'Nhập địa chỉ email của bạn',
            prefixIcon: Icon(Symbols.email_rounded, color: theme.colorScheme.primary, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.error),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập email';
            }
            // Simple email validation
            if (!value.contains('@') || !value.contains('.')) {
              return 'Vui lòng nhập email hợp lệ';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _passwordTextField() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text('Mật khẩu', style: TextStyle(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Nhập mật khẩu của bạn',
            prefixIcon: Icon(Symbols.lock_rounded, color: theme.colorScheme.primary, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.error),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            filled: true,
            fillColor: Colors.grey.shade50,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Symbols.visibility_off_rounded : Symbols.visibility_rounded,
                color: Colors.grey.shade600,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
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
      ],
    );
  }

  Widget _loginButton() {
    final theme = Theme.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: _onListener,
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(
            child: SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: CircularProgressIndicator(color: theme.colorScheme.primary, strokeWidth: 3),
              ),
            ),
          );
        }
        return FilledButton(
          onPressed: _onLogIn,
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
          child: const Text('ĐĂNG NHẬP'),
        );
      },
    );
  }

  Widget _signupButton(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Chưa có tài khoản?', style: TextStyle(color: Colors.grey[700], fontSize: 15)),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            child: Text('Đăng ký ngay', style: TextStyle(color: theme.colorScheme.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Logo and welcome section
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Symbols.shopping_bag_rounded, size: 60, color: theme.colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Chào mừng trở lại!',
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Đăng nhập để tiếp tục mua sắm và khám phá các sản phẩm mới nhất của chúng tôi',
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Form fields
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Đăng nhập', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        _emailTextField(),
                        const SizedBox(height: 16),
                        _passwordTextField(),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Forgot password functionality
                            },
                            child: Text(
                              'Quên mật khẩu?',
                              style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _loginButton(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  _signupButton(context),

                  const SizedBox(height: 32),
                  // Social login options (placeholder)
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Hoặc đăng nhập với', style: TextStyle(color: Colors.grey[600])),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialLoginButton(icon: Icons.facebook, color: const Color(0xFF3b5998)),
                      const SizedBox(width: 20),
                      _socialLoginButton(icon: Icons.g_mobiledata, color: const Color(0xFFDB4437)),
                      const SizedBox(width: 20),
                      _socialLoginButton(icon: Icons.apple, color: Colors.black),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialLoginButton({required IconData icon, required Color color}) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
