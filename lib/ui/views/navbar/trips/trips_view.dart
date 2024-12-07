import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/navbar/trips/trips_viewmodel.dart';
import 'package:goasbar/ui/widgets/booking_card/booking_card.dart';
import 'package:goasbar/ui/widgets/creation_aware_item.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class TripsView extends HookWidget {
  const TripsView({super.key, this.text, this.user});
  final String? text;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TripsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            height: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                verticalSpaceMedium,
                Text(
                  text!,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ).alignment(Alignment.centerRight),
                verticalSpaceMedium,
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      categoryItem(
                          model: model,
                          index: 1,
                          image: 'hosted',
                          text: "All".tr()),
                      horizontalSpaceSmall,
                      categoryItem(
                          model: model, index: 2, text: "Completed".tr()),
                      horizontalSpaceSmall,
                      categoryItem(
                          model: model, index: 3, text: "Not Completed".tr()),
                    ],
                  ),
                ),
                verticalSpaceMedium,
                model.isBusy
                    ? const Loader().center()
                    : !model.dataReady
                        ? Text('No trips right now'.tr()).center()
                        : model.data!.isEmpty
                            ? Text('No trips right now'.tr()).center()
                            : Expanded(
                                child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: model.data!.length,
                                itemBuilder: (ctx, index) {
                                  return CreationAwareListItem(
                                    itemCreated: () =>
                                        model.getUserBookingsFromNextPage(
                                            index: index + 1),
                                    child: BookingItem(
                                      user: user,
                                      bookingsList: model.data![index],
                                      onUpdate: () {
                                        model.showReviewBottomSheet(
                                            user: user,
                                            review: model.data![index]!.review,
                                            bookingId: model.data![index]!.id);
                                      },
                                      onDelete: () {
                                        model
                                            .deleteBooking(
                                                context: context,
                                                bookingId:
                                                    model.data![index]!.id)
                                            .then(
                                          (value) {
                                            if (value != null) {
                                              if (value) {
                                                showMotionToast(
                                                    context: context,
                                                    title:
                                                        'Deleted Booking Successfully',
                                                    msg:
                                                        "Booking deleted, you will receive your refund",
                                                    type: MotionToastType
                                                        .success);
                                              } else {}
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                              )),
              ],
            ),
          ),
        )),
      ),
      viewModelBuilder: () => TripsViewModel(),
    );
  }

  Widget categoryItem(
      {TripsViewModel? model, int? index, String? image, String? text}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Row(
        children: [
          image != null
              ? Image.asset(
                  "assets/icons/settings/$image.png",
                  color: index == model!.index ? Colors.white : Colors.grey,
                )
              : Container(),
          image != null ? horizontalSpaceTiny : Container(),
          Text(text!,
              style: TextStyle(
                color: model!.index == index ? Colors.white : kMainGray,
              )),
        ],
      ),
    )
        .backgroundGradient(
            model.index == index ? kMainGradient : kDisabledGradient,
            animate: true)
        .clipRRect(all: 10)
        .animate(const Duration(milliseconds: 200), Curves.easeIn)
        .gestures(onTap: () {
      model.selectCategory(ind: index);
    });
  }
}
