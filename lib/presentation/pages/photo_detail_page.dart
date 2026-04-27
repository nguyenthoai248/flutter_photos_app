import 'package:flutter/material.dart';
import 'package:photos_app/models/photo.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PhotoDetailPage extends StatelessWidget {
  final Photo photo;

  const PhotoDetailPage({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photo Detail')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: CachedNetworkImage(
              imageUrl: photo.url.replaceAll(
                'via.placeholder.com',
                'dummyimage.com',
              ),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 250),
              placeholder:
                  (context, url) => Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Icon(Icons.error),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              photo.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
