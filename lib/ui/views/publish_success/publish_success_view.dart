import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/publish_success/publish_success_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:styled_widget/styled_widget.dart';

class PublishSuccessView extends HookWidget {
  const PublishSuccessView({Key? key, required this.request, required this.completer})
      : super(key: key);

  final SheetRequest request;
  final Function(SheetResponse) completer;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PublishSuccessViewModel>.reactive(
      builder: (context, model, child) => Container(
        height: screenHeightPercentage(context, percentage: 0.85),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18),),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/icons/booking_success.png"),
              const Text('PUBLISHING\n   Success', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,)),
              verticalSpaceSmall,
              const Text('Your experience has been published', style: TextStyle(color: kGrayText)),
              verticalSpaceMedium,
              Image.asset("assets/images/success_image.png", height: 250),
              verticalSpaceMedium,
              verticalSpaceRegular,
              Container(
                width: MediaQuery.of(context).size.width - 60,
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: kMainGradient,
                ),
                child: const Center(
                  child: Text('Go to my experiences', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
                ),
              ).gestures(
                onTap: () {
                  completer(SheetResponse(confirmed: true));
                },
              ),
              verticalSpaceRegular,
            ],
          ),
        ),
      ).height(screenHeightPercentage(context, percentage: 0.85)),
      viewModelBuilder: () => PublishSuccessViewModel(),
    );
  }
}