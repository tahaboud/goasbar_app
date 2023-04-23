import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/chat_with_agency/chat_with_agency_view.dart';
import 'package:goasbar/ui/views/confirm_booking/confirm_booking_view.dart';
import 'package:goasbar/ui/views/login/login_view.dart';
import 'package:goasbar/ui/views/provider_profile/provider_profile_view.dart';
import 'package:goasbar/ui/views/trip_detail/trip_detail_viewmodel.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:goasbar/ui/widgets/note_item.dart';
import 'package:goasbar/ui/widgets/slider_image_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:goasbar/ui/widgets/dot_item.dart';

class TripDetailView extends HookWidget {
  const TripDetailView({Key? key, this.experience, this.user}) : super(key: key);
  final ExperienceResults? experience;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    var pageController = usePageController();

    return ViewModelBuilder<TripDetailViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        extendBodyBehindAppBar: true,
        body: model.isBusy ? const Loader().center() : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            SizedBox(
              height: 265,
              child: Stack(
                children: [
                  SizedBox(
                    height: 265,
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      controller: pageController,
                      onPageChanged: (index) => model.changeIndex(index: index + 1),
                      children: experience!.imageSet!.isEmpty ? experience!.profileImage != null ? experience!.profileImage!.contains('/asbar-icon.ico') ? const [
                        SliderImageItem(path: 'assets/images/trip_detail.png', isAsset: true,),
                      ] : [
                        SliderImageItem(path: experience!.profileImage, isAsset: false,),
                      ] : const [
                        SliderImageItem(path: 'assets/images/trip_detail.png', isAsset: true,),
                      ] : [
                        for (var image in experience!.imageSet!)
                          SliderImageItem(path: image.image, isAsset: false,),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20,),
                    child: Column(
                      children: [
                        verticalSpaceLarge,
                        verticalSpaceMedium,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.arrow_back).center(),
                            ).height(40)
                                .width(40)
                                .gestures(onTap: () => model.back()),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Share"),
                                      horizontalSpaceTiny,
                                      const Icon(Icons.share_outlined,).center(),
                                    ],
                                  ),
                                ).height(40)
                                    .width(100)
                                    .gestures(onTap: () => model.share(link: experience!.slug)),
                                horizontalSpaceSmall,
                                user == null ? const SizedBox() : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      model.isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                      color: model.isFav ? Colors.redAccent : Colors.black, size: 30,
                                    ).center()
                                        .gestures(onTap: () => model.addFavorites(context: context, experienceId: experience!.id))
                                ).height(40)
                                    .width(40),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.star, color: kStarColor,),
                                  horizontalSpaceTiny,
                                  Text(experience!.rate! == "0.00" ? "0.0" : experience!.rate!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                ],
                              ),
                            ).height(40)
                                .width(100),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff222222),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(experience!.imageSet!.isEmpty ? '1 / 1' : '${model.pageIndex} / ${experience!.imageSet!.length}',
                                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),).center(),
                                ).width(60)
                                    .height(40)
                                    .opacity(0.6),
                                horizontalSpaceRegular,
                                Row(
                                  children: experience!.imageSet!.isEmpty ? [
                                    const DotItem(condition: true),
                                    horizontalSpaceSmall,
                                  ] : [
                                    for (var i = 1; i < experience!.imageSet!.length; i++)
                                      Row(
                                        children: [
                                          DotItem(condition: model.pageIndex == i + 1),
                                          horizontalSpaceSmall,
                                        ],
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        verticalSpaceMedium,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            verticalSpaceRegular,
            Text('Get your experience this weekend \nwith amazing trip in ${experience!.city![0]}${experience!.city!.substring(1).replaceAll('_', ' ').toLowerCase()}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),)
                .padding(horizontal: 20),
            verticalSpaceRegular,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(experience!.reviews! > 1 ? '${experience!.reviews} reviews' : '${experience!.reviews} review'),
                Image.asset("assets/icons/location.png"),
                horizontalSpaceTiny,
                SizedBox(
                  width: screenWidthPercentage(context, percentage: 0.7),
                  child: Text("${experience!.city![0]}${experience!.city!.substring(1).replaceAll('_', ' ').toLowerCase()} , Duration : ${experience!.duration} ${double.parse(experience!.duration!) <= 1 ? "Hour" : "Hours"} ${model.timingListModel == null ? "" : model.timingListModel!.count! > 0 ? "| Start at ${model.timingListModel!.results![0].startTime!.substring(0, 5)}" : ''}", overflow: TextOverflow.clip, style: const TextStyle(color: kMainGray, fontSize: 11)),
                ),
              ],
            ).padding(horizontal: 20),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  const Divider(height: 1, color: kMainDisabledGray, thickness: 1).padding(horizontal: 20),
                  verticalSpaceRegular,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('Hosted Experience by :', style: TextStyle(fontSize: 16)),
                          Text(' ${model.provider!.response!.nickname}', style: const TextStyle(fontSize: 16, color: kMainColor1)).gestures(
                            onTap: () => model.navigateTo(view: ProviderProfileView(provider: model.provider!.response!, user: user),)
                          ),
                        ],
                      ),
                      !model.dataReady ? Image.asset("assets/images/by_user.png").borderRadius(all: 50).height(50).width(50)
                          : Image.network("$baseUrl${model.provider!.response!.image}", height: 35,).clipRRect(all: 30).gestures(
                          onTap: () => model.navigateTo(view: ProviderProfileView(provider: model.provider!.response!, user: user)),
                      ),
                    ],
                  ).padding(horizontal: 20),
                  verticalSpaceSmall,
                  const Divider(height: 10, color: kMainDisabledGray, thickness: 1).padding(horizontal: 20),
                  verticalSpaceRegular,
                  Row(
                    children: [
                      Image.asset("assets/icons/description_quote.png",),
                      horizontalSpaceSmall,
                      const Text('Description', ),
                    ],
                  ).padding(horizontal: 20),
                  verticalSpaceRegular,
                  Text(experience!.description!)
                      .padding(horizontal: 20),
                  verticalSpaceRegular,
                  Row(
                    children: [
                      Image.asset("assets/icons/gender.png",),
                      horizontalSpaceSmall,
                      const Text('Gender', ),
                      horizontalSpaceMedium,
                      Text(experience!.gender! == "None" ? 'Valid for All' : experience!.gender!, style: const TextStyle(color: kMainDisabledGray),)
                    ],
                  ).padding(horizontal: 20),
                  verticalSpaceRegular,
                  Row(
                    children: [
                      Image.asset("assets/icons/communication.png",),
                      horizontalSpaceSmall,
                      const Text('Have great communication',),
                      const Spacer(),
                      const Text('Start Chat', style: TextStyle(color: kMainColor1,),).gestures(onTap: () => model.navigateTo(view: user == null ? const LoginView() : ChatWithAgencyView(providerId: experience!.providerId, userId: user!.id, providerName: "Provider",))),
                    ],
                  ).padding(horizontal: 20),
                  verticalSpaceRegular,
                  model.kGooglePlex == null ? const SizedBox() : Row(
                    children: [
                      Image.asset("assets/icons/starting_point.png",),
                      horizontalSpaceSmall,
                      const Text('Starting Point',),
                    ],
                  ).padding(horizontal: 20),
                  model.kGooglePlex == null ? const SizedBox() : verticalSpaceRegular,
                  model.kGooglePlex == null ? const SizedBox() : Container(
                    height: 300,
                    width: screenWidthPercentage(context, percentage: 0.9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: GoogleMap(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      mapType: MapType.normal,
                      initialCameraPosition: model.kGooglePlex!,
                      onMapCreated: (GoogleMapController controller) {
                        model.controller.complete(controller);
                      },
                      markers: model.customMarkers.toSet(),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                    ),
                  ),
                  model.kGooglePlex == null ? const SizedBox() : verticalSpaceRegular,
                  experience!.requirements == null && experience!.providedGoods == null ? const SizedBox() : Row(
                    children: [
                      Image.asset("assets/icons/notes.png",),
                      horizontalSpaceSmall,
                      const Text('Notes & Requirement',),
                    ],
                  ).padding(horizontal: 20,),
                  if (experience!.requirements != null)
                    for (var requirement in experience!.requirements!.split('\n'))
                      if (requirement.isNotEmpty)
                        NoteItem(text: requirement,).padding(horizontal: 20),
                  experience!.requirements == null ? const SizedBox() : verticalSpaceSmall,
                  if (experience!.providedGoods != null)
                    for (var providedGood in experience!.providedGoods!.split('\n'))
                      if (providedGood.isNotEmpty)
                        NoteItem(text: providedGood,).padding(horizontal: 20),
                  experience!.providedGoods == null ? const SizedBox() : verticalSpaceSmall,
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('${experience!.price!} SR', style: const TextStyle(color: kMainColor1, fontSize: 18)),
                        const Text(' / Person', style: TextStyle(color: kMainGray, fontSize: 18)),
                      ],
                    ),
                    verticalSpaceTiny,
                    Text(model.timingListModel == null ? "" : model.timingListModel!.count! > 0 ? model.formatMonthYear(model.timingListModel!.results![0].date) : "", style: const TextStyle(fontSize: 13, color: kGrayText),)
                  ],
                ),
                Container(
                  width: 110,
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: kMainGradient,
                  ),
                  child: const Text('Book Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)
                      .center()
                      .gestures(onTap: () {
                        model.navigateTo(view: user == null ? const LoginView() : ConfirmBookingView(experience: experience, user: user,));
                  }),
                ),
              ],
            ).padding(horizontal: 20, vertical: 15),
          ],
        ),
      ),
      viewModelBuilder: () => TripDetailViewModel(user: user, experience: experience),
    );
  }
}