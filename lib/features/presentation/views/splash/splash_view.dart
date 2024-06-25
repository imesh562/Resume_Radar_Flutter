import 'package:flutter/material.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../bloc/user/user_bloc.dart';
import '../base_view.dart';

class SplashView extends BaseView {
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends BaseViewState<SplashView>
    with TickerProviderStateMixin {
  var bloc = injection<UserBloc>();

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.colorWhite, body: Container());
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}
