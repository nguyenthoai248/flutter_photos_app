import 'package:photos_app/bloc/photo_bloc.dart';
import 'package:photos_app/bloc/photo_event.dart';

class PhotoViewModel {
  final PhotoBloc bloc;

  PhotoViewModel(this.bloc);

  void loadMore() => bloc.add(FetchPhotos());
}
