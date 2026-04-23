import 'package:bloc/bloc.dart';
import 'package:photos_app/bloc/photo_event.dart';
import 'package:photos_app/bloc/photo_state.dart';
import 'package:photos_app/repository/photo_repository.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotoRepository repository;

  static const int _limit = 20;

  PhotoBloc(this.repository) : super(PhotoState.initial()) {
    on<FetchPhotos>(_onFetchPhotos);
  }

  Future<void> _onFetchPhotos(
    FetchPhotos event,
    Emitter<PhotoState> emit,
  ) async {
    if (state.isLoading || !state.hasMore) return;

    emit(state.copyWith(isLoading: true));

    try {
      final newPhotos = await repository.getPhotos(state.page, _limit);

      emit(
        state.copyWith(
          photos: [...state.photos, ...newPhotos],
          isLoading: false,
          hasMore: newPhotos.length == _limit,
          page: state.page + 1,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
