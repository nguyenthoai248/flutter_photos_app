import 'package:photos_app/models/photo.dart';
import 'package:photos_app/services/photo_api_service.dart';

class PhotoRepository {
  final PhotoApiService api;

  PhotoRepository(this.api);

  Future<List<Photo>> getPhotos(int page, int limit) {
    return api.fetchPhotos(page, limit);
  }
}
