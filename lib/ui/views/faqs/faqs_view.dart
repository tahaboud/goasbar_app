import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/faqs/faqs_viewmodel.dart';
import 'package:goasbar/ui/widgets/faq_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FAQsView extends HookWidget {
  const FAQsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FAQsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpaceMedium,
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
                    const Spacer(),
                    const Spacer(),
                    const Text('FAQs', style: TextStyle(fontSize: 21),),
                    const Spacer(),
                    const Spacer(),
                    const Spacer(),
                  ],
                ),
                verticalSpaceLarge,
                const FAQWidget(),
                verticalSpaceMedium,
                const FAQWidget(),
                verticalSpaceMedium,
                const FAQWidget(),
                verticalSpaceMedium,
                const Text('daily FAQs', style: TextStyle(fontWeight: FontWeight.bold),),
                verticalSpaceSmall,
                const Text('Lorem Ipsum Dolor Sit Amet, Consetetur Sadipscing', style: TextStyle(color: kMainGray)),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => FAQsViewModel(),
    );
  }
}
