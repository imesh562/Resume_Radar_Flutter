import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../bloc/user/user_bloc.dart';
import '../base_view.dart';

class DashboardView extends BaseView {
  DashboardView({super.key});
  @override
  State<DashboardView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends BaseViewState<DashboardView> {
  var bloc = injection<UserBloc>();

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body: BlocProvider<UserBloc>(
        create: (_) => bloc,
        child: BlocListener<UserBloc, BaseState<UserState>>(
          listener: (_, state) {},
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: []),
        ),
      ),
    );
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}
