import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/login/login_view.dart';
import 'package:goasbar/ui/views/splash/splash_viewmodel.dart';
import 'package:goasbar/ui/widgets/splash_clipper.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ViewModelBuilder<SplashViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: screenHeightPercentage(context, percentage: 0.9),
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/splash/splash_img2.png",
                    height: screenHeightPercentage(context, percentage: 0.28),
                  )
                      .translate(
                        offset: !model.isDone
                            ? Offset(size.width + 60 - 150, 70)
                            : Offset(
                                context.locale == const Locale('ar', 'SA')
                                    ? -20
                                    : size.width - 180,
                                70),
                        animate: true,
                      )
                      .opacity(!model.isDone ? 0.0 : 1.0, animate: true)
                      .animate(
                          const Duration(milliseconds: 1000), Curves.easeIn),
                  Image.asset(
                    "assets/images/splash/splash_img3.png",
                  )
                      .translate(
                        offset: !model.isDone
                            ? const Offset(65, 280)
                            : Offset(
                                context.locale == const Locale('ar', 'SA')
                                    ? -60
                                    : 65,
                                210),
                        animate: true,
                      )
                      .opacity(!model.isDone ? 0.0 : 1.0, animate: true)
                      .animate(
                          const Duration(milliseconds: 1000), Curves.easeIn),
                  Image.asset(
                    "assets/images/splash/splash_img1.png",
                    height: screenHeightPercentage(context, percentage: 0.3),
                  )
                      .translate(
                        offset: !model.isDone
                            ? const Offset(-60, 100)
                            : Offset(
                                context.locale == const Locale('ar', 'SA')
                                    ? -250
                                    : 20,
                                70),
                        animate: true,
                      )
                      .opacity(!model.isDone ? 0.0 : 1.0, animate: true)
                      .animate(
                          const Duration(milliseconds: 1000), Curves.easeIn),
                  ClipPath(
                    clipper: SplashClipper(),
                    child: Container(
                      height: 50,
                      width: 230,
                      decoration: const BoxDecoration(
                        gradient: kMainGradient,
                      ),
                    ),
                  ).translate(
                      offset: Offset(
                          context.locale == const Locale('ar', 'SA') ? -25 : 95,
                          450)),
                  RichText(
                    text: TextSpan(
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 34,
                            fontFamily: 'Poppins',
                            color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Go Discover".tr(),
                          ),
                          context.locale == const Locale('ar', 'SA')
                              ? const TextSpan(text: "\n")
                              : const TextSpan(
                                  text: "\nThe",
                                ),
                          TextSpan(
                            text: " Saudi Arabia".tr(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: "\nwith Asbar".tr(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ]),
                  )
                      .translate(
                        offset: !model.isDone
                            ? const Offset(-60, 400)
                            : Offset(
                                context.locale == const Locale('ar', 'SA')
                                    ? -30
                                    : 30,
                                400),
                        animate: true,
                      )
                      .opacity(!model.isDone ? 0.0 : 1.0, animate: true)
                      .animate(
                          const Duration(milliseconds: 1000), Curves.easeIn),
                  Text(
                    "splash_text".tr(),
                    style: const TextStyle(
                        color: kMainGray,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  )
                      .translate(
                        offset: !model.isDone
                            ? const Offset(-60, 400)
                            : Offset(
                                context.locale == const Locale('ar', 'SA')
                                    ? -30
                                    : 30,
                                570),
                        animate: true,
                      )
                      .opacity(!model.isDone ? 0.0 : 1.0, animate: true)
                      .animate(
                          const Duration(milliseconds: 1000), Curves.easeIn),
                ],
              ),
            ),
            !model.isDone2
                ? const SizedBox()
                : Container(
                        width: MediaQuery.of(context).size.width - 60,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: 50,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: kMainGradient,
                        ),
                        child: ElevatedButton(
                            onPressed: () async {
                              model.clearStackAndShowView(
                                  view: const LoginView());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: Text(
                              'get_started'.tr(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            )))
                    .opacity(model.isDone2 ? 1 : 0, animate: true)
                    .animate(const Duration(milliseconds: 1000), Curves.easeIn)
          ],
        ),
      ),
      viewModelBuilder: () => SplashViewModel(),
      onViewModelReady: (model) => model.startAnimation(),
    );
  }
}
