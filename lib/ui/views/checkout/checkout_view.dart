import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/data_models/booking_model.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/checkout/checkout_viewmodel.dart';
import 'package:goasbar/ui/widgets/info_item.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:goasbar/ui/widgets/payment_method_card.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CheckoutView extends HookWidget {
  const CheckoutView({Key? key, this.booking, this.experience, this.user, this.usersCount}) : super(key: key);
  final ExperienceResults? experience;
  final UserModel? user;
  final BookingModel? booking;
  final int? usersCount;

  @override
  Widget build(BuildContext context) {
    var cardNumber = useTextEditingController();
    var cardHolder = useTextEditingController();
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
                    Text('Checkout'.tr(), style: const TextStyle(fontSize: 21),),
                  ],
                ),
                verticalSpaceMedium,
                !model.dataReady ? const SizedBox() : model.data!.response!.isEmpty ? const SizedBox() : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Registered Cards'.tr()),
                  ],
                ),
                !model.dataReady ? const SizedBox() : model.data!.response!.isEmpty ? const SizedBox() : verticalSpaceSmall,
                Column(
                  children: model.dataReady ? model.data!.response!.isEmpty ? [
                    const SizedBox()
                  ] : [
                    for (var card in model.data!.response!)
                      PaymentMethodCard(text: 'xxxx - xxxx - xxxx - ${card.lastDigits}', method: card.brand == "VS" ? 'visa_method' : 'mada_method').gestures(
                        onTap: () {
                          model.updateIsRegisteredCardSelected(registeredCard: card);
                        }
                      ).backgroundColor(model.selectedRegisteredCard!.registrationId == card.registrationId ? kMainColor1 : Colors.transparent, animate: true).clipRRect(all: 10).animate(const Duration(milliseconds: 300), Curves.decelerate),
                  ] : [
                    const Loader().center()
                  ],
                ),
                !model.dataReady ? const SizedBox() : model.data!.response!.isEmpty ? const SizedBox() : const Divider(height: 50, thickness: 1.2),
                !model.dataReady ? const SizedBox() : model.data!.response!.isEmpty ? const SizedBox() : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('New Payment Card'.tr()),
                  ],
                ),
                !model.dataReady ? const SizedBox() : model.data!.response!.isEmpty ? const SizedBox() : verticalSpaceSmall,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: model.selectedPaymentMethod == 1 ? 2 : 1.5, color: model.selectedPaymentMethod == 1 ? Colors.blue : Colors.grey)
                      ),
                      child: Image.asset("assets/icons/checkout/mada.png",).gestures(
                        onTap: () => model.selectPaymentMethod(value: 1),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: model.selectedPaymentMethod == 2 ? 2 : 1.5, color: model.selectedPaymentMethod == 2 ? Colors.blue : Colors.grey,)
                      ),
                      child: Image.asset("assets/icons/checkout/visa.png",).gestures(
                        onTap: () => model.selectPaymentMethod(value: 2),
                      ),
                    ),
                    if (Platform.isIOS)
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: model.selectedPaymentMethod == 3 ? 2 : 1.5, color: model.selectedPaymentMethod == 3 ? Colors.blue : Colors.grey)
                      ),
                      child: Image.asset("assets/icons/checkout/apple_pay.png",).gestures(
                        onTap: () => model.selectPaymentMethod(value: 3),
                      ),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                InfoItem(
                  controller: cardHolder,
                  label: 'Card Holder'.tr(),
                  hintText: 'Osama Mogaitoof',
                ),
                verticalSpaceMedium,
                InfoItem(
                  controller: cardNumber,
                  label: 'Card Number'.tr(),
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
                        label: 'Expiration Date'.tr(),
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
                          Text('Ticket Price'.tr(), style: const TextStyle(fontSize: 16)),
                          Text('${double.parse(experience!.price!) * usersCount!} SR', style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      verticalSpaceRegular,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Fare Tax'.tr(), style: const TextStyle(fontSize: 16)),
                          const Text('00.00 SR', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      verticalSpaceLarge,
                      verticalSpaceTiny,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Amount'.tr(), style: const TextStyle(fontSize: 16)),
                          Text('${double.parse(experience!.price!) * usersCount!} SR', style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
                verticalSpaceLarge,
                Text('Payment Terms and Conditions'.tr(), style: const TextStyle(color: Color(0xff223263)),),
                verticalSpaceRegular,
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: kMainGradient,
                  ),
                  child: model.isClicked! ? const Loader().center() : Text('Continue with Payment'.tr(), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),).center(),
                ).gestures(
                  onTap:  () {
                    if (model.selectedRegisteredCard!.registrationId != "") {
                      //TODO pay with registered cards
                      model.prepareCheckoutTokenization(
                        context: context,
                        brand: model.selectedRegisteredCard!.brand == "VS" ? "VISA" : "MADA",
                        registrationId: model.selectedRegisteredCard!.registrationId,
                        bookingId: booking!.response!.id,
                        body: {
                          "payment_method": model.selectedPaymentMethod == 1 ? 'MADA' : model.selectedPaymentMethod == 2 ? 'VISA' : 'APPLEPAY',
                        },);
                    } else {
                      if (cardNumber.text.isNotEmpty && cvv.text.isNotEmpty && expiryDate.text.isNotEmpty) {
                        model.prepareCheckoutPayment(
                          context: context,
                          user: user,
                          bookingId: booking!.response!.id,
                          cardHolder: cardHolder.text,
                          cardNumber: cardNumber.text,
                          cVV: cvv.text,
                          expiryMonth: expiryDate.text.substring(0, 2),
                          expiryYear: expiryDate.text.substring(3),
                          body: {
                            "payment_method": model.selectedPaymentMethod == 1 ? 'MADA' : model.selectedPaymentMethod == 2 ? 'VISA' : 'APPLEPAY',
                          },);
                      } else {
                        showMotionToast(context: context, title: 'Warning', msg: "All filed must be filled.", type: MotionToastType.warning);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => CheckoutViewModel(context: context),
    );
  }
}