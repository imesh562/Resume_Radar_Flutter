import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resume_radar/features/presentation/common/appbar.dart';
import 'package:sharpapi_flutter_client/src/hr/models/parse_resume_model.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../bloc/user/user_bloc.dart';
import '../base_view.dart';

class MockInterviewView extends BaseView {
  final ParseResumeModel resumeData;
  MockInterviewView({
    super.key,
    required this.resumeData,
  });
  @override
  State<MockInterviewView> createState() => _MockInterviewViewState();
}

class _MockInterviewViewState extends BaseViewState<MockInterviewView> {
  var bloc = injection<UserBloc>();

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: ResumeRadarAppBar(
        title: 'Mock Interview',
      ),
      backgroundColor: AppColors.colorWhite,
      body: BlocProvider<UserBloc>(
        create: (_) => bloc,
        child: BlocListener<UserBloc, BaseState<UserState>>(
          listener: (_, state) {},
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}
