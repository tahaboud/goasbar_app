import 'package:flutter/material.dart';
import 'package:goasbar/data_models/bookings_list_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/booking_card/booking_card_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class BookingItem extends StatelessWidget {
  const BookingItem({
    Key? key,
    this.bookingsList,
    this.user,
    this.onDelete,
    this.onUpdate,
  }) : super(key: key);
  final BookingsListResults? bookingsList;
  final UserModel? user;
  final Function? onDelete;
  final Function()? onUpdate;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BookingItemViewModel>.reactive(
      builder: (context, model, child)  {
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              width: screenWidthPercentage(context, percentage: 1) - 60,
              height: screenHeightPercentage(context, percentage: 0.15),
              child: Column(
                children: [
                  verticalSpaceSmall,
                  Row(
                    children: [
                      horizontalSpaceSmall,
                      Text(bookingsList!.experienceTiming!.title!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Row(
                        children: [
                          Text('${bookingsList!.price!} SR', style: const TextStyle(color: kMainColor1, )),
                          const Text(' / Person', style: TextStyle(color: kMainGray,)),
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
                      Text("${bookingsList!.experienceTiming!.place!}, ${double.parse(bookingsList!.experienceTiming!.duration!) >= 2 ? 'Hours' : 'Hour'}", style: const TextStyle(color: kMainGray, fontSize: 11)),
                      const Spacer(),
                      Container(
                        width: 70,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: bookingsList!.status == "CONFIRMED" ? kMainColor1 : Colors.redAccent,
                        ),
                        child: Text(bookingsList!.status!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),).center(),
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
                      Text("The ${bookingsList!.experienceTiming!.date!}", style: const TextStyle(color: kMainGray, fontSize: 11)),
                      const Spacer(),
                      (model.formatYear(bookingsList!.experienceTiming!.date!) < model.formatYearFromToday())

                          || (model.formatMonth(bookingsList!.experienceTiming!.date!) < model.formatMonthFromToday()
                          && model.formatYear(bookingsList!.experienceTiming!.date!) <= model.formatYearFromToday())

                          || (model.formatDay(bookingsList!.experienceTiming!.date!) < model.formatDayFromToday()
                          && model.formatMonth(bookingsList!.experienceTiming!.date!) <= model.formatMonthFromToday()
                          && model.formatYear(bookingsList!.experienceTiming!.date!) <= model.formatYearFromToday()) ? Container(
                        width: 70,
                        height: 25,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                          color: kMainColor1,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Colors.white, size: 15),
                            horizontalSpaceTiny,
                            Text(bookingsList!.review != null ? bookingsList!.review!.rate.toString() : 'Review', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),).center(),
                          ],
                        ),
                      ).gestures(onTap: () {
                        model.showReviewBottomSheet(review: bookingsList!.review, bookingId: bookingsList!.id).then((value) {
                          if (value) {
                            onUpdate!();
                          }
                        });
                      }) : const SizedBox(),
                      (model.formatYear(bookingsList!.experienceTiming!.date!) < model.formatYearFromToday())

                          || (model.formatMonth(bookingsList!.experienceTiming!.date!) < model.formatMonthFromToday()
                          && model.formatYear(bookingsList!.experienceTiming!.date!) <= model.formatYearFromToday())

                          || (model.formatDay(bookingsList!.experienceTiming!.date!) < model.formatDayFromToday()
                          && model.formatMonth(bookingsList!.experienceTiming!.date!) <= model.formatMonthFromToday()
                          && model.formatYear(bookingsList!.experienceTiming!.date!) <= model.formatYearFromToday()) ? horizontalSpaceTiny : const SizedBox(),

                      Container(
                        width: 70,
                        height: 25,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          color: Colors.redAccent,
                        ),
                        child: const Text('Delete', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),).center(),
                      ).gestures(onTap: () => onDelete!()),
                      horizontalSpaceSmall,
                    ],
                  ),
                  verticalSpaceSmall,
                ],
              ),
            ).center(),
          ],
        );
      },
      viewModelBuilder: () => BookingItemViewModel(user: user),
    );
  }
}