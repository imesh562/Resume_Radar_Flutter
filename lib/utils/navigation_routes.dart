import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:resume_radar/features/presentation/views/sign_up/sign_up_step1.dart';

import '../features/presentation/views/dashboard/dashboard_view.dart';
import '../features/presentation/views/login/login_view.dart';
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
            child: SignUpStep1(), type: PageTransitionType.fade);
      case Routes.kSignUpStep2:
        return PageTransition(
            child: SignUpStep2(
              signUpStep2Args: settings.arguments as SignUpStep2Args,
            ),
            type: PageTransitionType.fade);
      case Routes.kSignUpStep3:
        return PageTransition(
            child: SignUpStep3(
              signUpStep3Args: settings.arguments as SignUpStep3Args,
            ),
            type: PageTransitionType.fade);
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
