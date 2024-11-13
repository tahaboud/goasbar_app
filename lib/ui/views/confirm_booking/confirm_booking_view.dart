import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/enum/incdecrease.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/checkout/checkout_view.dart';
import 'package:goasbar/ui/views/confirm_booking/confirm_booking_viewmodel.dart';
import 'package:goasbar/ui/widgets/creation_aware_item.dart';
import 'package:goasbar/ui/widgets/incdecrease_button.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class ConfirmBookingView extends HookWidget {
  const ConfirmBookingView({super.key, this.experience, this.user});
  final ExperienceResults? experience;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    var coupon = useTextEditingController();

    return ViewModelBuilder<ConfirmBookingViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_sharp),
                      onPressed: model.back,
                    ),
                    Text(
                      'Confirm Your Booking'.tr(),
                      style: const TextStyle(fontSize: 21),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                Row(
                  children: [
                    Container(
                      width: 143,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: experience!.profileImage != null
                              ? experience!.profileImage!
                                      .contains('/asbar-icon.ico')
                                  ? BoxFit.none
                                  : BoxFit.cover
                              : BoxFit.contain,
                          image: experience!.profileImage != null &&
                                  !experience!.profileImage!
                                      .contains('/asbar-icon.ico')
                              ? NetworkImage(
                                      "$baseUrl${experience!.profileImage}")
                                  as ImageProvider
                              : const AssetImage("assets/images/image4.png"),
                        ),
                      ),
                    ).center(),
                    horizontalSpaceRegular,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/icons/location.png"),
                            horizontalSpaceTiny,
                            SizedBox(
                              width: 160,
                              child: Text(
                                "${experience!.city![0]}${experience!.city!.substring(1).replaceAll('_', ' ').toLowerCase()} , ${experience!.duration!} ${double.parse(experience!.duration!) >= 2 ? 'Hours'.tr() : 'Hour'.tr()}",
                                style: const TextStyle(
                                    color: kMainGray, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        verticalSpaceMedium,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: kStarColor, size: 18),
                            horizontalSpaceTiny,
                            Text(
                                experience!.rate! == "0.00"
                                    ? "0.0"
                                    : experience!.rate!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(thickness: 1, height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        horizontalSpaceSmall,
                        Text(
                          'Availability'.tr(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset('assets/icons/birth_date.png',
                            color: kMainColor1),
                        horizontalSpaceSmall,
                      ],
                    ).gestures(
                        onTap: () =>
                            model.showAvailableTimingsPicker(context: context)),
                  ],
                ),
                // model.isBusy ? const SizedBox() : model.data!.count == 0 ? const SizedBox() : verticalSpaceMedium,
                // model.isBusy ? const Loader().center() : model.data!.count == 0 ? const SizedBox() : SizedBox(
                //   height: 80,
                //   child: ListView.builder(
                //     itemCount: model.data!.count,
                //     itemBuilder: (context, index) {
                //       return Container(
                //         margin: const EdgeInsets.symmetric(horizontal: 10),
                //         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             Text(model.formatDate(model.data!.results![index].date!), style: TextStyle(color: index == model.selectedIndexDate ? Colors.white : Colors.black)),
                //             verticalSpaceSmall,
                //             Text(model.data!.results![index].date!.substring(8, 10), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: index == model.selectedIndexDate ? Colors.white : Colors.black),)
                //           ],
                //         ),
                //       ).decorated(borderRadius: BorderRadius.circular(10), color: index == model.selectedIndexDate ? kMainColor1 : Colors.transparent, animate: true)
                //           .animate(const Duration(milliseconds: 300), Curves.easeIn)
                //           .gestures(onTap: () {
                //         model.changeSelectionDate(index: index);
                //       });
                //     },
                //     physics: const BouncingScrollPhysics(),
                //     shrinkWrap: true,
                //     scrollDirection: Axis.horizontal,
                //   ).alignment(Alignment.centerLeft),
                // ),
                model.isBusy
                    ? const SizedBox()
                    : model.data!.count == 0
                        ? const SizedBox()
                        : verticalSpaceMedium,
                model.isBusy
                    ? const Loader().center()
                    : model.data!.count == 0
                        ? const SizedBox()
                        : SizedBox(
                            height: 105,
                            child: ListView.builder(
                              itemCount: model.data!.count,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return CreationAwareListItem(
                                  itemCreated: () => model
                                      .getExperiencePublicTimingsFromNextPage(
                                          index: index + 1),
                                  child: ((model.formatYear(model.filterDate1!) < model.formatYear(model.data!.results![index].date!) && model.formatYear(model.filterDate2!) > model.formatYear(model.data!.results![index].date!)) ||
                                          (model.formatYear(model.filterDate2!) == model.formatYear(model.data!.results![index].date!) &&
                                              model.formatYear(model.filterDate1!) <
                                                  model.formatYear(model.data!
                                                      .results![index].date!) &&
                                              model.formatMonth(model.filterDate2!) >=
                                                  model.formatMonth(model.data!
                                                      .results![index].date!) &&
                                              model.formatDay(model.filterDate2!) >=
                                                  model.formatDay(model
                                                      .data!
                                                      .results![index]
                                                      .date!)) ||
                                          (model.formatYear(model.filterDate1!) == model.formatYear(model.data!.results![index].date!) &&
                                              model.formatYear(model.filterDate2!) >
                                                  model.formatYear(
                                                      model.data!.results![index].date!) &&
                                              model.formatMonth(model.filterDate1!) <= model.formatMonth(model.data!.results![index].date!) &&
                                              model.formatDay(model.filterDate1!) <= model.formatDay(model.data!.results![index].date!)) ||
                                          (model.formatMonth(model.filterDate1!) <= model.formatMonth(model.data!.results![index].date!) && model.formatDay(model.filterDate1!) <= model.formatDay(model.data!.results![index].date!) && model.formatMonth(model.filterDate2!) >= model.formatMonth(model.data!.results![index].date!) && model.formatDay(model.filterDate2!) >= model.formatDay(model.data!.results![index].date!)))
                                      ? Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                  model.formatDate(model.data!
                                                      .results![index].date!),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: index ==
                                                              model
                                                                  .selectedIndex
                                                          ? Colors.white
                                                          : Colors.black)),
                                              Text(
                                                "${model.data!.results![index].date!.substring(8, 10)}/${model.data!.results![index].date!.substring(5, 7)}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: index ==
                                                            model.selectedIndex
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                              Text(
                                                  model.data!.results![index]
                                                      .startTime!
                                                      .substring(0, 5),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: index ==
                                                              model
                                                                  .selectedIndex
                                                          ? Colors.white
                                                          : kMainColor1)),
                                            ],
                                          ),
                                        ).decorated(border: Border.all(color: Colors.black38, width: model.selectedIndex == index ? 0 : 2), borderRadius: BorderRadius.circular(10), color: index == model.selectedIndex ? kMainColor1 : Colors.transparent, animate: true).padding(right: 10).animate(const Duration(milliseconds: 300), Curves.easeIn).gestures(onTap: () {
                                          model.changeSelection(index: index);
                                        })
                                      : Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Column(
                                            children: [
                                              Text(
                                                  model.formatDate(model.data!
                                                      .results![index].date!),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: index ==
                                                              model
                                                                  .selectedIndex
                                                          ? Colors.white
                                                          : Colors.black)),
                                              verticalSpaceSmall,
                                              Text(
                                                "${model.data!.results![index].date!.substring(8, 10)}/${model.data!.results![index].date!.substring(5, 7)}",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: index ==
                                                            model.selectedIndex
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                              verticalSpaceSmall,
                                              Text(
                                                  model.data!.results![index]
                                                      .startTime!
                                                      .substring(0, 5),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: index ==
                                                              model
                                                                  .selectedIndex
                                                          ? Colors.white
                                                          : kMainColor1)),
                                            ],
                                          ),
                                        )
                                          .decorated(
                                            border: Border.all(
                                                color: Colors.black12
                                                    .withOpacity(0.1),
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )
                                          .padding(right: 10),
                                );
                              },
                            ),
                          ),
                const Divider(thickness: 1.2, height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        horizontalSpaceSmall,
                        SizedBox(
                          width: screenWidthPercentage(context, percentage: 1) -
                              50,
                          child: Text(
                            model.selectedIndex == null
                                ? '${"Available Seats".tr()} : ${"Pick a timing first".tr()}'
                                : '${"Available Seats".tr()} : ${model.data!.results![model.selectedIndex!].availability} / ${model.data!.results![model.selectedIndex!].capacity}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(thickness: 1.2, height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        horizontalSpaceSmall,
                        Text(
                          'Number of Guests'.tr(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IncDecreaseButton(
                          incDecrease: IncDecrease.increase,
                          model: model,
                        ),
                        horizontalSpaceSmall,
                        Text(
                            model.numberOfGuests! < 10
                                ? '0${model.numberOfGuests}'
                                : '${model.numberOfGuests}',
                            style: const TextStyle(fontSize: 20)),
                        horizontalSpaceSmall,
                        IncDecreaseButton(
                            incDecrease: IncDecrease.decrease, model: model),
                        horizontalSpaceSmall,
                      ],
                    ),
                  ],
                ),
                for (var i = 0; i < model.numberOfGuests!; i++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpaceSmall,
                      Text(
                        "${'Guest'.tr()} ${i + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      verticalSpaceSmall,
                      TextField(
                        controller: model.firstNames[i],
                        decoration: InputDecoration(
                          hintText: 'Guest First Name'.tr(),
                          hintStyle: const TextStyle(fontSize: 14),
                          // prefixText: 'Saudi Arabia ( +966 ) | ',
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
                      verticalSpaceRegular,
                      TextField(
                        controller: model.lastNames[i],
                        decoration: InputDecoration(
                          hintText: 'Guest Last Name'.tr(),
                          hintStyle: const TextStyle(fontSize: 14),
                          // prefixText: 'Saudi Arabia ( +966 ) | ',
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
                      verticalSpaceRegular,
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: model.age[i],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            model.validateIsNumeric(value: value),
                        decoration: InputDecoration(
                          hintText: 'Guest Age'.tr(),
                          hintStyle: const TextStyle(fontSize: 14),
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
                      verticalSpaceRegular,
                      SizedBox(
                          height: 60,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
                                value: model.genders[i].text,
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                decoration: InputDecoration(
                                  hintText: "",
                                  fillColor: kTextFiledGrayColor,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(color: Colors.black),
                                onChanged: (String? value) {
                                  model.genders[i].text = value ?? "";
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: "",
                                    enabled: false,
                                    child: Text(
                                      'Guest Gender'.tr(),
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "M",
                                    child: Text("Male".tr()),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "F",
                                    child: Text("Female".tr()),
                                  ),
                                ]),
                          )),
                      verticalSpaceRegular,
                      TextFormField(
                        controller: model.phones[i],
                        validator: (value) =>
                            model.validatePhoneNumber(value: value),
                        textDirection: TextDirection.ltr,
                        keyboardType: TextInputType.number,
                        maxLength: 9,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'xx x - xx x - xx x',
                          hintTextDirection: TextDirection.ltr,
                          hintStyle: const TextStyle(
                            fontSize: 14,
                          ),
                          counterText: '',
                          // prefixText: 'Saudi Arabia ( +966 ) | ',
                          suffixIcon: const Text(
                            '( +966 ) |',
                            style: TextStyle(color: kMainGray, fontSize: 14),
                            textDirection: TextDirection.ltr,
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
                      verticalSpaceRegular,
                    ],
                  ),
                const Divider(thickness: 1.2, height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        horizontalSpaceSmall,
                        Text(
                          'Trip Coupon'.tr(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width:
                              screenWidthPercentage(context, percentage: 0.3),
                          height: 40,
                          child: TextField(
                            controller: coupon,
                            decoration: InputDecoration(
                              hintText: 'trips 05',
                              hintStyle: const TextStyle(
                                fontSize: 14,
                              ),
                              fillColor: Colors.transparent,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: kTextFiledGrayColor),
                              ),
                            ),
                          ),
                        ),
                        horizontalSpaceSmall,
                      ],
                    ),
                  ],
                ),
                verticalSpaceLarge,
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: kMainGradient,
                  ),
                  child: model.isClicked!
                      ? const Loader().center()
                      : Text(
                          'Continue with Payment Send Request'.tr(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ).center(),
                ).gestures(
                  onTap: () {
                    bool? isOkay = true;
                    if (model.selectedIndex == null) {
                      showMotionToast(
                          context: context,
                          msg: "Select a Timing First.",
                          title: 'Warning',
                          type: MotionToastType.warning);
                    } else {
                      Map<String, dynamic>? body = {};
                      List<Map?> affiliateSet = [];
                      if (coupon.text.isNotEmpty) {
                        body.addAll({'coupon': coupon.text});
                      }

                      for (var i = 0; i < model.numberOfGuests!; i++) {
                        isOkay = false;
                        if (model.firstNames[i].text.isEmpty) {
                          showMotionToast(
                              context: context,
                              msg: "Guest ${i + 1} first name is required.",
                              title: 'Warning',
                              type: MotionToastType.warning);
                        } else if (model.lastNames[i].text.isEmpty) {
                          showMotionToast(
                              context: context,
                              msg: "Guest ${i + 1} last name is required.",
                              title: 'Warning',
                              type: MotionToastType.warning);
                        } else if (model.age[i].text.isEmpty) {
                          showMotionToast(
                              context: context,
                              msg: "Guest ${i + 1} age is required.",
                              title: 'Warning',
                              type: MotionToastType.warning);
                        } else if (model.genders[i].text.isEmpty) {
                          showMotionToast(
                              context: context,
                              msg: "Guest ${i + 1} gender name is required.",
                              title: 'Warning',
                              type: MotionToastType.warning);
                        } else {
                          isOkay = true;
                          if (model.phones[i].text.isNotEmpty) {
                            affiliateSet.add({
                              "first_name": model.firstNames[i].text,
                              "last_name": model.lastNames[i].text,
                              "age": model.age[i].text,
                              "gender": model.genders[i].text.toUpperCase(),
                              "phone_number": "+966${model.phones[i].text}"
                            });
                          } else {
                            affiliateSet.add({
                              "first_name": model.firstNames[i].text,
                              "last_name": model.lastNames[i].text,
                              "age": model.age[i].text,
                              "gender": model.genders[i].text.toUpperCase(),
                            });
                          }
                        }
                      }

                      if (affiliateSet.isNotEmpty) {
                        body.addAll({
                          "affiliate_set": affiliateSet,
                        });
                      }

                      bool? addCity = false,
                          addGender = false,
                          addBirthdate = false;

                      if (user!.birthDate == null) {
                        addBirthdate = true;
                      }
                      if (user!.city == null) {
                        addCity = true;
                      }
                      if (user!.gender == null) {
                        addGender = true;
                      }
                      if (addGender || addBirthdate || addCity) {
                        model.showDialog(
                            addGender: addGender,
                            addBirthdate: addBirthdate,
                            addCity: addCity,
                            execute: () {
                              if (isOkay!) {
                                model.updateIsClicked(value: true);
                                model
                                    .createBooking(
                                        context: context,
                                        body: body,
                                        timingId: model.timingListModel!
                                            .results![model.selectedIndex!].id)
                                    .then((value) {
                                  model.updateIsClicked(value: false);
                                  if (value != null) {
                                    model.navigateTo(
                                        view: CheckoutView(
                                      experience: experience,
                                      user: user,
                                      usersCount: model.numberOfGuests! + 1,
                                      booking: value,
                                      paymentUrl: value.paymentUrl,
                                    ));
                                  } else {}
                                });
                              }
                            });
                      } else {
                        if (isOkay!) {
                          model
                              .createBooking(
                                  context: context,
                                  body: body,
                                  timingId: model.timingListModel!
                                      .results![model.selectedIndex!].id)
                              .then((value) {
                            model.updateIsClicked(value: false);
                            if (value != null) {
                              model.navigateTo(
                                  view: CheckoutView(
                                experience: experience,
                                user: user,
                                usersCount: model.numberOfGuests! + 1,
                                booking: value,
                                paymentUrl: value.paymentUrl,
                              ));
                            } else {}
                          });
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ConfirmBookingViewModel(
          context: context, experienceId: experience!.id),
    );
  }
}
