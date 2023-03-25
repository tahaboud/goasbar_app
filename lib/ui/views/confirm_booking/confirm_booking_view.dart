import 'package:flutter/material.dart';
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
import 'package:flutter_hooks/flutter_hooks.dart';

class ConfirmBookingView extends HookWidget {
  const ConfirmBookingView({Key? key, this.experience, this.user}) : super(key: key);
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_back_sharp).height(40)
                        .width(40)
                        .gestures(
                        onTap: () {
                          model.back();
                        }
                    ),
                    const Text('Confirm Your Booking', style: TextStyle(fontSize: 21),),
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
                          fit: experience!.profileImage != null ? experience!.profileImage!.contains('/asbar-icon.ico') ? BoxFit.none : BoxFit.cover : BoxFit.contain,
                          image: experience!.profileImage != null && !experience!.profileImage!.contains('/asbar-icon.ico')
                              ? NetworkImage("$baseUrl${experience!.profileImage}") as ImageProvider
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
                                "${experience!.city!} , ${experience!.duration!} ${double.parse(experience!.duration!) >= 2 ? 'Hours' : 'Hour'}",
                                style: const TextStyle(color: kMainGray, fontSize: 11),
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
                            Text(experience!.rate! == "0.00" ? "0.0" : experience!.rate!, style: const TextStyle(fontWeight: FontWeight.bold,)),
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
                      children: const [
                        horizontalSpaceSmall,
                        Text('Available Timings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset('assets/icons/birth_date.png', color: kMainColor1),
                        horizontalSpaceSmall,
                      ],
                    ).gestures(onTap: () => model.showAvailableTimingsPicker(context: context)),
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
                model.isBusy ? const SizedBox() : model.data!.count == 0 ? const SizedBox() : verticalSpaceMedium,
                model.isBusy ? const Loader().center() : model.data!.count == 0 ? const SizedBox() : SizedBox(
                  height: 82,
                  child: ListView.builder(
                    itemCount: model.data!.count,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return CreationAwareListItem(
                        itemCreated: () => model.getExperiencePublicTimingsFromNextPage(index: index + 1),
                        child: (model.formatYear(model.filterDate1!) <=  model.formatYear(model.data!.results![index].date!)
                            && model.formatMonth(model.filterDate1!) <=  model.formatMonth(model.data!.results![index].date!)
                            && model.formatDay(model.filterDate1!) <=  model.formatDay(model.data!.results![index].date!)
                            && model.formatYear(model.filterDate2!) >=  model.formatYear(model.data!.results![index].date!)
                            && model.formatMonth(model.filterDate2!) >=  model.formatMonth(model.data!.results![index].date!)
                            && model.formatDay(model.filterDate2!) >=  model.formatDay(model.data!.results![index].date!)) ? Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(model.formatDate(model.data!.results![index].date!), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: index == model.selectedIndex ? Colors.white : Colors.black)),
                                  horizontalSpaceSmall,
                                  Text(model.data!.results![index].date!.substring(8, 10), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: index == model.selectedIndex ? Colors.white : Colors.black),)
                                ],
                              ),
                              verticalSpaceSmall,
                              Text(model.data!.results![index].startTime!.substring(0, 5), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: index == model.selectedIndex ? Colors.white : kMainColor1)),
                            ],
                          ),
                        ).decorated(border: Border.all(color: Colors.black38, width: model.selectedIndex == index ? 0 : 2),
                            borderRadius: BorderRadius.circular(10), color: index == model.selectedIndex ? kMainColor1 : Colors.transparent,
                            animate: true)
                            .padding(right: 10)
                            .animate(const Duration(milliseconds: 300), Curves.easeIn)
                            .gestures(onTap: () {
                          model.changeSelection(index: index);
                        }) : Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(model.formatDate(model.data!.results![index].date!), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.4))),
                                  horizontalSpaceSmall,
                                  Text(model.data!.results![index].date!.substring(8, 10), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.4)),)
                                ],
                              ),
                              verticalSpaceSmall,
                              Text(model.data!.results![index].startTime!.substring(0, 5), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: kMainColor1.withOpacity(0.4))),
                            ],
                          ),
                        ).decorated(border: Border.all(
                            color: Colors.black12.withOpacity(0.1), width: 2),
                          borderRadius: BorderRadius.circular(10),)
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
                      children: const [
                        horizontalSpaceSmall,
                        Text('Available Places', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('View', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: kMainColor1),).gestures(onTap: () {
                          if (model.selectedIndex == null) {
                            showMotionToast(context: context, type: MotionToastType.warning, title: 'Warning', msg: "Select a timing to show available places!.");
                          } else {
                            model.showAvailablePlacesDialog(
                              timingResponse: model.data!.results![model.selectedIndex!],
                            );
                          }
                        }),
                        horizontalSpaceSmall,
                      ],
                    ),
                  ],
                ),
                const Divider(thickness: 1.2, height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        horizontalSpaceSmall,
                        Text('Number of Guests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                      ],
                    ),
                    Row(
                      children: [
                        IncDecreaseButton(incDecrease: IncDecrease.increase, model: model,),
                        horizontalSpaceSmall,
                        Text(model.numberOfGuests! < 10 ? '0${model.numberOfGuests}' : '${model.numberOfGuests}', style: const TextStyle(fontSize: 20)),
                        horizontalSpaceSmall,
                        IncDecreaseButton(incDecrease: IncDecrease.decrease, model: model),
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
                      Text("Guest ${i+1}", style: const TextStyle(fontWeight: FontWeight.bold),),
                      verticalSpaceSmall,
                      TextField(
                        controller: model.firstNames[i],
                        decoration: InputDecoration(
                          hintText: 'Guest First Name',
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
                          hintText: 'Guest Last Name',
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
                        keyboardType: TextInputType.number,
                        controller: model.age[i],
                        decoration: InputDecoration(
                          hintText: 'Guest Age',
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
                        child: TextField(
                          readOnly: true,
                          controller: model.genders[i],
                          decoration: InputDecoration(
                            hintText: 'Guest Gender',
                            hintStyle: const TextStyle(fontSize: 14),
                            suffixIcon: Image.asset('assets/icons/drop_down.png')
                                .gestures(onTap: () {
                              model.showSelectionDialog(gender: model.genders[i].text, index: i);
                            }),
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
                      verticalSpaceRegular,
                      TextFormField(
                        controller: model.phones[i],
                        validator: (value) => model.validatePhoneNumber(value: value),
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'xx x - xx x - xx x',
                          hintStyle: const TextStyle(fontSize: 14),
                          // prefixText: 'Saudi Arabia ( +966 ) | ',
                          prefixIcon: const Text('Saudi Arabia ( +966 )  |', style: TextStyle(color: kMainGray, fontSize: 14),).padding(vertical: 20, horizontal: 10),
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
                      children: const [
                        horizontalSpaceSmall,
                        Text('You have Trip coupon ?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidthPercentage(context, percentage: 0.3),
                          height: 40,
                          child: TextField(
                            controller: coupon,
                            decoration: InputDecoration(
                              hintText: 'trips 05',
                              hintStyle: const TextStyle(fontSize: 14,),
                              fillColor: Colors.transparent,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: kTextFiledGrayColor),
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
                  child: model.isClicked! ? const Loader().center() :const Text('Continue with payment', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),).center(),
                ).gestures(
                  onTap:  () {
                    bool? isOkay = true;
                    if (model.selectedIndex == null)  {
                      showMotionToast(context: context, msg: "Select a Timing First.", title: 'Warning', type: MotionToastType.warning);
                    } else {
                      Map<String, dynamic>? body = {};
                      List<Map?> affiliateSet = [];
                      if (coupon.text.isNotEmpty) body.addAll({'coupon': coupon.text});

                      for (var i = 0; i < model.numberOfGuests!; i++) {
                        isOkay = false;
                        if (model.firstNames[i].text.isEmpty) {
                          showMotionToast(context: context, msg: "Guest ${i+1} first name is required.", title: 'Warning', type: MotionToastType.warning);
                        } else if (model.lastNames[i].text.isEmpty) {
                          showMotionToast(context: context, msg: "Guest ${i+1} last name is required.", title: 'Warning', type: MotionToastType.warning);
                        } else if (model.age[i].text.isEmpty) {
                          showMotionToast(context: context, msg: "Guest ${i+1} age is required.", title: 'Warning', type: MotionToastType.warning);
                        } else if (model.genders[i].text.isEmpty) {
                          showMotionToast(context: context, msg: "Guest ${i+1} gender name is required.", title: 'Warning', type: MotionToastType.warning);
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


                      if (affiliateSet.isNotEmpty) body.addAll({"affiliate_set": affiliateSet,});

                      if (isOkay!) {
                        model.createBooking(context: context, body: body, timingId: model.timingListModel!.results![model.selectedIndex!].id).then((value) {
                          model.updateIsClicked(value: false);
                          if (value != null) {
                            model.navigateTo(view: CheckoutView(experience: experience, user: user,));
                          } else {
                            showMotionToast(context: context, msg: "An error occurred while creating the booking, please try again.", title: 'Create Booking Failed', type: MotionToastType.error);
                          }
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ConfirmBookingViewModel(experienceId: experience!.id),
    );
  }
}
