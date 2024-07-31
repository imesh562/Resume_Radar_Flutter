import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/service/dependency_injection.dart';
import '../../../../flavors/flavor_config.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_dimensions.dart';
import '../../../../utils/app_images.dart';
import '../../../../utils/navigation_routes.dart';
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
  String version = '';

  late AnimationController _controller;
  late AnimationController _controller1;
  late Animation<Offset> _animation;
  late Animation<Offset> _animation1;

  @override
  void initState() {
    getPackageVersion();
    if (appSharedData.hasAppToken()) {
      bloc.add(AuthUserEvent(
        shouldShowProgress: false,
        isSplashView: true,
      ));
    } else {
      Future.delayed(const Duration(milliseconds: 2250)).then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.kLoginView, (route) => false);
      });
    }
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<Offset>(
      begin: const Offset(-0.5, -0.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Smooth transition
      ),
    );
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation1 = Tween<Offset>(
      begin: const Offset(0.5, 0.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller1,
        curve: Curves.easeInOut, // Smooth transition
      ),
    );

    _controller.forward();
    _controller1.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller1.dispose();
    super.dispose();
  }

  getPackageVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      body: BlocProvider<UserBloc>(
        create: (_) => bloc,
        child: BlocListener<UserBloc, BaseState<UserState>>(
          listener: (_, state) {
            if (state is AuthUserSuccessState) {
              Future.delayed(const Duration(milliseconds: 1250)).then((value) {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.kDashboardView, (route) => false);
              });
            }
          },
          child: SizedBox.expand(
            child: Stack(
              children: [
                SlideTransition(
                  position: _animation,
                  child: Image.asset(
                    AppImages.preLoginBg1,
                    height: 347.h,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: SlideTransition(
                    position: _animation1,
                    child: Image.asset(
                      AppImages.preLoginBg2,
                      height: 432.h,
                    ),
                  ),
                ),
                Center(
                  child: Image.asset(
                    AppImages.appIcon,
                    width: 205.w,
                  ),
                ),
                if (!FlavorConfig.isProduction())
                  Padding(
                    padding: EdgeInsets.only(bottom: 30.h),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'v$version',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: AppDimensions.kFontSize14,
                          color: AppColors.colorBlack,
                        ),
                      ),
                    ),
                  ),
              ],
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
