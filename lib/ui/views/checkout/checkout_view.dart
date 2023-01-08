import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/booking_scuccess/booking_success_view.dart';
import 'package:goasbar/ui/views/checkout/checkout_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CheckoutView extends HookWidget {
  const CheckoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CheckoutViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                verticalSpaceRegular,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_back_sharp).height(40)
                        .width(40)
                        .gestures(
                        onTap: () {
                          model.back();
                        }
                    ),
                    const Text('Checkout', style: TextStyle(fontSize: 21),),
                  ],
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("assets/icons/checkout/visa_method.png", width: screenWidthPercentage(context, percentage: 1/5.5),),
                    Image.asset("assets/icons/checkout/master_card.png", width: screenWidthPercentage(context, percentage: 1/5.5),),
                    Image.asset("assets/icons/checkout/paypal.png", width: screenWidthPercentage(context, percentage: 1/5.5),),
                    Image.asset("assets/icons/checkout/apple_pay.png", width: screenWidthPercentage(context, percentage: 1/5.5),),
                    Image.asset("assets/icons/checkout/stripe.png", width: screenWidthPercentage(context, percentage: 1/5.5),),
                  ],
                ),
                verticalSpaceMedium,
                Container(
                  // height: 100,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kTextFiledMainColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Card Number', style: TextStyle(fontSize: 12),),
                      verticalSpaceSmall,
                      Text('8585 9595 7575 6565', style: TextStyle(fontSize: 18),),
                    ],
                  ),
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // height: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      width: screenWidthPercentage(context, percentage: 0.4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: kTextFiledMainColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Expiry Date', style: TextStyle(fontSize: 12),),
                          verticalSpaceSmall,
                          Text('08/24', style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    ),
                    Container(
                      // height: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      width: screenWidthPercentage(context, percentage: 0.4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: kTextFiledMainColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('CVV', style: TextStyle(fontSize: 12),),
                          verticalSpaceSmall,
                          Text('000', style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                Container(
                  height: 180,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/ticket.png")
                    ),
                  ),
                  child: Column(
                    children: [
                      verticalSpaceMedium,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Ticket price', style: TextStyle(fontSize: 16)),
                          Text('4000.00 SR', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      verticalSpaceRegular,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Fare tax', style: TextStyle(fontSize: 16)),
                          Text('00.00 SR', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      verticalSpaceLarge,
                      verticalSpaceTiny,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Total amount', style: TextStyle(fontSize: 16)),
                          Text('4000.00 SR', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
                verticalSpaceLarge,
                const Text('Payment terms and conditions', style: TextStyle(color: Color(0xff223263)),),
                verticalSpaceRegular,
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: kMainGradient,
                  ),
                  child: const Text('Continue with payment', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),).center(),
                ).gestures(
                  onTap:  () {
                    model.navigateTo(view: const BookingSuccessView());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => CheckoutViewModel(),
    );
  }
}