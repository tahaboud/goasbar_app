import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/booking_model.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/services/booking_api_service.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/home/home_view.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutView extends StatefulHookWidget {
  const CheckoutView(
      {super.key,
      this.booking,
      this.experience,
      this.user,
      this.usersCount,
      this.paymentUrl});
  final ExperienceResults? experience;
  final UserModel? user;
  final BookingModel? booking;
  final int? usersCount;
  final String? paymentUrl;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  late final WebViewController controller;
  final _bookingApiService = locator<BookingApiService>();
  final _navigationService = locator<NavigationService>();
  final RegExp regex = RegExp(r"\d+");

  @override
  void initState() {
    super.initState();
    final Map<String, String> headers = {
      "Authorization": "Token ${widget.booking?.tokensd}"
    };
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith('https://goasbar.com')) {
              bool? bookingState = await _bookingApiService.getPaymentStatus(
                  context: context,
                  token: widget.booking?.tokensd,
                  bookingId: widget.booking?.response?.id);
              if (bookingState!) {
                if (context.mounted) {
                  Navigator.pop(context);

                  _navigationService.clearTillFirstAndShowView(const HomeView(
                    isUser: true,
                    index: 2,
                  ));
                  showMotionToast(
                      context: context,
                      title: tr("Booking Confirmed"),
                      msg: tr("Your booking has been successfully confirmed."),
                      type: MotionToastType.success);
                }
              } else {
                if (context.mounted) {
                  Navigator.pop(context);
                  showMotionToast(
                      context: context,
                      title: tr("Payment failed"),
                      msg: tr("Your payment was not successfull."),
                      type: MotionToastType.error);
                }
              }
            } else if (request.url
                .startsWith("https://secure.clickpay.com.sa/")) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl as String), headers: headers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller),
    );
  }
}
