import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/settings/add_payment_method/add_payment_method_viewmodel.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/ui/widgets/info_item.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:goasbar/ui/widgets/add_payment_method_card.dart';

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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AddPaymentMethodCard(image: 'visa_method', isSelected: model.isSelected == 1, onTap: () => model.changeSelection(index: 1)),
                              AddPaymentMethodCard(image: 'mastercard_method', isSelected: model.isSelected == 2, onTap: () => model.changeSelection(index: 2)),
                              AddPaymentMethodCard(image: 'paypal_method', isSelected: model.isSelected == 3, onTap: () => model.changeSelection(index: 3)),
                            ],
                          ),
                          verticalSpaceLarge,
                          InfoItem(
                            controller: cardHolder,
                            label: 'Card Holder',
                            hintText: 'Oussama GoAsbar',
                          ),
                          verticalSpaceRegular,
                          InfoItem(
                            controller: cardNumber,
                            label: 'Card Number',
                            hintText: '8585 9595 7575 6565',
                          ),
                          verticalSpaceRegular,
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
                          model.back();
                          model.back();
                        } else {

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
