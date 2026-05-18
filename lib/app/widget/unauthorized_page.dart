import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../route/routes.dart';

class UnauthorizedPage extends StatelessWidget {
  const UnauthorizedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unauthorized')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'You do not have permission to access this page.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.goNamed(Routes.dashboard.name),
                  child: const Text('Go Dashboard'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
