import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/provider_public_experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/booking_for_provider_detail/booking_for_provider_detail_viewmodel.dart';
import 'package:goasbar/ui/views/chat_with_agency/chat_with_agency_view.dart';
import 'package:goasbar/ui/views/provider_profile/provider_profile_view.dart';
import 'package:goasbar/ui/widgets/note_item.dart';
import 'package:goasbar/ui/widgets/slider_image_item.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:goasbar/ui/widgets/dot_item.dart';

class BookingForProviderDetailView extends HookWidget {
  const BookingForProviderDetailView({Key? key, this.providerPublicExperience, this.user}) : super(key: key);
  final ProviderPublicExperienceResults? providerPublicExperience;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    var pageController = usePageController();

    return ViewModelBuilder<BookingForProviderDetailViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        extendBodyBehindAppBar: true,
        body: Column(
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
                      onPageChanged: (index) => model.changeIndex(index: index),
                      children: providerPublicExperience!.imageSet!.isEmpty ? providerPublicExperience!.profileImage != null ? providerPublicExperience!.profileImage!.contains('/asbar-icon.ico') ? const [
                        SliderImageItem(path: 'assets/images/trip_detail.png', isAsset: true,),
                      ] : [
                        SliderImageItem(path: providerPublicExperience!.profileImage, isAsset: false,),
                      ] : const [
                        SliderImageItem(path: 'assets/images/trip_detail.png', isAsset: true,),
                      ] : [
                        for (var image in providerPublicExperience!.imageSet!)
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
                                    .gestures(onTap: () => model.share(link: providerPublicExperience!.slug)),
                                horizontalSpaceSmall,
                                user == null ? const SizedBox() : model.isBusy ? const SizedBox() : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      model.isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                      color: model.isFav ? Colors.redAccent : Colors.black, size: 30,
                                    ).center()
                                        .gestures(onTap: () => model.addFavorites(context: context, experienceId: providerPublicExperience!.id))
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
                                  Text(providerPublicExperience!.rate! == "0.00" ? "0.0" : providerPublicExperience!.rate!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                                  child: Text(providerPublicExperience!.imageSet!.isEmpty ? '1 / 1' : '${model.pageIndex} / ${providerPublicExperience!.imageSet!.length}',
                                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),).center(),
                                ).width(60)
                                    .height(40)
                                    .opacity(0.6),
                                horizontalSpaceRegular,
                                Row(
                                  children: providerPublicExperience!.imageSet!.isEmpty ? [
                                    const DotItem(condition: true),
                                    horizontalSpaceSmall,
                                  ] : [
                                    for (var i = 0; i < providerPublicExperience!.imageSet!.length; i++)
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
            Text('Get your experience this weekend \nwith amazing trip in ${providerPublicExperience!.city}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),)
                .padding(horizontal: 20),
            verticalSpaceRegular,
            Row(
              children: [
                Image.asset("assets/icons/location.png"),
                horizontalSpaceTiny,
                Text("${providerPublicExperience!.city} , Duration : ${providerPublicExperience!.duration} ${double.parse(providerPublicExperience!.duration!) <= 1 ? "Hour" : "Hours"}", style: const TextStyle(color: kMainGray, fontSize: 11)),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Hosted Experience by', style: TextStyle(fontSize: 18)),
                      horizontalSpaceSmall,
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
                  Text(providerPublicExperience!.description!)
                      .padding(horizontal: 20),
                  verticalSpaceRegular,
                  Row(
                    children: [
                      Image.asset("assets/icons/gender.png",),
                      horizontalSpaceSmall,
                      const Text('Gender', ),
                      horizontalSpaceMedium,
                      Text(providerPublicExperience!.gender! == "None" ? 'Valid for All' : providerPublicExperience!.gender!, style: const TextStyle(color: kMainDisabledGray),)
                    ],
                  ).padding(horizontal: 20),
                  verticalSpaceRegular,
                  Row(
                    children: [
                      Image.asset("assets/icons/communication.png",),
                      horizontalSpaceSmall,
                      const Text('Have great communication',),
                      const Spacer(),
                      const Text('Start Chat', style: TextStyle(color: kMainColor1,),).gestures(onTap: () => model.navigateTo(view: ChatWithAgencyView(providerId: providerPublicExperience!.providerId, userId: user!.id, providerName: "Provider",))),
                    ],
                  ).padding(horizontal: 20),
                  verticalSpaceRegular,
                  Row(
                    children: [
                      Image.asset("assets/icons/starting_point.png",),
                      horizontalSpaceSmall,
                      const Text('Starting Point',),
                    ],
                  ).padding(horizontal: 20),
                  verticalSpaceRegular,
                  Image.asset("assets/images/map.png").padding(horizontal: 20),
                  verticalSpaceRegular,
                  providerPublicExperience!.requirements == null && providerPublicExperience!.providedGoods == null ? const SizedBox() : Row(
                    children: [
                      Image.asset("assets/icons/notes.png",),
                      horizontalSpaceSmall,
                      const Text('Notes & Requirement',),
                    ],
                  ).padding(horizontal: 20),
                  if (providerPublicExperience!.requirements != null)
                    for (var requirement in providerPublicExperience!.requirements!.split('\n'))
                      if (requirement.isNotEmpty)
                        NoteItem(text: requirement,).padding(horizontal: 20),
                  providerPublicExperience!.requirements == null ? const SizedBox() : verticalSpaceSmall,
                  if (providerPublicExperience!.providedGoods != null)
                    for (var providedGood in providerPublicExperience!.providedGoods!.split('\n'))
                      if (providedGood.isNotEmpty)
                        NoteItem(text: providedGood,).padding(horizontal: 20),
                  providerPublicExperience!.providedGoods == null ? const SizedBox() : verticalSpaceSmall,
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
                        Text('${providerPublicExperience!.price!} SR', style: const TextStyle(color: kMainColor1, fontSize: 18)),
                        const Text(' / Person', style: TextStyle(color: kMainGray, fontSize: 18)),
                      ],
                    ),
                    verticalSpaceTiny,
                    Text(model.formatMonthYear(providerPublicExperience!.creationDate!.substring(0, 10)), style: const TextStyle(fontSize: 13, color: kGrayText),)
                  ],
                ),
              ],
            ).padding(horizontal: 20, vertical: 15),
          ],
        ),
      ),
      viewModelBuilder: () => BookingForProviderDetailViewModel(user: user, providerPublicExperience: providerPublicExperience),
    );
  }
}