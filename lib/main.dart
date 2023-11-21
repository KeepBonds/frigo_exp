import 'package:flutter/material.dart';
import 'package:frigo_exp/pages/FridgeAddScreen.dart';
import 'package:frigo_exp/objects/FridgeProduct.dart';
import 'package:frigo_exp/pages/HomePage.dart';
import 'manager/FridgeManager.dart';
import 'cache/StorageManager.dart';

void main() async {
  StorageManager manager = StorageManager.init();
  await manager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

