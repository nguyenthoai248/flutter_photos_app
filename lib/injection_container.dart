import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:photos_app/repository/photo_repository.dart';
import 'package:photos_app/services/photo_api_service.dart';

final getIt = GetIt.instance;
void setupDI() {
  getIt.registerLazySingleton(() => Dio());

  getIt.registerLazySingleton(() => PhotoApiService(getIt()));

  getIt.registerLazySingleton(() => PhotoRepository(getIt()));
}
