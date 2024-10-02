import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resume_radar/utils/app_colors.dart';
import 'package:resume_radar/utils/app_dimensions.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../utils/app_images.dart';
import '../../../data/models/responses/get_questions_data_responses.dart';
import '../../../data/models/responses/get_quizzes_response.dart';
import '../../bloc/base_bloc.dart';
import '../../bloc/base_event.dart';
import '../../bloc/base_state.dart';
import '../../bloc/quiz/quiz_bloc.dart';
import '../../common/appbar.dart';
import '../base_view.dart';

class QuizView extends BaseView {
  final Quiz quizData;

  QuizView({required this.quizData, Key? key});

  @override
  _QuizViewState createState() => _QuizViewState();
}

class _QuizViewState extends BaseViewState<QuizView> {
  final bloc = injection<QuizBloc>();
  int currentQuestionIndex = 0;
  Map<int, String> userAnswers = {};
  int score = 0;
  bool quizCompleted = false;
  List<Question> questions = [];

  @override
  void initState() {
    super.initState();
    bloc.add(GetQuestionDataEvent(questionsId: widget.quizData.id.toString()));
  }

  @override
  Widget buildView(BuildContext context) {
    return BlocProvider<QuizBloc>(
      create: (_) => bloc,
      child: BlocListener<QuizBloc, BaseState<QuizState>>(
        listener: (_, state) {
          if (state is GetQuestionsDataSuccessState) {
            setState(() {
              questions.clear();
              questions.addAll(state.questionData.questions ?? []);
            });
          }
        },
        child: Scaffold(
          appBar: ResumeRadarAppBar(
            title: widget.quizData.title ?? "Quiz",
          ),
          body: Stack(
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
              questions.isNotEmpty
                  ? (quizCompleted ? _buildQuizSummary() : _buildQuizQuestion())
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizQuestion() {
    final currentQuestion = questions[currentQuestionIndex];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.colorImagePlaceholder.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Question ${currentQuestionIndex + 1} of ${questions.length}",
                          style: TextStyle(
                            fontSize: AppDimensions.kFontSize15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      currentQuestion.questionText ?? "",
                      style: TextStyle(
                        fontSize: AppDimensions.kFontSize20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.matteBlack,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildOptionButton(currentQuestion.options?.a, "a"),
                    _buildOptionButton(currentQuestion.options?.b, "b"),
                    _buildOptionButton(currentQuestion.options?.c, "c"),
                    _buildOptionButton(currentQuestion.options?.d, "d"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton(String? optionText, String optionKey) {
    return InkWell(
      onTap: () {
        _submitAnswer(optionText!);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.colorWhite,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkGrey.withOpacity(0.33),
              offset: const Offset(0, 4),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        margin: EdgeInsets.only(bottom: 10.h),
        child: Text(
          '${optionKey.toUpperCase()}. ${optionText ?? ""}',
          style: TextStyle(
            fontSize: AppDimensions.kFontSize16,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryGreen,
          ),
        ),
      ),
    );
  }

  Widget _buildQuizSummary() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.colorImagePlaceholder.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Quiz Completed!',
                          style: TextStyle(
                            fontSize: AppDimensions.kFontSize22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.matteBlack,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        CircleAvatar(
                          radius: 60.r,
                          backgroundColor: AppColors.primaryGreen,
                          child: Text(
                            '$score',
                            style: TextStyle(
                              fontSize: AppDimensions.kFontSize42,
                              fontWeight: FontWeight.w400,
                              color: AppColors.colorWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: AppDimensions.kFontSize20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.matteBlack,
                    ),
                  ),
                  ListView.builder(
                    itemCount: questions.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      final userAnswer = userAnswers[question.id!];

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Q${index + 1}: ${question.questionText}",
                              style: TextStyle(
                                fontSize: AppDimensions.kFontSize18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.matteBlack,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              "Your Answer: ${userAnswer ?? "Not Answered"}",
                              style: TextStyle(
                                fontSize: AppDimensions.kFontSize16,
                                color: userAnswer == question.correctAnswer
                                    ? AppColors.primaryGreen
                                    : AppColors.errorRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Correct Answer: ${question.correctAnswer}",
                              style: TextStyle(
                                fontSize: AppDimensions.kFontSize16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.waitingTimeColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitAnswer(String selectedAnswer) {
    final currentQuestion = questions[currentQuestionIndex];
    userAnswers[currentQuestion.id!] = selectedAnswer;

    if (selectedAnswer == currentQuestion.correctAnswer) {
      score += (100 / questions.length).round();
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      setState(() {
        quizCompleted = true;
      });
    }
  }

  @override
  Base<BaseEvent, BaseState> getBloc() {
    return bloc;
  }
}
