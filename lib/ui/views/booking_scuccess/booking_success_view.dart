import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/booking_scuccess/booking_success_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BookingSuccessView extends HookWidget {
  const BookingSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BookingSuccessViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Column(
                  children: [
                    Image.asset("assets/icons/booking_success.png"),
                    const Text('Booking \nSuccess', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,)),
                    verticalSpaceSmall,
                    const Text('Thank you for choosing Goasbar in your experince',),
                  ],
                ),
                const Spacer(),
                const Text('We have sent an invoice to your email, please \nmake a payment no later than 2x24 hours',),
                verticalSpaceLarge,
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: kMainGradient,
                  ),
                  child: const Text('Go to my booking', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),).center(),
                ).gestures(
                  onTap:  () {

                  },
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => BookingSuccessViewModel(),
    );
  }
}