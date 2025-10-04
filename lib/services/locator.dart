import 'package:get_it/get_it.dart';
import 'package:ybt_match/services/auth_service.dart';
import 'package:ybt_match/services/firestore_service.dart';
import 'package:ybt_match/services/storage_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => StorageService());
}
