import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template_bloc/features/dashboard/presentation/bloc/user_profile_cubit/user_profile_cubit.dart';

import '../bloc/products_cubit/products_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [ProfileView(), ProductsListView()]),
    );
  }
}

class ProductsListView extends StatelessWidget {
  const ProductsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductError) {
          return TextButton(
            onPressed: () {},
            child: Text(
              state.message,
              style: TextStyle(color: Colors.redAccent),
            ),
          );
        }

        if (state is ProductsLoaded) {
          return Column(
            children: [
              Text('Products'),
              if (state.products.isEmpty)
                Text(
                  'empty products.',
                  style: TextStyle(color: Colors.redAccent),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text(product.description),
                    );
                  },
                ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        if (state is UserProfileError) {
          return TextButton(
            onPressed: () {},
            child: Text(
              state.message,
              style: TextStyle(color: Colors.redAccent),
            ),
          );
        }

        if (state is UserProfileLoaded) {
          return Text('User Profile ${state.user.name}');
        }

        return const SizedBox.shrink();
      },
    );
  }
}
