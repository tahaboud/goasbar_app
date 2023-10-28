import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/data_models/booking_model.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/services/booking_api_service.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/navbar/trips/trips_view.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutView extends StatefulHookWidget {
  const CheckoutView(
      {Key? key, this.booking, this.experience, this.user, this.usersCount})
      : super(key: key);
  final ExperienceResults? experience;
  final UserModel? user;
  final BookingModel? booking;
  final int? usersCount;

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
            if (request.url.startsWith('https://www.goasbar.com/booking/')) {
              String paymentId = request.url.split("?")[1].split("&")[0];
              bool? bookingState = await _bookingApiService.getPaymentStatus(
                  context: context,
                  token: widget.booking?.tokensd,
                  bookingId: widget.booking?.response?.id,
                  paymentId: paymentId);
              if (bookingState!) {
                if (context.mounted) {
                  Navigator.pop(context);

                  _navigationService.navigateToView(TripsView(
                    text: "Trips".tr(),
                    user: widget.user,
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
            } else if (request.url.startsWith("https://oppwa.com") ||
                request.url.startsWith("https://eu-prod.oppwa.com")) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(
          Uri.parse(
              'https://www.goasbar.com/booking/payment/app/${widget.booking?.response?.id}/'),
          headers: headers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller),
    );
  }
}
