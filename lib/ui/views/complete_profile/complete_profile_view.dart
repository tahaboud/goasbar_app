import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/complete_profile/complete_profile_viewmodel.dart';
import 'package:goasbar/ui/views/guest/guest_view.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CompleteProfileView extends HookWidget {
  const CompleteProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var name = useTextEditingController();
    var email = useTextEditingController();

    return ViewModelBuilder<CompleteProfileViewModel>.reactive(
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          print(' back ');
          return false;
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  verticalSpaceLarge,
                  const Text('Complete Profile', style: TextStyle(fontSize: 32),).center(),
                  verticalSpaceSmall,
                  const Text("Quick steps to publish your profile", style: TextStyle(color: kMainGray,),).center(),
                  verticalSpaceMedium,
                  Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: kMainDisabledGray,
                        width: 5,
                      ),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/profile_image.png"),
                      )
                    ),
                    // child: Image.asset("assets/images/profile_image.png"),
                  ),
                  verticalSpaceMedium,
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                      hintText: 'Abdeldjalil Anas',
                      hintStyle: const TextStyle(fontSize: 14),
                      // prefixText: 'Saudi Arabia ( +966 ) | ',
                      prefixIcon: const Text(' Full name ', style: TextStyle(color: kMainColor2, fontSize: 14),).padding(vertical: 20, horizontal: 10),
                      fillColor: kTextFiledGrayColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kTextFiledGrayColor),
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                  TextField(
                    readOnly: true,
                    controller: model.gender,
                    decoration: InputDecoration(
                      hintText: 'Male',
                      hintStyle: const TextStyle(fontSize: 14),
                      suffixIcon: Image.asset('assets/icons/drop_down.png')
                          .gestures(onTap: () {
                            model.showSelectionDialog(gen: model.gender.text);
                      }),
                      prefixIcon: const Text(' Gender ', style: TextStyle(color: kMainColor2, fontSize: 14),).padding(vertical: 20, horizontal: 10),
                      fillColor: kTextFiledGrayColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kTextFiledGrayColor),
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                  TextField(
                    readOnly: true,
                    controller: model.birthDate,
                    decoration: InputDecoration(
                      hintText: '25 . 10 1998',
                      hintStyle: const TextStyle(fontSize: 14),
                      suffixIcon: Image.asset('assets/icons/birth_date.png')
                          .gestures(onTap: () {
                          model.showBirthDayPicker(context);
                      }),
                      prefixIcon: const Text(' Birthday ', style: TextStyle(color: kMainColor2, fontSize: 14),).padding(vertical: 20, horizontal: 10),
                      fillColor: kTextFiledGrayColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kTextFiledGrayColor),
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                  TextFormField(
                    controller: email,
                    validator: model.validateEmail(value: email.text),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'anas.yahya42@gmail.com',
                      hintStyle: const TextStyle(fontSize: 14),
                      prefixIcon: const Text(' Email ', style: TextStyle(color: kMainColor2, fontSize: 14),).padding(vertical: 20, horizontal: 10),
                      fillColor: kTextFiledGrayColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kTextFiledGrayColor),
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      gradient: name.text.isNotEmpty && email.text.isNotEmpty && model.birthDate.text.isNotEmpty && model.gender.text.isNotEmpty ? kMainGradient : kMainDisabledGradient,
                    ),
                    child: const Text('Go To Home Page', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),).center(),
                  ).gestures(
                    onTap: name.text.isNotEmpty && email.text.isNotEmpty && model.birthDate.text.isNotEmpty && model.gender.text.isNotEmpty ? () {
                      model.clearAndNavigateTo(view: const GuestView(isGuest: false,));
                    } : () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => CompleteProfileViewModel(),
    );
  }
}
