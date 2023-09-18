import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/settings_pages/support/support_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class SupportView extends HookWidget {
  const SupportView({Key? key}) : super(key: key);

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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(CupertinoIcons.arrow_turn_up_left).height(40)
                          .width(40)
                          .gestures(
                          onTap: () {
                            model.back();
                          }
                      ),
                      Text('Support Center'.tr(), style: const TextStyle(fontSize: 21),),
                    ],
                  ),
                  verticalSpaceMedium,
                  Expanded(
                    child: Column(
                      children: [
                        Text("contact us".tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        verticalSpaceMedium,
                        Row(
                          children: const [
                            Icon(Icons.phone_outlined, size: 35,),
                            horizontalSpaceSmall,
                            Text("+966 535 584 402", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500), textDirection: TextDirection.ltr,)
                          ],
                        ).gestures(onTap: () => model.launchPhoneCall()),
                        verticalSpaceMedium,
                        Row(
                          children: const [
                            Icon(Icons.email_outlined, size: 35,),
                            horizontalSpaceSmall,
                            Text("info@goasbar.com", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),)
                          ],
                        ).gestures(onTap: () => model.launchEmail()),
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
                      child: Text('Go to Website'.tr(), style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
                    ),
                  ).gestures(
                    onTap: () async {
                      model.launchWebSite();
                    },
                  ),
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
