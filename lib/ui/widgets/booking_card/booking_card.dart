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
  }) : super(key: key);
  final BookingsListResults? bookingsList;
  final UserModel? user;
  final Function? onDelete;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BookingItemViewModel>.reactive(
      builder: (context, model, child)  {
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/image4.png"),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              width: screenWidthPercentage(context, percentage: 1) - 60,
              height: screenHeightPercentage(context, percentage: 0.3),
            ).center(),
            Positioned(
              top: 10,
              right: 30,
              child: (model.formatYear(bookingsList!.experienceTiming!.date!) < model.formatYearFromToday())

                  || (model.formatMonth(bookingsList!.experienceTiming!.date!) < model.formatMonthFromToday()
                      && model.formatYear(bookingsList!.experienceTiming!.date!) <= model.formatYearFromToday())

                  || (model.formatDay(bookingsList!.experienceTiming!.date!) < model.formatDayFromToday()
                      && model.formatMonth(bookingsList!.experienceTiming!.date!) <= model.formatMonthFromToday()
                      && model.formatYear(bookingsList!.experienceTiming!.date!) <= model.formatYearFromToday()) ? Row(
                children: const [
                  Chip(
                    backgroundColor: Colors.redAccent,
                    label: Text("COMPLETED", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ) : Chip(
                backgroundColor: kMainColor1,
                label: Text(bookingsList!.status!, style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            Positioned(
              bottom: 25,
              left: 5,
              child: Container(
                height: screenHeightPercentage(context, percentage: 0.14),
                width: screenWidthPercentage(context, percentage: 0.7) - 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1,
                      offset: Offset(0, 0),
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    verticalSpaceSmall,
                    Row(
                      children: [
                        horizontalSpaceSmall,
                        Text(bookingsList!.experienceTiming!.experienceName!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Row(
                          children: [
                            Text('${bookingsList!.price!} SR', style: const TextStyle(color: kMainColor1, fontSize: 9)),
                            const Text(' / Person', style: TextStyle(color: kMainGray, fontSize: 9)),
                          ],
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
                        Text("The ${bookingsList!.experienceTiming!.date!}, at ${bookingsList!.experienceTiming!.startTime!.substring(0, 5)}", style: const TextStyle(color: kMainGray, fontSize: 11))
                      ],
                    ),
                    verticalSpaceSmall,
                    Row(
                      children: [
                        horizontalSpaceSmall,
                        Container(
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
                              const Text('Review', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),).center(),
                            ],
                          ),
                        ).gestures(onTap: () => model.showReviewBottomSheet(bookingId: bookingsList!.id)),
                        const Spacer(),
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
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
      viewModelBuilder: () => BookingItemViewModel(user: user),
    );
  }
}