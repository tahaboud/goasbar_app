import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/bookings_list/bookings_list_viewmodel.dart';
import 'package:goasbar/ui/widgets/booking_card/booking_card.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BookingsListView extends HookWidget {
  const BookingsListView({Key? key, this.user}) : super(key: key);
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BookingsListViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                verticalSpaceMedium,
                Row(
                  children: [
                    const Icon(CupertinoIcons.arrow_turn_up_left).height(40)
                        .width(40)
                        .gestures(
                      onTap: () {
                        model.back();
                      },
                    ).alignment(Alignment.centerLeft),
                    const Text('Bookings List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
                verticalSpaceMedium,
                model.isBusy ? const Loader().center()
                    : !model.dataReady ? const Text('You have no bookings').center() : model.data!.isEmpty
                    ? const Text('You have no bookings').center() : Expanded(child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: model.data!.length,
                      itemBuilder: (ctx, index) {
                        return BookingItem(bookingsList: model.data![index], user: user, onDelete: () {
                          model.deleteBooking(context: context, bookingId: model.data![index]!.id).then((value) {
                            if (value != null) {
                              if (value) {
                                showMotionToast(context: context, title: 'Deleted Booking Successfully', msg: "The booking is deleted, you will receive your refund", type: MotionToastType.success);
                              }
                            }
                          });
                        });
                      },
                    )
                ),
              ],
            ),
          )
        ),
      ),
      viewModelBuilder: () => BookingsListViewModel(context: context),
    );
  }
}