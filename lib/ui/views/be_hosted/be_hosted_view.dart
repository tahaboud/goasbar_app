import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/be_hosted/be_hosted_viewmodel.dart';
import 'package:goasbar/ui/views/guest/guest_view.dart';
import 'package:goasbar/ui/widgets/billing_info.dart';
import 'package:goasbar/ui/widgets/doc_info.dart';
import 'package:goasbar/ui/widgets/general_info.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:styled_widget/styled_widget.dart';

class BeHostedView extends HookWidget {
  const BeHostedView({Key? key, required this.request, required this.completer})
      : super(key: key);

  final SheetRequest request;
  final Function(SheetResponse) completer;

  @override
  Widget build(BuildContext context) {
    var name = useTextEditingController();
    var bio = useTextEditingController();
    var email = useTextEditingController();
    var website = useTextEditingController();
    var phone = useTextEditingController();
    var identityNumber = useTextEditingController();
    var twitter = useTextEditingController();
    var instagram = useTextEditingController();
    var facebook = useTextEditingController();
    var bankEbay = useTextEditingController();
    var bankAccountNumber = useTextEditingController();
    var iban = useTextEditingController();
    var pageController = usePageController();

    return ViewModelBuilder<BeHostedInfoViewModel>.reactive(
      builder: (context, model, child) => PageView(
        scrollDirection: Axis.horizontal,
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => model.changeIndex(index: index),
        children: [
          GeneralInfo(
            name: name,
            bio: bio,
            email: email,
            website: website,
            phone: phone,
            pageController: pageController,
            onTapBack: () => model.back(),
            validateEmail: (value) => model.validateEmail(value: value),
            validatePhone: (value) => model.validatePhoneNumber(value: value),
            showErrorDialog: () => model.showErrorDialog(),
          ),
          DocInfo(
            condition: model.file == null,
            identityNumber: identityNumber,
            pageController: pageController,
            onTapBack: () => model.back(),
            typeOfIdentity: model.typeOfIdentity,
            onTapShowTypeOfIdentity: () => model.showTypeOfIdentityDialog(type: ''),
            onTapPickImage: () => model.pickImage(),
            showErrorDialog: () => model.showErrorDialog(),
          ),
          BillingInfo(
            twitter: twitter,
            instagram: instagram,
            facebook: facebook,
            bankEbay: bankEbay,
            bankAccountNumber: bankAccountNumber,
            iban: iban,
            onTapBack: () => model.back(),
            showErrorDialog: () => model.showErrorDialog(),
            onTapSubmit: () {
              model.setToken(token: 'token');
              model.clearAndNavigateTo(view: const GuestView());
            },
          ),
        ],
      ).height(screenHeightPercentage(context, percentage: 0.85)),
      viewModelBuilder: () => BeHostedInfoViewModel(),
    );
  }
}