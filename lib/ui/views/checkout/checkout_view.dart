import 'package:flutter/material.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/booking_scuccess/booking_success_view.dart';
import 'package:goasbar/ui/views/checkout/checkout_viewmodel.dart';
import 'package:goasbar/ui/widgets/info_item.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CheckoutView extends HookWidget {
  const CheckoutView({Key? key, this.experience}) : super(key: key);
  final ExperienceResults? experience;

  @override
  Widget build(BuildContext context) {
    var cardNumber = useTextEditingController();
    var expiryDate = useTextEditingController();
    var cvv = useTextEditingController();

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
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: model.selectedPaymentMethod == 1 ? 2 : 1.5, color: model.selectedPaymentMethod == 1 ? Colors.blue : Colors.grey,)
                      ),
                      child: Image.asset("assets/icons/checkout/visa.png",).gestures(
                        onTap: () => model.selectPaymentMethod(value: 1),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: model.selectedPaymentMethod == 2 ? 2 : 1.5, color: model.selectedPaymentMethod == 2 ? Colors.blue : Colors.grey)
                      ),
                      child: Image.asset("assets/icons/checkout/master_card.png",).gestures(
                        onTap: () => model.selectPaymentMethod(value: 2),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: model.selectedPaymentMethod == 3 ? 2 : 1.5, color: model.selectedPaymentMethod == 3 ? Colors.blue : Colors.grey)
                      ),
                      child: Image.asset("assets/icons/checkout/paypal.png",).gestures(
                        onTap: () => model.selectPaymentMethod(value: 3),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: model.selectedPaymentMethod == 4 ? 2 : 1.5, color: model.selectedPaymentMethod == 4 ? Colors.blue : Colors.grey)
                      ),
                      child: Image.asset("assets/icons/checkout/apple_pay.png",).gestures(
                        onTap: () => model.selectPaymentMethod(value: 4),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: model.selectedPaymentMethod == 5 ? 2 : 1.5, color: model.selectedPaymentMethod == 5 ? Colors.blue : Colors.grey),
                      ),
                      child: Image.asset("assets/icons/checkout/stripe.png",).gestures(
                        onTap: () => model.selectPaymentMethod(value: 5),
                      ),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                InfoItem(
                  controller: cardNumber,
                  label: 'Card Number',
                  hintText: '8585 9595 7575 6565',
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenWidthPercentage(context, percentage: 0.4),
                      child: InfoItem(
                        controller: expiryDate,
                        label: 'Expiry Date',
                        hintText: '08/24',
                      ),
                    ),
                    SizedBox(
                      width: screenWidthPercentage(context, percentage: 0.4),
                      child: InfoItem(
                        controller: cvv,
                        label: 'CVV',
                        hintText: '000',
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
                        children: [
                          const Text('Ticket price', style: TextStyle(fontSize: 16)),
                          Text('${experience!.price} SR', style: const TextStyle(fontSize: 16)),
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
                        children: [
                          const Text('Total amount', style: TextStyle(fontSize: 16)),
                          Text('${experience!.price!} SR', style: const TextStyle(fontSize: 16)),
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