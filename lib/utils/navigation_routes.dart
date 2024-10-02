import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:resume_radar/features/data/models/responses/get_quizzes_response.dart';
import 'package:resume_radar/features/presentation/views/sign_up/sign_up_step1.dart';
import 'package:sharpapi_flutter_client/src/hr/models/parse_resume_model.dart';

import '../features/presentation/views/dashboard/dashboard_view.dart';
import '../features/presentation/views/interview_results/interview_results_view.dart';
import '../features/presentation/views/login/login_view.dart';
import '../features/presentation/views/mock_interview_cv_scan/mock_interview_cv_scan_view.dart';
import '../features/presentation/views/mock_interview_view/mock_interview_view.dart';
import '../features/presentation/views/quiz_list/quiz_list_view.dart';
import '../features/presentation/views/quiz_view/quiz_view.dart';
import '../features/presentation/views/recommendations_&_other/recommendations_&_other_info_view.dart';
import '../features/presentation/views/resume_analyzer/resume_analyzer_view.dart';
import '../features/presentation/views/sign_up/sign_up_step2.dart';
import '../features/presentation/views/sign_up/sign_up_step3.dart';
import '../features/presentation/views/splash/splash_view.dart';
import '../features/presentation/views/success_view/success_view.dart';

class Routes {
  static const String kSplashView = "kSplashView";
  static const String kDashboardView = "kDashboardView";
  static const String kLoginView = "kLoginView";
  static const String kSuccessView = "kSuccessView";
  static const String kSignUpStep1 = "kSignUpStep1";
  static const String kSignUpStep2 = "kSignUpStep2";
  static const String kSignUpStep3 = "kSignUpStep3";
  static const String kResumeAnalyzerView = "kResumeAnalyzerView";
  static const String kRecommendationAndOtherInfoView =
      "kRecommendationAndOtherInfoView";
  static const String kMockInterviewCvScanView = "kMockInterviewCvScanView";
  static const String kMockInterviewView = "kMockInterviewView";
  static const String kInterviewResultsView = "kInterviewResultsView";
  static const String kQuizzesView = "kQuizzesView";
  static const String kQuizView = "kQuizView";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.kSplashView:
        return PageTransition(
            child: SplashView(), type: PageTransitionType.fade);
      case Routes.kDashboardView:
        return PageTransition(
            child: DashboardView(), type: PageTransitionType.fade);
      case Routes.kLoginView:
        return PageTransition(
            child: LoginView(), type: PageTransitionType.fade);
      case Routes.kSuccessView:
        return PageTransition(
            child: SuccessView(
              successViewArgs: settings.arguments as SuccessViewArgs,
            ),
            type: PageTransitionType.fade);
      case Routes.kSignUpStep1:
        return PageTransition(
            child: SignUpStep1View(), type: PageTransitionType.fade);
      case Routes.kSignUpStep2:
        return PageTransition(
            child: SignUpStep2View(
              signUpStep2Args: settings.arguments as SignUpStep2Args,
            ),
            type: PageTransitionType.fade);
      case Routes.kSignUpStep3:
        return PageTransition(
            child: SignUpStep3View(
              signUpStep3Args: settings.arguments as SignUpStep3Args,
            ),
            type: PageTransitionType.fade);
      case Routes.kResumeAnalyzerView:
        return PageTransition(
            child: ResumeAnalyzerView(
              resumeAnalyzerViewArgs:
                  settings.arguments as ResumeAnalyzerViewArgs,
            ),
            type: PageTransitionType.fade);
      case Routes.kRecommendationAndOtherInfoView:
        return PageTransition(
            child: RecommendationAndOtherInfoView(
              resumeData: settings.arguments as ParseResumeModel,
            ),
            type: PageTransitionType.fade);
      case Routes.kMockInterviewCvScanView:
        return PageTransition(
            child: MockInterviewCvScanView(), type: PageTransitionType.fade);
      case Routes.kMockInterviewView:
        return PageTransition(
            child: MockInterviewView(
              resumeData: settings.arguments as ParseResumeModel,
            ),
            type: PageTransitionType.fade);
      case Routes.kInterviewResultsView:
        return PageTransition(
          child: InterviewResultsView(
            responseJson: settings.arguments as Map<String, dynamic>,
          ),
          type: PageTransitionType.fade,
        );
      case Routes.kQuizzesView:
        return PageTransition(
          child: QuizzesView(),
          type: PageTransitionType.fade,
        );
      case Routes.kQuizView:
        return PageTransition(
          child: QuizView(
            quizData: settings.arguments as Quiz,
          ),
          type: PageTransitionType.fade,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("Invalid Route"),
            ),
          ),
        );
    }
  }
}
