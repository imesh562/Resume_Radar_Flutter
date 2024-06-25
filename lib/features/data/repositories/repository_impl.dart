import '../../../core/network/network_info.dart';
import '../../domain/repositories/repository.dart';
import '../datasources/remote_data_source.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  RepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
}
