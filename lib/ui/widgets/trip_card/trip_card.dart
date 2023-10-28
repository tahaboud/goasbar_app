import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/confirm_booking/confirm_booking_view.dart';
import 'package:goasbar/ui/views/login/login_view.dart';
import 'package:goasbar/ui/views/trip_detail/trip_detail_view.dart';
import 'package:goasbar/ui/widgets/trip_card/trip_card_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class TripItem extends StatelessWidget {
  const TripItem({
    Key? key,
    this.experience,
    this.user,
    this.isUser,
  }) : super(key: key);
  final ExperienceResults? experience;
  final UserModel? user;
  final bool? isUser;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TripItemViewModel>.reactive(
      builder: (context, model, child) {
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: experience!.profileImage != null
                      ? experience!.profileImage!.contains('/asbar-icon.ico')
                          ? BoxFit.cover
                          : BoxFit.cover
                      : BoxFit.contain,
                  image: experience!.profileImage != null &&
                          !experience!.profileImage!.contains('/asbar-icon.ico')
                      ? NetworkImage("$baseUrl${experience!.profileImage}")
                          as ImageProvider
                      : const AssetImage("assets/images/image4.png"),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              width: screenWidthPercentage(context, percentage: 1) - 60,
              height: screenHeightPercentage(context, percentage: 0.3),
            ).center(),
            Positioned(
              top: 10,
              right: 30,
              child: Row(
                children: [
                  user == null
                      ? const SizedBox()
                      : model.isBusy
                          ? const SizedBox()
                          : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    model.isFav
                                        ? CupertinoIcons.heart_fill
                                        : CupertinoIcons.heart,
                                    color: model.isFav
                                        ? Colors.redAccent
                                        : Colors.black,
                                    size: 20,
                                  ).center().gestures(
                                      onTap: () => model.addFavorites(
                                          context: context,
                                          experienceId: experience!.id)))
                              .height(30)
                              .width(30),
                  horizontalSpaceSmall,
                  Chip(
                    backgroundColor: kMainColor1,
                    label: Text(
                        experience!.rate! == "0.00" ? "0.0" : experience!.rate!,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    avatar:
                        const Icon(Icons.star, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 25,
              left: 5,
              child: Container(
                height: screenHeightPercentage(context, percentage: 0.13),
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
                        SizedBox(
                          height: 20,
                          width:
                              screenWidthPercentage(context, percentage: 0.31),
                          child: Text(experience!.title!,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Text('${experience!.price!} ${"SR".tr()}',
                                style: const TextStyle(
                                    color: kMainColor1, fontSize: 9)),
                            Text(' / Person'.tr(),
                                style: const TextStyle(
                                    color: kMainGray, fontSize: 9)),
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
                            "${experience!.city![0]}${experience!.city!.substring(1).replaceAll('_', ' ').toLowerCase()}, ${experience!.duration!} ${double.parse(experience!.duration!) >= 2 ? 'Hours'.tr() : 'Hour'.tr()}",
                            style:
                                const TextStyle(color: kMainGray, fontSize: 11))
                      ],
                    ),
                    verticalSpaceSmall,
                    Row(
                      children: [
                        horizontalSpaceSmall,
                        Flexible(
                            child: Text(experience!.description!,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: kMainGray,
                                    fontSize: 10))),
                        const Spacer(),
                        Container(
                          width: 70,
                          height: 25,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            gradient: kMainGradient,
                          ),
                          child: Text(
                            'Book Now'.tr(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
                          ).center(),
                        ).gestures(onTap: () {
                          model.navigateTo(
                              view: user == null
                                  ? const LoginView()
                                  : ConfirmBookingView(
                                      experience: experience,
                                      user: user,
                                    ));
                        }),
                        horizontalSpaceSmall,
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ).gestures(onTap: () async {
          model
              .navigateTo(
                  view: TripDetailView(
                      experience: experience, user: user, isUser: isUser))
              .then((value) {
            model.futureToRun();
          });
        });
      },
      viewModelBuilder: () => TripItemViewModel(
        user: user,
        experience: experience,
      ),
    );
  }
}
