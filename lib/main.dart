import 'package:appgestiontache/list_tache.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(

      title: 'AGT',

      debugShowCheckedModeBanner: false,

      home: MyTacheList(),

    );
  }
}