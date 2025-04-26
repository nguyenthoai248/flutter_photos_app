import 'package:flutter/material.dart';

class PhotoDetailPage extends StatelessWidget {
  final dynamic photo;

  PhotoDetailPage({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo Detail')),
      body: Column(
        children: [
          Image.network(
            photo['url'].toString().replaceAll(
              'via.placeholder.com',
              'dummyimage.com',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              photo['title'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
