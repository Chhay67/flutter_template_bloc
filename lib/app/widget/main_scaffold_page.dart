


import 'package:flutter/material.dart';

import '../route/routes.dart';

class MainScaffoldPage extends StatelessWidget {
  const MainScaffoldPage({
    super.key,
    required this.child,this.initNavBarIndex,
  });
  final Widget child;
  final int? initNavBarIndex;

  static const tabs = [
    (icon: Icons.dashboard_outlined, label: 'Dashboard', route: Routes.dashboard),
    (icon: Icons.settings_outlined, label: 'Settings', route: Routes.settings),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
