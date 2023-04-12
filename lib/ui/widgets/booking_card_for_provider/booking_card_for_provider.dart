import 'package:flutter/material.dart';
import 'package:goasbar/data_models/provider_public_experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/booking_for_provider_detail/booking_for_provider_detail_view.dart';
import 'package:goasbar/ui/widgets/booking_card_for_provider/booking_card_for_provider_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class BookingItemForProviderView extends StatelessWidget {
  const BookingItemForProviderView({
    Key? key,
    this.providerPublicExperience,
    this.user,
  }) : super(key: key);
  final ProviderPublicExperienceResults? providerPublicExperience;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BookingItemForProviderViewModel>.reactive(
      builder: (context, model, child)  {
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: providerPublicExperience!.profileImage != null ? providerPublicExperience!.profileImage!.contains('/asbar-icon.ico') ? BoxFit.cover : BoxFit.cover : BoxFit.contain,
                  image: providerPublicExperience!.profileImage != null && !providerPublicExperience!.profileImage!.contains('/asbar-icon.ico')
                      ? NetworkImage("$baseUrl${providerPublicExperience!.profileImage}") as ImageProvider
                      : const AssetImage("assets/images/image4.png"),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              width: screenWidthPercentage(context, percentage: 0.9) - 60,
              height: screenHeightPercentage(context, percentage: 0.3),
            ).center(),
            Positioned(
              top: 30,
              right: 30,
              child: Row(
                children: [
                  Chip(
                    backgroundColor: kMainColor1,
                    label: Text(providerPublicExperience!.rate! == "0.00" ? "0.0" : providerPublicExperience!.rate!, style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                    avatar: const Icon(Icons.star, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 35,
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
                        Text(providerPublicExperience!.title!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Row(
                          children: [
                            Text('${providerPublicExperience!.price!} SR', style: const TextStyle(color: kMainColor1, fontSize: 9)),
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
                        Image.asset("assets/icons/location.png"),
                        horizontalSpaceTiny,
                        Text(" ${providerPublicExperience!.city![0]}${providerPublicExperience!.city!.substring(1).replaceAll('_', ' ').toLowerCase()} , ${providerPublicExperience!.duration!} ${double.parse(providerPublicExperience!.duration!) >= 2 ? 'Hours' : 'Hour'}", style: const TextStyle(color: kMainGray, fontSize: 11))
                      ],
                    ),
                    verticalSpaceSmall,
                    Row(
                      children: [
                        horizontalSpaceSmall,
                        SizedBox(
                          width: screenWidthPercentage(context, percentage: 0.4),
                          child: Text(providerPublicExperience!.description!, overflow: TextOverflow.ellipsis),
                        ).alignment(Alignment.centerLeft),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ).gestures(onTap: () async {
          model.navigateTo(view: BookingForProviderDetailView(providerPublicExperience: providerPublicExperience, user: user)).then((value) {
            model.futureToRun();
          });
        });
      },
      viewModelBuilder: () => BookingItemForProviderViewModel(user: user),
    );
  }
}