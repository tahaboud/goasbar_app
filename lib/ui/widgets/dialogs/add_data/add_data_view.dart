import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/dialogs/add_data/add_data_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:styled_widget/styled_widget.dart';

class AddDataView extends HookWidget {
  final DialogRequest? dialogRequest;
  final Function(DialogResponse)? onDialogTap;
  const AddDataView({Key? key, this.dialogRequest, this.onDialogTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddDataViewModel>.reactive(
      builder: (context, model, child) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "Add Your Information",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ).center(),
                verticalSpaceMedium,
                if (dialogRequest!.data['addBirthdate']) ...[
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
                      prefixIcon: Text(
                        ' Birthday '.tr(),
                        style:
                            const TextStyle(color: kMainColor2, fontSize: 14),
                      ).padding(vertical: 20, horizontal: 10),
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
                ],
                if (dialogRequest!.data['addGender']) ...[
                  SizedBox(
                    height: 60,
                    child: TextField(
                      readOnly: true,
                      controller: model.gender,
                      decoration: InputDecoration(
                        hintText: 'Select the Gender'.tr(),
                        hintStyle: const TextStyle(fontSize: 14),
                        suffixIcon: Image.asset('assets/icons/drop_down.png')
                            .gestures(onTap: () {
                          model.showSelectionDialog(gen: model.gender.text);
                        }),
                        prefixIcon: const Text(
                          ' Gender ',
                          style: TextStyle(color: kMainColor2, fontSize: 14),
                        ).padding(vertical: 20, horizontal: 10),
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
                  ),
                  verticalSpaceMedium,
                ],
                if (dialogRequest!.data['addCity']) ...[
                  Container(
                    height: 60,
                    width: screenWidthPercentage(context, percentage: 1),
                    decoration: BoxDecoration(
                      color: kTextFiledGrayColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          ' City ',
                          style: TextStyle(color: kMainColor2, fontSize: 14),
                        ).padding(vertical: 20, horizontal: 10),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                value: model.city,
                                iconSize: 24,
                                icon: (null),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                                onChanged: (value) =>
                                    model.updateCity(value: value),
                                items: model
                                    .citiesWithNone()
                                    .map((c) => DropdownMenuItem(
                                          value:
                                              "${c[0]}${c.substring(1).replaceAll('_', ' ').toLowerCase()}",
                                          onTap: () {},
                                          child: SizedBox(
                                            child: Text(
                                              "${c[0]}${c.substring(1).replaceAll('_', ' ').toLowerCase()}",
                                              style: const TextStyle(
                                                  fontFamily: 'Cairo'),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const Spacer(),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kMainGray, width: 1.2)),
                  child: Text(
                    'NEXT'.tr(),
                    style: const TextStyle(color: kMainColor1),
                  ).center(),
                ).gestures(onTap: () {
                  Map<String, dynamic>? body = {};
                  if (dialogRequest!.data['addBirthdate']) {
                    body.addAll({'birth_date': model.birthDate.text});
                  }
                  if (dialogRequest!.data['addGender']) {
                    body.addAll({'gender': model.gender.text[0]});
                  }
                  if (dialogRequest!.data['addCity']) {
                    body.addAll({'city': model.city});
                  }

                  if (body != {}) {
                    model
                        .updateUserData(
                      context: context,
                      body: body,
                    )
                        .then((value) async {
                      model.updateIsClicked(value: false);
                      if (value != null) {
                        model.back();
                      } else {}
                    });
                  }
                }),
              ],
            ),
          ),
        ).height(screenHeightPercentage(context,
            percentage: 0.2 +
                ((dialogRequest!.data['addCity'] ? 0.15 : 0) +
                    (dialogRequest!.data['addCity'] ? 0.15 : 0) +
                    (dialogRequest!.data['addCity'] ? 0.15 : 0))));
      },
      viewModelBuilder: () => AddDataViewModel(),
    );
  }
}
