import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const DemoTestApp());
}

class DemoTestApp extends StatelessWidget {
  const DemoTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(title: 'Demo', theme: AppTheme.light, routerConfig: router, debugShowCheckedModeBanner: false);
  }
}
