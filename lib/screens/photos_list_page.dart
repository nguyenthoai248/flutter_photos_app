import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:photos_app/screens/photo_detail_page.dart';

class PhotosListPage extends StatefulWidget {
  @override
  _PhotosListPageState createState() => _PhotosListPageState();
}

class _PhotosListPageState extends State<PhotosListPage> {
  List<dynamic> photos = [];
  bool isLoading = false;
  bool hasMore = true;
  int page = 1;
  final int limit = 20;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchPhotos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        fetchPhotos();
      }
    });
  }

  Future<void> fetchPhotos() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Dio().get(
        'https://jsonplaceholder.typicode.com/photos',
        queryParameters: {'_page': page, '_limit': limit},
      );
      final List<dynamic> fetchedPhotos = response.data;
      setState(() {
        photos.addAll(fetchedPhotos);
        isLoading = false;
        hasMore = fetchedPhotos.length == limit;
        if (hasMore) page++;
      });
    } catch (e) {
      print('Error fetching photos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Photos List')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: photos.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == photos.length) {
            return Center(child: CircularProgressIndicator());
          }
          return ListTile(
            leading: Image.network(
              photos[index]['thumbnailUrl'].toString().replaceAll(
                'via.placeholder.com',
                'dummyimage.com',
              ),
            ),
            title: Text(photos[index]['title']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoDetailPage(photo: photos[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
