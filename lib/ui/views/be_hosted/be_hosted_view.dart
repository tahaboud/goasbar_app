import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/be_hosted/be_hosted_viewmodel.dart';
import 'package:goasbar/ui/widgets/billing_info.dart';
import 'package:goasbar/ui/widgets/doc_info.dart';
import 'package:goasbar/ui/widgets/general_info.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:styled_widget/styled_widget.dart';

class BeHostedView extends HookWidget {
  BeHostedView({super.key, required this.request, required this.completer});

  final SheetRequest request;
  final Function(SheetResponse) completer;
  bool? once = true;

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
    var bankName = useTextEditingController();
    var bankAccountNumber = useTextEditingController();
    var iban = useTextEditingController();
    var pageController = usePageController();

    return ViewModelBuilder<BeHostedInfoViewModel>.reactive(
      builder: (context, model, child) {
        if (!model.isBusy) {
          if (model.provider != null) {
            if (once!) {
              name.text = model.provider!.response!.nickname!;
              bio.text = model.provider!.response!.about!;
              email.text = model.provider!.response!.email!;
              phone.text = model.provider!.response!.phoneNumber!;
              identityNumber.text = model.provider!.response!.identity!;
              bankName.text = model.provider!.response!.bankName!;
              bankAccountNumber.text =
                  model.provider!.response!.bankAccountNumber!;
              model.typeOfIdentity.text =
                  model.provider!.response!.identityType!;
              iban.text =
                  model.writeIbanFormat(iban: model.provider!.response!.iBAN!)!;

              if (model.provider!.response!.website != null) {
                website.text = model.provider!.response!.website!;
              }
              if (model.provider!.response!.twitterAccount != null) {
                twitter.text = model.provider!.response!.twitterAccount!;
              }
              if (model.provider!.response!.facebookAccount != null) {
                facebook.text = model.provider!.response!.facebookAccount!;
              }
              if (model.provider!.response!.instagramAccount != null) {
                instagram.text = model.provider!.response!.instagramAccount!;
              }

              once = false;
            }
          } else {
            if (once!) {
              UserModel? user = request.data;
              name.text = "${user!.firstName!}${user.lastName!}";
              email.text = user.email!;
              phone.text = user.phoneNumber!;

              once = false;
            }
          }
        }

        return PageView(
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
              onTapShowTypeOfIdentity: () =>
                  model.showTypeOfIdentityDialog(type: ''),
              onTapPickImage: () => model.pickImage(),
              showErrorDialog: () => model.showErrorDialog(),
            ),
            BillingInfo(
              twitter: twitter,
              pageController: pageController,
              instagram: instagram,
              facebook: facebook,
              bankName: bankName,
              bankAccountNumber: bankAccountNumber,
              iban: iban,
              isClicked: model.isClicked!,
              updateIsClicked: (value) => model.updateIsClicked(value: value),
              onTapBack: () {
                model.back();
              },
              showErrorDialog: () => model.showErrorDialog(),
              onTapSubmit: () async {
                UserModel? user = request.data;
                if (!user!.isProvider!) {
                  Map<String, dynamic>? body = {
                    "nickname": name.text,
                    "identity": identityNumber.text,
                    "identity_type":
                        model.typeOfIdentity.text == "National Identity"
                            ? "IDENTITY"
                            : "REGISTRATION",
                    "about": bio.text,
                    "bank_name": bankName.text,
                    "bank_account_number": bankAccountNumber.text,
                    "IBAN": iban.text.replaceAll(' ', ''),
                  };

                  if (website.text.isNotEmpty) {
                    body.addAll({
                      "website": website.text,
                    });
                  }
                  if (twitter.text.isNotEmpty) {
                    body.addAll({
                      "twitter_account": twitter.text,
                    });
                  }
                  if (model.file != null) {
                    var pickedFile = await MultipartFile.fromFile(
                      model.file!.path,
                      filename: model.file!.path.substring(
                          model.file!.absolute.path.lastIndexOf('/') + 1),
                    );
                    body.addAll({
                      "doc_image": pickedFile,
                    });
                  }
                  if (facebook.text.isNotEmpty) {
                    body.addAll({
                      "facebook_account": facebook.text,
                    });
                  }
                  if (instagram.text.isNotEmpty) {
                    body.addAll({
                      "instagram_account": instagram.text,
                    });
                  }
                  model.updateIsClicked(value: true);
                  model
                      .beHostedProvider(
                    context: context,
                    body: body,
                  )
                      .then((value) {
                    model.updateIsClicked(value: false);
                    if (value != null) {
                      completer(SheetResponse(confirmed: true));
                    } else {}
                  });
                } else {
                  Map? body = {};

                  if (name.text != model.provider!.response!.nickname!) {
                    body.addAll({'nickname': name.text});
                  }
                  if (identityNumber.text !=
                      model.provider!.response!.identity!) {
                    body.addAll({'identity': identityNumber.text});
                  }
                  if (model.typeOfIdentity.text !=
                      model.provider!.response!.identityType!) {
                    body.addAll({'identity_type': model.typeOfIdentity.text});
                  }
                  if (bio.text != model.provider!.response!.about!) {
                    body.addAll({'about': bio.text});
                  }
                  if (bankName.text != model.provider!.response!.bankName!) {
                    body.addAll({'bank_name': bankName.text});
                  }
                  if (bankAccountNumber.text !=
                      model.provider!.response!.bankAccountNumber!) {
                    body.addAll(
                        {'bank_account_number': bankAccountNumber.text});
                  }
                  if (iban.text.replaceAll(' ', '') !=
                      model.provider!.response!.iBAN!) {
                    body.addAll({'IBAN': iban.text.replaceAll(' ', '')});
                  }
                  if (website.text != model.provider!.response!.website &&
                      website.text.isNotEmpty) {
                    body.addAll({'website': website.text});
                  }
                  if (twitter.text !=
                          model.provider!.response!.twitterAccount &&
                      twitter.text.isNotEmpty) {
                    body.addAll({'twitter_account': twitter.text});
                  }
                  if (facebook.text !=
                          model.provider!.response!.facebookAccount &&
                      facebook.text.isNotEmpty) {
                    body.addAll({'facebook_account': facebook.text});
                  }
                  if (instagram.text !=
                          model.provider!.response!.instagramAccount &&
                      instagram.text.isNotEmpty) {
                    body.addAll({'instagram_account': instagram.text});
                  }
                  if (model.file != null) {
                    body.addAll({'doc_image': model.file});
                  }

                  model
                      .updateProvider(
                    body: body,
                  )
                      .then((value) {
                    if (value != null) {
                      model.back();
                    } else {}
                  });
                }
              },
            ),
          ],
        ).height(screenHeightPercentage(context, percentage: 0.85));
      },
      viewModelBuilder: () => BeHostedInfoViewModel(context: context),
    );
  }
}
