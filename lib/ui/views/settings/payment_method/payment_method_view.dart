import 'package:flutter/material.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/settings/add_payment_method/add_payment_method_view.dart';
import 'package:goasbar/ui/views/settings/payment_method/payment_method_viewmodel.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/ui/widgets/payment_method_card.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class PaymentMethodView extends StatelessWidget {
  const PaymentMethodView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PaymentMethodViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Column(
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
                      const Text('Payment methods', style: TextStyle(fontSize: 21),),
                    ],
                  ),
                  verticalSpaceLarge,
                  Expanded(
                    child: Column(
                      children: const [
                        PaymentMethodCard(text: 'xxxx - xxxx - xxxx - 6037', method: 'visa_method'),
                        verticalSpaceMedium,
                        PaymentMethodCard(text: 'xxxx - xxxx - xxxx - 6037', method: 'mastercard_method'),
                        verticalSpaceMedium,
                        PaymentMethodCard(text: 'Oussama@gmail.com', method: 'paypal_method'),
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
                      child: Text('ADD MORE', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
                    ),
                  ).gestures(
                    onTap: () async {
                      model.navigateTo(view: const AddPaymentMethodView());
                    },
                  ),
                ],
              ),
            ),

          ],
        ).padding(vertical: 20, horizontal: 20),
      ),
      viewModelBuilder: () => PaymentMethodViewModel(),
    );
  }
}
