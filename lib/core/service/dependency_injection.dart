import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:resume_radar/features/presentation/bloc/otp/otp_bloc.dart';
import 'package:resume_radar/features/presentation/bloc/quiz/quiz_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/data/datasources/remote_data_source.dart';
import '../../features/data/datasources/shared_preference.dart';
import '../../features/data/repositories/repository_impl.dart';
import '../../features/domain/repositories/repository.dart';
import '../../features/presentation/bloc/user/user_bloc.dart';
import '../network/api_helper.dart';
import '../network/network_info.dart';
import 'cloud_services.dart';
import 'cloud_services_impl.dart';

final injection = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  injection.registerLazySingleton(() => sharedPreferences);
  injection.registerSingleton(AppSharedData(injection()));

  injection.registerSingleton(CloudServicesImpl(injection()));
  injection.registerSingleton(Dio());
  injection.registerLazySingleton<APIHelper>(
      () => APIHelper(dio: injection(), appSharedData: injection()));
  injection
      .registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(injection()));
  injection.registerLazySingleton(() => Connectivity());
  injection.registerSingleton(CloudServices(injection(), injection()));

  ///Repository
  injection.registerLazySingleton<Repository>(
    () =>
        RepositoryImpl(remoteDataSource: injection(), networkInfo: injection()),
  );

  ///Data sources
  injection.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(
        apiHelper: injection(), appSharedData: injection()),
  );

  ///Blocs

  injection.registerFactory(
    () => UserBloc(appSharedData: injection(), repository: injection()),
  );

  injection.registerFactory(
    () => OtpBloc(appSharedData: injection(), repository: injection()),
  );

  injection.registerFactory(
    () => QuizBloc(appSharedData: injection(), repository: injection()),
  );
}
