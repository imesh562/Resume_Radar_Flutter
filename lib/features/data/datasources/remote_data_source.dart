import 'dart:core';

import 'package:resume_radar/features/data/datasources/shared_preference.dart';

import '../../../core/network/api_helper.dart';

abstract class RemoteDataSource {}

class RemoteDataSourceImpl implements RemoteDataSource {
  final APIHelper apiHelper;
  final AppSharedData appSharedData;

  RemoteDataSourceImpl({required this.apiHelper, required this.appSharedData});
}
