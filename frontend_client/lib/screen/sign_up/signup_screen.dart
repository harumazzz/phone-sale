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
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        ),
      );
    }

    Future<void> showDialog({
      required String title,
      required String content,
    }) async {
      await UIHelper.showSimpleDialog(
        context: context,
        title: title,
        content: content,
      );
    }

    if (state is AuthRegister) {
      await showDialog(
        title: 'Đăng ký thành công',
        content: 'Đăng nhập để sử dụng',
      );
      await toLogin();
    }
    if (state is AuthRegisterFailed) {
      await showDialog(title: 'Đăng ký thất bại', content: state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký tài khoản'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16.0,
              children: <Widget>[
                Icon(
                  Icons.person_add,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text(
                  'Tạo tài khoản mới',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Symbols.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Họ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Symbols.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập họ';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Symbols.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Symbols.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Xác nhận mật khẩu',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Symbols.lock),
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
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Symbols.home),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập địa chỉ';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Symbols.phone),
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
                const SizedBox(height: 16),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: _onListener,
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: _onRegister,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Đăng ký'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
