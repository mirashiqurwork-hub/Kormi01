import 'package:flutter/material.dart';
import 'main_navigation_screen.dart';

class MainScreen extends StatelessWidget {
  final void Function(int)? onNavigate;

  const MainScreen({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return const MainNavigationScreen();
  }
}
