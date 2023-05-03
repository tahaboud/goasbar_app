import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/ui/views/add_payment_method/add_payment_method_viewmodel.dart';
import 'package:goasbar/ui/widgets/info_item.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:goasbar/ui/widgets/add_payment_method_card.dart';
import 'package:easy_localization/easy_localization.dart';

class AddPaymentMethodView extends HookWidget {
  const AddPaymentMethodView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cardHolder = useTextEditingController();
    var cardNumber = useTextEditingController();
    var expiryDate = useTextEditingController();
    var cvv = useTextEditingController();

    return ViewModelBuilder<AddPaymentMethodViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 650,
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
                        const Text('Add more payment methods', style: TextStyle(fontSize: 21),),
                      ],
                    ),
                    verticalSpaceLarge,
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AddPaymentMethodCard(image: 'visa_method', isSelected: model.selectedCardType == 1, onTap: () => model.changeSelection(index: 1)),
                              AddPaymentMethodCard(image: 'mada_method', isSelected: model.selectedCardType == 2, onTap: () => model.changeSelection(index: 2)),
                            ],
                          ),
                          verticalSpaceLarge,
                          InfoItem(
                            controller: cardHolder,
                            label: 'Card Holder',
                            hintText: 'Osama Mogaitoof',
                          ),
                          verticalSpaceRegular,
                          InfoItem(
                            controller: cardNumber,
                            label: 'Card Number'.tr(),
                            hintText: 'xxxx xxxx xxxx xxxx',
                          ),
                          verticalSpaceRegular,
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
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        gradient: kMainGradient,
                      ),
                      child: const Center(
                        child: Text('Link To My Account', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
                      ),
                    ).gestures(
                      onTap: () async {
                        if (cardNumber.text.isNotEmpty && cardHolder.text.isNotEmpty && expiryDate.text.isNotEmpty && cvv.text.isNotEmpty) {
                          model.saveCard(
                            context: context,
                            cardType: model.selectedCardType == 1 ? "VISA" : "MADA",
                            expiryMonth: expiryDate.text.substring(0, 2),
                            expiryYear: expiryDate.text.substring(3),
                            cVV: cvv.text,
                            cardNumber: cardNumber.text,
                            cardHolder: cardHolder.text,
                          );
                        } else {
                          showMotionToast(context: context, title: 'Warning', msg: 'All fields are mandatory', type: MotionToastType.warning);
                        }
                      },
                    ),
                  ],
                ),
              ),

            ],
          ).padding(vertical: 20, horizontal: 20),
        ),
      ),
      viewModelBuilder: () => AddPaymentMethodViewModel(),
    );
  }
}
