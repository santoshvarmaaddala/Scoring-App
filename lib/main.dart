import 'package:flutter/material.dart';
import 'core/features/dashboard/dashboard_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DashboardScreen(),
    ),
  );
}
