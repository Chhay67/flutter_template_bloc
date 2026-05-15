import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template_bloc/features/auth/presentation/cubit/login_cubit/login_cubit.dart';

import '../../../../core/di/init_dependencies.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => serviceLocator<LoginCubit>(),
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text('Login Page')),
            body: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<LoginCubit>().login(
                      email: 'example@example.com',
                      password: "secret123",
                    );
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
