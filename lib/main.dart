import 'package:flutter/material.dart';
import 'package:photos_app/injection_container.dart';
import 'presentation/pages/photos_list_page.dart';

void main() {
  setupDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photos App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PhotosListPage(),
    );
  }
}
