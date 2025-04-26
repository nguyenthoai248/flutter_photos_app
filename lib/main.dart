import 'package:flutter/material.dart';
import 'screens/photos_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photos App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PhotosListPage(),
    );
  }
}
