import 'package:flutter/material.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/checkout/checkout_viewmodel.dart';
import 'package:goasbar/ui/widgets/info_item.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CheckoutView extends HookWidget {
  const CheckoutView({Key? key, this.experience, this.user, this.usersCount}) : super(key: key);
  final ExperienceResults? experience;
  final UserModel? user;
  final int? usersCount;

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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      child: Image.asset("assets/icons/checkout/mada.png",).gestures(
                        onTap: () => model.selectPaymentMethod(value: 2),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: model.selectedPaymentMethod == 3 ? 2 : 1.5, color: model.selectedPaymentMethod == 4 ? Colors.blue : Colors.grey)
                      ),
                      child: Image.asset("assets/icons/checkout/apple_pay.png",).gestures(
                        onTap: () => model.selectPaymentMethod(value: 4),
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
                        label: 'Expiration Date',
                        hintText: 'MM/YY',
                      ),
                    ),
                    SizedBox(
                      width: screenWidthPercentage(context, percentage: 0.4),
                      child: InfoItem(
                        controller: cvv,
                        label: 'CVV',
                        hintText: 'XXX',
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
                          const Text('Ticket Price', style: TextStyle(fontSize: 16)),
                          Text('${double.parse(experience!.price!) * usersCount!} SR', style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      verticalSpaceRegular,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Fare Tax', style: TextStyle(fontSize: 16)),
                          Text('00.00 SR', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      verticalSpaceLarge,
                      verticalSpaceTiny,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Amount', style: TextStyle(fontSize: 16)),
                          Text('${double.parse(experience!.price!) * usersCount!} SR', style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
                verticalSpaceLarge,
                const Text('Payment Terms and Conditions', style: TextStyle(color: Color(0xff223263)),),
                verticalSpaceRegular,
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: kMainGradient,
                  ),
                  child: model.isClicked! ? const Loader().center() :const Text('Continue with Payment', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),).center(),
                ).gestures(
                  onTap:  () {
                    if (cardNumber.text.isNotEmpty && cvv.text.isNotEmpty && expiryDate.text.isNotEmpty) {
                      model.prepareCheckout(
                        context: context,
                        user: user,
                        bookingId: experience!.id,
                        cardHolder: "cardNumber.text",
                        cardNumber: cardNumber.text,
                        cVV: cvv.text,
                        expiryMonth: expiryDate.text.substring(0, 2),
                        expiryYear: expiryDate.text.substring(3),
                        body: {
                          "payment_method": model.selectedPaymentMethod == 1 ? 'VISA' : model.selectedPaymentMethod == 2 ? 'MADA' : 'APPLEPAY',
                        },);
                    } else {
                      showMotionToast(context: context, title: 'Warning', msg: "All filed must be filled.", type: MotionToastType.warning);
                    }
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