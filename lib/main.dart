// lib/main.dart

import 'package:flutter/material.dart';
import 'package:velocimax2000/views/velocimetro_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Velocímetro',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const VelocimetroView(),
      debugShowCheckedModeBanner: false,
    );
  }
}