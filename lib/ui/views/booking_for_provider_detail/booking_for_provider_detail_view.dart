import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/provider_public_experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/booking_for_provider_detail/booking_for_provider_detail_viewmodel.dart';
import 'package:goasbar/ui/views/chat_with_agency/chat.dart';
import 'package:goasbar/ui/views/login/login_view.dart';
import 'package:goasbar/ui/widgets/dot_item.dart';
import 'package:goasbar/ui/widgets/note_item.dart';
import 'package:goasbar/ui/widgets/slider_image_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class BookingForProviderDetailView extends HookWidget {
  const BookingForProviderDetailView(
      {super.key, this.providerPublicExperience, this.user});
  final ProviderPublicExperienceResults? providerPublicExperience;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    var pageController = usePageController();

    void handleChatWithProvider(BookingForProviderDetailViewModel model) {
      if (user == null) {
        model.navigateTo(view: const LoginView());
      } else if (providerPublicExperience?.providerId != null) {
        model
            .getProviderChatRoom(providerPublicExperience!.providerId!)
            .then((chatRoom) {
          if (chatRoom != null) {
            model.navigateTo(view: ChatView(room: chatRoom, user: user!));
          }
        });
      }
    }

    return ViewModelBuilder<BookingForProviderDetailViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        extendBodyBehindAppBar: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 265,
              child: Stack(
                children: [
                  SizedBox(
                    height: 265,
                    child: PageView(
                      scrollDirection: Axis.horizontal,
                      controller: pageController,
                      onPageChanged: (index) => model.changeIndex(index: index),
                      children: providerPublicExperience!.imageSet!.isEmpty
                          ? providerPublicExperience!.profileImage != null
                              ? providerPublicExperience!.profileImage!
                                      .contains('/asbar-icon.ico')
                                  ? const [
                                      SliderImageItem(
                                        path: 'assets/images/trip_detail.png',
                                        isAsset: true,
                                      ),
                                    ]
                                  : [
                                      SliderImageItem(
                                        path: providerPublicExperience!
                                            .profileImage,
                                        isAsset: false,
                                      ),
                                    ]
                              : const [
                                  SliderImageItem(
                                    path: 'assets/images/trip_detail.png',
                                    isAsset: true,
                                  ),
                                ]
                          : [
                              for (var image
                                  in providerPublicExperience!.imageSet!)
                                SliderImageItem(
                                  path: image.image,
                                  isAsset: false,
                                ),
                            ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
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
                            )
                                .height(40)
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
                                      Text("Share".tr()),
                                      horizontalSpaceTiny,
                                      const Icon(
                                        Icons.share_outlined,
                                      ).center(),
                                    ],
                                  ),
                                ).height(40).width(100).gestures(
                                    onTap: () => model.share(
                                        link:
                                            "$baseUrl/experience/${providerPublicExperience!.slug}")),
                                horizontalSpaceSmall,
                                user == null
                                    ? const SizedBox()
                                    : model.isBusy
                                        ? const SizedBox()
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Icon(
                                              model.isFav
                                                  ? CupertinoIcons.heart_fill
                                                  : CupertinoIcons.heart,
                                              color: model.isFav
                                                  ? Colors.redAccent
                                                  : Colors.black,
                                              size: 30,
                                            ).center().gestures(
                                                onTap: () => model.addFavorites(
                                                    context: context,
                                                    experienceId:
                                                        providerPublicExperience!
                                                            .id))).height(40).width(
                                            40),
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
                                  const Icon(
                                    Icons.star,
                                    color: kStarColor,
                                  ),
                                  horizontalSpaceTiny,
                                  Text(
                                      providerPublicExperience!.rate! == "0.00"
                                          ? "0.0"
                                          : providerPublicExperience!.rate!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                ],
                              ),
                            ).height(40).width(100),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xff222222),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    providerPublicExperience!.imageSet!.isEmpty
                                        ? '1 / 1'
                                        : '${model.pageIndex} / ${providerPublicExperience!.imageSet!.length}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ).center(),
                                ).width(60).height(40).opacity(0.6),
                                horizontalSpaceRegular,
                                Row(
                                  children: providerPublicExperience!
                                          .imageSet!.isEmpty
                                      ? [
                                          const DotItem(condition: true),
                                          horizontalSpaceSmall,
                                        ]
                                      : [
                                          for (var i = 0;
                                              i <
                                                  providerPublicExperience!
                                                      .imageSet!.length;
                                              i++)
                                            Row(
                                              children: [
                                                DotItem(
                                                    condition:
                                                        model.pageIndex ==
                                                            i + 1),
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
            Row(
              children: [
                Image.asset("assets/icons/location.png"),
                horizontalSpaceTiny,
                Text(
                    "${providerPublicExperience!.city![0]}${providerPublicExperience!.city!.substring(1).replaceAll('_', ' ').toLowerCase()} , ${'Duration'.tr()} : ${providerPublicExperience!.duration} ${double.parse(providerPublicExperience!.duration!) <= 1 ? "Hour".tr() : "Hours".tr()}",
                    style: const TextStyle(color: kMainGray, fontSize: 11)),
              ],
            ).padding(horizontal: 20),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  const Divider(
                          height: 5, color: kMainDisabledGray, thickness: 1)
                      .padding(horizontal: 20),
                  verticalSpaceRegular,
                  Row(
                    children: [
                      Image.asset(
                        "assets/icons/description_quote.png",
                      ),
                      horizontalSpaceSmall,
                      Text(
                        'Description'.tr(),
                      ),
                    ],
                  ).padding(horizontal: 20),
                  verticalSpaceRegular,
                  Text(providerPublicExperience!.description!)
                      .padding(horizontal: 20),
                  verticalSpaceRegular,
                  Row(
                    children: [
                      Image.asset(
                        "assets/icons/gender.png",
                      ),
                      horizontalSpaceSmall,
                      Text(
                        'Gender Type'.tr(),
                      ),
                      horizontalSpaceMedium,
                      Text(
                        providerPublicExperience!.gender! == "None"
                            ? 'Valid for All'
                            : providerPublicExperience!.gender!,
                        style: const TextStyle(color: kMainDisabledGray),
                      )
                    ],
                  ).padding(horizontal: 20),
                  verticalSpaceRegular,
                  Row(
                    children: [
                      Image.asset(
                        "assets/icons/communication.png",
                      ),
                      horizontalSpaceSmall,
                      Text(
                        'Start Chat'.tr(),
                        style: const TextStyle(
                          color: kMainColor1,
                        ),
                      ).gestures(onTap: () => handleChatWithProvider(model)),
                    ],
                  ).padding(horizontal: 20),
                  verticalSpaceRegular,
                  model.kGooglePlex == null
                      ? const SizedBox()
                      : Row(
                          children: [
                            Image.asset(
                              "assets/icons/starting_point.png",
                            ),
                            horizontalSpaceSmall,
                            Text(
                              'Starting Point'.tr(),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Image.asset("assets/icons/map_link.png",
                                    color: kMainColor1),
                                horizontalSpaceTiny,
                                Text(
                                  "Google maps".tr(),
                                  style: const TextStyle(color: kGrayText),
                                ),
                              ],
                            ).gestures(onTap: () {
                              if (model.latLon != null) {
                                model.launchMaps(latLon: model.latLon);
                              }
                            }),
                          ],
                        ).padding(horizontal: 20),
                  model.kGooglePlex == null
                      ? const SizedBox()
                      : verticalSpaceRegular,
                  model.isBusy
                      ? const SizedBox()
                      : model.kGooglePlex == null
                          ? const SizedBox()
                          : Container(
                              height: 300,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: GoogleMap(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                mapType: MapType.normal,
                                initialCameraPosition: model.kGooglePlex!,
                                onMapCreated: (GoogleMapController controller) {
                                  model.controller.complete(controller);
                                },
                                gestureRecognizers:
                                    <Factory<OneSequenceGestureRecognizer>>{}
                                      ..add(Factory<EagerGestureRecognizer>(
                                          () => EagerGestureRecognizer())),
                                markers: model.customMarkers.toSet(),
                                myLocationEnabled: true,
                                myLocationButtonEnabled: false,
                                zoomControlsEnabled: false,
                              ),
                            ),
                  model.kGooglePlex == null
                      ? const SizedBox()
                      : verticalSpaceRegular,
                  providerPublicExperience!.requirements == null &&
                          providerPublicExperience!.providedGoods == null
                      ? const SizedBox()
                      : Row(
                          children: [
                            Image.asset(
                              "assets/icons/notes.png",
                            ),
                            horizontalSpaceSmall,
                            Text(
                              'Notes & Requirements'.tr(),
                            ),
                          ],
                        ).padding(horizontal: 20),
                  if (providerPublicExperience!.requirements != null)
                    for (var requirement
                        in providerPublicExperience!.requirements!.split(';'))
                      if (requirement.isNotEmpty)
                        NoteItem(
                          text: requirement,
                        ).padding(horizontal: 20),
                  providerPublicExperience!.requirements == null
                      ? const SizedBox()
                      : verticalSpaceSmall,
                  if (providerPublicExperience!.providedGoods != null)
                    for (var providedGood
                        in providerPublicExperience!.providedGoods!.split(';'))
                      if (providedGood.isNotEmpty)
                        NoteItem(
                          text: providedGood,
                        ).padding(horizontal: 20),
                  providerPublicExperience!.providedGoods == null
                      ? const SizedBox()
                      : verticalSpaceSmall,
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
                        Text('${providerPublicExperience!.price!} ${"SR".tr()}',
                            style: const TextStyle(
                                color: kMainColor1, fontSize: 18)),
                        Text(' / Person'.tr(),
                            style: const TextStyle(
                                color: kMainGray, fontSize: 18)),
                      ],
                    ),
                    verticalSpaceTiny,
                    Text(
                      model.formatMonthYear(providerPublicExperience!
                          .creationDate!
                          .substring(0, 10)),
                      style: const TextStyle(fontSize: 13, color: kGrayText),
                    )
                  ],
                ),
              ],
            ).padding(horizontal: 20, vertical: 15),
          ],
        ),
      ),
      viewModelBuilder: () => BookingForProviderDetailViewModel(
          context: context,
          user: user,
          providerPublicExperience: providerPublicExperience),
    );
  }
}
