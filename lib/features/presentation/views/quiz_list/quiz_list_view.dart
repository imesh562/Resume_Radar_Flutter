import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:resume_radar/features/data/models/requests/get_quizzes_request.dart';
import 'package:resume_radar/features/presentation/bloc/base_bloc.dart';
import 'package:resume_radar/features/presentation/bloc/base_event.dart';
import 'package:resume_radar/features/presentation/bloc/base_state.dart';
import 'package:resume_radar/features/presentation/bloc/quiz/quiz_bloc.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/navigation_routes.dart';
import '../../../data/models/responses/get_quizzes_response.dart';
import '../../common/appbar.dart';
import '../base_view.dart';
import 'common/quiz_component.dart';

class QuizzesView extends BaseView {
  QuizzesView({super.key});

  @override
  State<QuizzesView> createState() => _QuizzesViewState();
}

class _QuizzesViewState extends BaseViewState<QuizzesView> {
  final bloc = injection<QuizBloc>();
  List<Quiz> quizList = [];
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController();
  int pageCount = 1;
  int perPage = 10;
  bool pullRefresh = true;
  bool _hasLoaded = true;

  @override
  void initState() {
    super.initState();
    _loadData(shouldRefresh: false);
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: ResumeRadarAppBar(
        title: "Quiz Center",
      ),
      body: BlocProvider<QuizBloc>(
        create: (_) => bloc,
        child: BlocListener<QuizBloc, BaseState<QuizState>>(
          listener: (_, state) {
            if (state is GetQuizzesSuccessState) {
              setState(() {
                _hasLoaded = true;
                if (!state.isRefresh) {
                  quizList.clear();
                  pullRefresh = true;
                }
                quizList.addAll(state.quizzesData.quizzes ?? []);
                if ((state.quizzesData.quizzes ?? []).length < perPage) {
                  pullRefresh = false;
                }
                _refreshController.refreshCompleted();
                _refreshController.loadComplete();
              });
            }
          },
          child: Stack(
            children: [
              Row(
                children: [
                  Image.asset(
                    AppImages.imgBg2,
                    height: 349.h,
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  AppImages.imgBg1,
                  height: 432.h,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  _hasLoaded
                      ? Expanded(
                          child: RawScrollbar(
                            thumbVisibility: true,
                            thumbColor: AppColors.primaryGreen,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18.w),
                              child: SmartRefresher(
                                controller: _refreshController,
                                physics: const BouncingScrollPhysics(),
                                onLoading: () {
                                  setState(() {
                                    pageCount++;
                                  });
                                  _loadData(shouldRefresh: true);
                                },
                                enablePullDown: true,
                                onRefresh: () {
                                  setState(() {
                                    pageCount = 1;
                                  });
                                  _loadData(shouldRefresh: false);
                                },
                                enablePullUp: pullRefresh,
                                child: quizList.isNotEmpty
                                    ? SingleChildScrollView(
                                        controller: _scrollController,
                                        physics: const BouncingScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: quizList.length,
                                              itemBuilder: (context, index) {
                                                final quiz = quizList[index];
                                                return QuizComponent(
                                                  quiz: quiz,
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      Routes.kQuizView,
                                                      arguments: quiz,
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    : Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              AppImages.icEmptyLight,
                                              height: 100.h,
                                            ),
                                            SizedBox(height: 24.h),
                                            Text(
                                              "Currently there are no quizzes",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize:
                                                    AppDimensions.kFontSize14,
                                                color: AppColors.lightGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadData({required bool shouldRefresh}) {
    bloc.add(
      GetQuizzesEvent(
        isRefresh: shouldRefresh,
        getQuizzesRequest: GetQuizzesRequest(
          sort: "created_at",
          perPage: perPage,
          page: pageCount,
        ),
      ),
    );
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}
