import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../features/presentation/views/dashboard/dashboard_view.dart';
import '../features/presentation/views/login/login_view.dart';
import '../features/presentation/views/splash/splash_view.dart';

class Routes {
  static const String kSplashView = "kSplashView";
  static const String kDashboardView = "kDashboardView";
  static const String kLoginView = "kLoginView";

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
