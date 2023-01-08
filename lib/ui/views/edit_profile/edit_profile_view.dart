import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/edit_profile/edit_profile_viewmodel.dart';
import 'package:goasbar/ui/widgets/info_item.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/cupertino.dart';

class EditProfileView extends HookWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var name = useTextEditingController();
    var userName = useTextEditingController();
    var email = useTextEditingController();
    var phone = useTextEditingController();
    var typeOfIdentity = useTextEditingController();

    return ViewModelBuilder<EditProfileViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                    const Text('Edit Profile', style: TextStyle(fontSize: 21),),
                  ],
                ),
                verticalSpaceMedium,
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 0,
                        offset: Offset(0, 1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: kMainColor2, width: 2),
                                image: DecorationImage(
                                  image: model.file == null ? const AssetImage("assets/images/profile_image.png",)
                                      : FileImage(model.file!) as ImageProvider,
                                  fit: BoxFit.cover,
                                )
                            ),
                          ),
                          horizontalSpaceSmall,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Oussama mogaitoof", style: TextStyle(fontWeight: FontWeight.w600),),
                              verticalSpaceSmall,
                              Text("Change Profile Picture", style: TextStyle(color: kGrayText),),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/icons/export.png").gestures(onTap: () => model.pickImage()),
                          verticalSpaceSmall,
                          const Text("50 %", style: TextStyle(color: kGrayText),),
                        ],
                      ),
                    ],
                  ),
                ),
                verticalSpaceMedium,
                InfoItem(
                  controller: name,
                  label: 'Full name',
                  hintText: 'Abdeldjalil Anes',
                ),
                verticalSpaceMedium,
                InfoItem(
                  controller: userName,
                  label: 'User name',
                  hintText: 'Abdeldjalil_Anes',
                ),
                verticalSpaceMedium,
                Container(
                  decoration: BoxDecoration(
                    color: kTextFiledMainColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpaceSmall,
                      Row(
                        children: const [
                          horizontalSpaceSmall,
                          Text("Email"),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          validator: (value) => model.validateEmail(value: value),
                          controller: email,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'exemple@email.com',
                            hintStyle: TextStyle(fontSize: 14),
                            fillColor: kTextFiledMainColor,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpaceMedium,
                Container(
                  decoration: BoxDecoration(
                    color: kTextFiledMainColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpaceSmall,
                      Row(
                        children: const [
                          horizontalSpaceSmall,
                          Text("Phone Number"),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          validator: (value) => model.validatePhoneNumber(value: value),
                          controller: phone,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '+213699414965',
                            hintStyle: TextStyle(fontSize: 14),
                            fillColor: kTextFiledMainColor,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpaceMedium,
                Container(
                  decoration: BoxDecoration(
                    color: kTextFiledMainColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpaceSmall,
                      Row(
                        children: const [
                          horizontalSpaceSmall,
                          Text("Gender"),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          readOnly: true,
                          controller: typeOfIdentity,
                          decoration: InputDecoration(
                            hintText: 'Male',
                            hintStyle: const TextStyle(fontSize: 14),
                            suffixIcon: const Icon(Icons.arrow_drop_down)
                                .gestures(onTap: () => model.showSelectionDialog(gen: 'Male')),
                            fillColor: kTextFiledMainColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpaceMedium,
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: kMainGradient,
                  ),
                  child: const Text('SUBMIT', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),).center(),
                ).gestures(
                  onTap: name.text.isNotEmpty && email.text.isNotEmpty && model.birthDate.text.isNotEmpty && model.gender.text.isNotEmpty ? () async {
                    model.back();
                  } : () {
                    model.showErrorDialog();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => EditProfileViewModel(),
    );
  }
}
