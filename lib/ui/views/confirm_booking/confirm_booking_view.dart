import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/checkout/checkout_view.dart';
import 'package:goasbar/ui/views/confirm_booking/available_seats_section.dart';
import 'package:goasbar/ui/views/confirm_booking/available_timings_section.dart';
import 'package:goasbar/ui/views/confirm_booking/confirm_booking_viewmodel.dart';
import 'package:goasbar/ui/views/confirm_booking/coupon_section.dart';
import 'package:goasbar/ui/views/confirm_booking/experience_info_section.dart';
import 'package:goasbar/ui/views/confirm_booking/guest_item_data.dart';
import 'package:goasbar/ui/views/confirm_booking/guests_count_section.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class ConfirmBookingView extends HookWidget {
  const ConfirmBookingView({super.key, this.experience, this.user});
  final ExperienceResults? experience;
  final UserModel? user;

  void handleBook(ConfirmBookingViewModel model, context, coupon) {
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

      bool? addCity = false, addGender = false, addBirthdate = false;

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
                        timingId: model
                            .timingListModel!.results![model.selectedIndex!].id)
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
                  timingId:
                      model.timingListModel!.results![model.selectedIndex!].id)
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
  }

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
                ExperienceInfoSection(experience: experience!),
                const Divider(thickness: 1, height: 40),
                AvailableTimingsSection(model: model),
                const Divider(thickness: 1.2, height: 40),
                AvailableSeatsSection(model: model),
                const Divider(thickness: 1.2, height: 40),
                GuestsCountSection(model: model),
                for (var i = 0; i < model.numberOfGuests!; i++)
                  GuestItemData(model: model, index: i),
                const Divider(thickness: 1.2, height: 40),
                CouponSection(model: model, coupon: coupon),
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
                ).gestures(onTap: () => handleBook(model, context, coupon)),
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
