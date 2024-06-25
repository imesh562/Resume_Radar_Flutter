import 'package:flutter/material.dart';

import '../../../data/datasources/shared_preference.dart';
import '../../../domain/repositories/repository.dart';
import '../base_bloc.dart';
import '../base_event.dart';
import '../base_state.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Base<UserEvent, BaseState<UserState>> {
  final AppSharedData appSharedData;
  final Repository repository;
  UserBloc({
    required this.appSharedData,
    required this.repository,
  }) : super(UserInitial()) {}
}
