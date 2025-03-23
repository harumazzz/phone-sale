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
        LoginEvent(
          data: LoginRequest(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        ),
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

    if (state is AuthLogin) {
      await toHome();
    }
    if (state is AuthLoginFailed) {
      await showDialog(title: 'Đăng nhập thất bại', content: state.message);
    }
  }

  Widget _emailTextField() {
    return TextFormField(
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
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
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
    );
  }

  Widget _loginButton() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: _onListener,
      builder: (context, state) {
        if (state is AuthLoading) {
          return const CircularProgressIndicator();
        }
        return ElevatedButton(
          onPressed: _onLogIn,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Đăng nhập'),
        );
      },
    );
  }

  Widget _signupButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignupScreen()),
        );
      },
      child: const Text('Đăng ký tài khoản'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Symbols.shopping_cart,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text(
                  'Đăng Nhập',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _emailTextField(),
                _passwordTextField(),
                const SizedBox(height: 16),
                _loginButton(),
                _signupButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
