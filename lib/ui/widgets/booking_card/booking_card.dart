import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/data_models/bookings_list_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/trip_detail/trip_detail_view.dart';
import 'package:goasbar/ui/widgets/booking_card/booking_card_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class BookingItem extends StatelessWidget {
  const BookingItem(
      {Key? key, this.bookingsList, this.onDelete, this.onUpdate, this.user})
      : super(key: key);
  final BookingsListResults? bookingsList;
  final Function? onDelete;
  final Function? onUpdate;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BookingItemViewModel>.reactive(
      builder: (context, model, child) {
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              width: screenWidthPercentage(context, percentage: 1) - 60,
              height: screenHeightPercentage(context, percentage: 0.17),
              child: Column(
                children: [
                  verticalSpaceSmall,
                  Row(
                    children: [
                      horizontalSpaceSmall,
                      Text(bookingsList!.experienceTiming!.title!,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Row(
                        children: [
                          Text('${bookingsList!.price!} ${"SR".tr()}',
                              style: const TextStyle(
                                color: kMainColor1,
                              )),
                          Text(' / Person'.tr(),
                              style: const TextStyle(
                                color: kMainGray,
                              )),
                        ],
                      ),
                      horizontalSpaceSmall,
                    ],
                  ),
                  verticalSpaceSmall,
                  Row(
                    children: [
                      horizontalSpaceSmall,
                      Image.asset("assets/icons/location.png"),
                      horizontalSpaceTiny,
                      Text(
                          "${bookingsList!.experienceTiming!.place!}, ${double.parse(bookingsList!.experienceTiming!.duration!)} ${double.parse(bookingsList!.experienceTiming!.duration!) >= 2 ? 'Hours'.tr() : 'Hour'.tr()}",
                          style:
                              const TextStyle(color: kMainGray, fontSize: 11)),
                      const Spacer(),
                      Container(
                        width: 70,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: bookingsList!.status == "CONFIRMED"
                              ? kMainColor1
                              : Colors.redAccent,
                        ),
                        child: Text(
                          bookingsList!.status!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ).center(),
                      ),
                      horizontalSpaceSmall,
                    ],
                  ),
                  verticalSpaceSmall,
                  Row(
                    children: [
                      horizontalSpaceSmall,
                      Image.asset("assets/icons/birth_date.png"),
                      horizontalSpaceTiny,
                      Text(
                          "The ${bookingsList!.experienceTiming!.date!} at ${bookingsList!.experienceTiming!.startTime}",
                          style:
                              const TextStyle(color: kMainGray, fontSize: 11)),
                      const Spacer(),
                      (model.formatYear(bookingsList!.experienceTiming!.date!) <
                                  model.formatYearFromToday()) ||
                              (model.formatMonth(bookingsList!.experienceTiming!.date!) <
                                      model.formatMonthFromToday() &&
                                  model.formatYear(bookingsList!
                                          .experienceTiming!.date!) <=
                                      model.formatYearFromToday()) ||
                              (model.formatDay(bookingsList!.experienceTiming!.date!) <
                                      model.formatDayFromToday() &&
                                  model.formatMonth(bookingsList!
                                          .experienceTiming!.date!) <=
                                      model.formatMonthFromToday() &&
                                  model.formatYear(bookingsList!
                                          .experienceTiming!.date!) <=
                                      model.formatYearFromToday())
                          ? Container(
                              width: 70,
                              height: 25,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(35)),
                                color: kMainColor1,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.white, size: 15),
                                  horizontalSpaceTiny,
                                  Text(
                                    bookingsList!.review != null
                                        ? bookingsList!.review!.rate.toString()
                                        : 'Review',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  ).center(),
                                ],
                              ),
                            ).gestures(onTap: () => onUpdate!())
                          : const SizedBox(),
                      (model.formatYear(bookingsList!.experienceTiming!.date!) <
                                  model.formatYearFromToday()) ||
                              (model.formatMonth(bookingsList!.experienceTiming!.date!) <
                                      model.formatMonthFromToday() &&
                                  model.formatYear(bookingsList!
                                          .experienceTiming!.date!) <=
                                      model.formatYearFromToday()) ||
                              (model.formatDay(bookingsList!.experienceTiming!.date!) <
                                      model.formatDayFromToday() &&
                                  model.formatMonth(bookingsList!
                                          .experienceTiming!.date!) <=
                                      model.formatMonthFromToday() &&
                                  model.formatYear(bookingsList!
                                          .experienceTiming!.date!) <=
                                      model.formatYearFromToday())
                          ? horizontalSpaceTiny
                          : const SizedBox(),
                      Container(
                        width: 70,
                        height: 25,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          color: Colors.redAccent,
                        ),
                        child: Text(
                          'Delete'.tr(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
                        ).center(),
                      ).gestures(onTap: () => onDelete!()),
                      horizontalSpaceSmall,
                    ],
                  ),
                  verticalSpaceSmall,
                ],
              ),
            ).center().gestures(
                onTap: () => {
                      model.navigateTo(
                        view: TripDetailView(
                          isUser: true,
                          experience: bookingsList!.experience,
                          user: user,
                          showBookingFooter: false,
                        ),
                      )
                    }),
          ],
        );
      },
      viewModelBuilder: () => BookingItemViewModel(),
    );
  }
}
