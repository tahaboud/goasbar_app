import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/settings_pages/support/support_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class SupportView extends HookWidget {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SupportViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SizedBox(
              height: 650,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: model.back,
                          icon: const Icon(CupertinoIcons.arrow_turn_up_right)),
                      Text(
                        'Support Center'.tr(),
                        style: const TextStyle(fontSize: 21),
                      ),
                    ],
                  ),
                  verticalSpaceMedium,
                  Expanded(
                    child: Column(
                      children: [
                        Text("contact us".tr(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        verticalSpaceMedium,
                        const Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 35,
                            ),
                            horizontalSpaceSmall,
                            Text(
                              "+966 535 584 402",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500),
                              textDirection: TextDirection.ltr,
                            )
                          ],
                        ).gestures(onTap: () => model.launchPhoneCall()),
                        verticalSpaceMedium,
                        const Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 35,
                            ),
                            horizontalSpaceSmall,
                            Text(
                              "info@goasbar.com",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500),
                            )
                          ],
                        ).gestures(onTap: () => model.launchEmail()),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: kMainGradient,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all<Size>(
                              const Size.fromHeight(double.infinity)),
                          backgroundColor: WidgetStateProperty.all<Color>(
                              Colors.transparent),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ))),
                      child: Text('Go to Website'.tr(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                      onPressed: () async {
                        model.launchWebSite();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => SupportViewModel(),
    );
  }
}
