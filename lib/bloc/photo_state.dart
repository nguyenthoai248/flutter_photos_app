import 'package:photos_app/models/photo.dart';

class PhotoState {
  final List<Photo> photos;
  final bool isLoading;
  final bool hasMore;
  final int page;

  PhotoState({
    required this.photos,
    required this.isLoading,
    required this.hasMore,
    required this.page,
  });

  factory PhotoState.initial() {
    return PhotoState(photos: [], isLoading: false, hasMore: true, page: 1);
  }

  PhotoState copyWith({
    List<Photo>? photos,
    bool? isLoading,
    bool? hasMore,
    int? page,
  }) {
    return PhotoState(
      photos: photos ?? this.photos,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}
