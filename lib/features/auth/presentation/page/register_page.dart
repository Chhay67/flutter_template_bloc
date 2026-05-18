import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template_bloc/core/di/init_dependencies.dart';
import 'package:flutter_template_bloc/features/auth/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/route/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snack_bar.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  void _register({required BuildContext context}) {
    final name = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty) {
      AppSnackBar.showError(context,message: 'Name is required');
      return;
    }
    if (username.isEmpty) {
      AppSnackBar.showError(context,message: 'Username is required');
      return;
    }
    if (password.isEmpty || password.length < 6) {
      AppSnackBar.showError(context,message: 'Password must be at least 6 characters');

      return;
    }
    if (!_agreeToTerms) {
      AppSnackBar.showError(context,message: 'You must agree to the Terms to create an account');
      return;
    }

    context.read<RegisterCubit>().register(name: name, userName: username, password: password);
  }


  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (_) => serviceLocator<RegisterCubit>(),
      child: BlocListener<RegisterCubit, RegisterState>(listener: (context, state) {
        if(state is RegisterSuccess){
          AppSnackBar.showSuccess(context, message:"Account created successfully.");
          context.pop();
        }
        if(state is RegisterError){
          AppSnackBar.showError(context, message: state.message);
        }
      },
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // App Title
                      const Text(
                        'SmartNest',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 40),
                      AuthCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Sign up to get started',
                              style: TextStyle(fontSize: 14, color: AppColors.hint),
                            ),
                            const SizedBox(height: 24),
                            AuthTextField(
                              hintText: 'Name',
                              controller: _nameController,
                            ),
                            const SizedBox(height: 16),
                            AuthTextField(
                              hintText: 'Username',
                              controller: _usernameController,
                            ),
                            const SizedBox(height: 16),
                            AuthTextField(
                              hintText: 'Password',
                              controller: _passwordController,
                              isPassword: true,
                              obscureText: _obscurePassword,
                              onToggleVisibility: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Checkbox(
                                    value: _agreeToTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        _agreeToTerms = value ?? false;
                                      });
                                    },
                                    activeColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'I agree to the Terms and Conditions',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.text,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            PrimaryButton(
                              text: 'Create account',
                              onPressed: () => _register(context: context),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(color: AppColors.text, fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.goNamed(Routes.login.name);
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),),
    );
  }
}
