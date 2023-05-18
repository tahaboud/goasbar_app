import 'package:flutter/material.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/ui/views/add_payment_method/add_payment_method_view.dart';
import 'package:goasbar/ui/views/settings_pages/payment_method/payment_method_viewmodel.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:goasbar/ui/widgets/payment_method_card.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:easy_localization/easy_localization.dart';

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
                      Text('Payment methods'.tr(), style: const TextStyle(fontSize: 21),),
                    ],
                  ),
                  verticalSpaceLarge,
                  Expanded(
                    child: Column(
                      children: model.dataReady ? model.data!.response!.isEmpty ? [
                        Text("You have no cards registered yet".tr()).center(),
                      ] : [
                        for (var card in model.data!.response!)
                          PaymentMethodCard(text: 'xxxx - xxxx - xxxx - ${card.lastDigits}', method: card.brand == "VS" ? 'visa_method' : 'mada_method'),
                      ] : [
                        const Loader().center()
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
                    child: Center(
                      child: Text('ADD MORE'.tr(), style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
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
      viewModelBuilder: () => PaymentMethodViewModel(context: context),
    );
  }
}
