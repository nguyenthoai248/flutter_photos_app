import 'package:dio/dio.dart';
import 'package:photos_app/models/photo.dart';

class PhotoApiService {
  final Dio dio;

  PhotoApiService(this.dio);

  Future<List<Photo>> fetchPhotos(int page, int limit) async {
    final response = await dio.get(
      'https://jsonplaceholder.typicode.com/photos',
      queryParameters: {'_page': page, '_limit': limit},
      options: Options(
        headers: {'User-Agent': 'Mozilla/5.0', 'Accept': 'application/json'},
      ),
    );

    return (response.data as List).map((e) => Photo.fromJson(e)).toList();
  }
}
