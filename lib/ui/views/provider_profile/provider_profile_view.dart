import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/data_models/public_provider_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/provider_profile/provider_profile_viewmodel.dart';
import 'package:goasbar/ui/widgets/booking_card_for_provider/booking_card_for_provider.dart';
import 'package:goasbar/ui/widgets/creation_aware_item.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProviderProfileView extends HookWidget {
  const ProviderProfileView({Key? key, this.provider, this.user}) : super(key: key);
  final PublicProviderResponse? provider;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProviderProfileViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(CupertinoIcons.arrow_turn_up_left).height(40)
                    .width(40)
                    .gestures(
                  onTap: () {model.back();},
                ).alignment(Alignment.centerLeft),
                verticalSpaceSmall,
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: const DecorationImage(
                      // image: provider != null ? NetworkImage("$baseUrl${provider!.image}",)
                          image : AssetImage("assets/images/avatar.png"),
                      // : FileImage(model.file!) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                verticalSpaceRegular,
                Text("Hi, I'm ${provider!.nickname}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                verticalSpaceMedium,
                Row(
                  children: [
                    Image.asset("assets/icons/verified.png"),
                    horizontalSpaceSmall,
                    const Text("Account verified", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kGrayText),),
                  ],
                ),
                verticalSpaceTiny,
                Row(
                  children: [
                    const Icon(Icons.email_outlined, color: kMainColor1, size: 28,).padding(all: 0,),
                    horizontalSpaceTiny,

                    Text(provider!.email!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kGrayText),),
                  ],
                ).gestures(onTap: () => model.launchEmail(email: provider!.email)),
                verticalSpaceTiny,
                Row(
                  children: [
                    const Icon(Icons.phone, color: kMainColor1, size: 28,).padding(all: 0,),
                    horizontalSpaceTiny,

                    Text(provider!.phoneNumber!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kGrayText),),
                  ],
                ).gestures(onTap: () => model.launchPhoneCall(phoneNumber: provider!.phoneNumber!)),
                provider!.website != null ? verticalSpaceTiny : const SizedBox(),
                provider!.website != null ? Row(
                  children: [
                    const Icon(Icons.link, color: kMainColor1, size: 28,).padding(all: 0,),
                    horizontalSpaceTiny,

                    Text(provider!.website!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kGrayText),),
                  ],
                ).gestures(onTap: () => model.launchLink(link: provider!.website)) : const SizedBox(),
                provider!.instagramAccount != null ? verticalSpaceTiny : const SizedBox(),
                provider!.instagramAccount != null ? Row(
                  children: [
                    const Icon(Icons.link, color: kMainColor1, size: 28,).padding(all: 0,),
                    horizontalSpaceTiny,

                    Text(provider!.instagramAccount!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kGrayText),),
                  ],
                ).gestures(onTap: () => model.launchLink(link: provider!.instagramAccount)) : const SizedBox(),
                provider!.facebookAccount != null ? verticalSpaceTiny : const SizedBox(),
                provider!.facebookAccount != null ? Row(
                  children: [
                    const Icon(Icons.link, color: kMainColor1, size: 28,).padding(all: 0,),
                    horizontalSpaceTiny,
                    Text(provider!.facebookAccount!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kGrayText),),
                  ],
                ).gestures(onTap: () => model.launchLink(link: provider!.facebookAccount)) : const SizedBox(),
                provider!.twitterAccount != null ? verticalSpaceTiny : const SizedBox(),
                provider!.twitterAccount != null ? Row(
                  children: [
                    const Icon(Icons.link, color: kMainColor1, size: 28,).padding(all: 0,),
                    horizontalSpaceTiny,
                    Text(provider!.twitterAccount!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kGrayText),),
                  ],
                ).gestures(onTap: () => model.launchLink(link: provider!.twitterAccount)) : const SizedBox(),
                const Divider(color: kMainColor1, height: 40, thickness: 1.2),
                const Text("Bio", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                verticalSpaceSmall,
                Text(provider!.about!, style: const TextStyle(color: kGrayText, fontWeight: FontWeight.bold),),
                verticalSpaceMedium,
                const Text("Hosted Trips", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                verticalSpaceSmall,
                SizedBox(
                  height: 255,
                  child: model.isBusy ? const Loader().center() : model.data == null ? Text('No trips by ${provider!.nickname} right now').center() : model.data!.isEmpty ? Text('No trips by ${provider!.nickname} right now').center() : ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: model.data!.length,
                    itemBuilder: (context, index) {
                      return CreationAwareListItem(
                        itemCreated: () => model.getProviderPublicExperiencesFromNextPage(index: index + 1),
                        child: BookingItemForProviderView(user: user, providerPublicExperience: model.data![index],),
                      );
                    },
                  ),
                ),
                // verticalSpaceMedium,
                // const Text("Reviews", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                // verticalSpaceSmall,
                // Row(
                //   children: [
                //     Container(
                //       height: 40,
                //       width: 40,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(100),
                //         image: DecorationImage(
                //           image: user != null ? NetworkImage("$baseUrl${user!.image}",)
                //               : const AssetImage("assets/images/avatar.png") as ImageProvider,
                //           // : FileImage(model.file!) as ImageProvider,
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //     ),
                //     horizontalSpaceSmall,
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           user != null ? "${user!.firstName} ${user!.lastName}" : "",
                //           style: const TextStyle(fontWeight: FontWeight.bold,),
                //         ),
                //         verticalSpaceTiny,
                //         SizedBox(
                //           width: screenWidthPercentage(context, percentage: 0.7),
                //           child: const Text(
                //             //TODO review date waiting anas
                //             '25.05.2022',
                //             overflow: TextOverflow.ellipsis,
                //             style: TextStyle(color: kGrayText, fontSize: 12),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                // verticalSpaceSmall,
                // //TODO add review comment waiting anas
                // SizedBox(
                //   width: screenWidthPercentage(context, percentage: 0.85),
                //   child: const Text(
                //     'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et',
                //     overflow: TextOverflow.clip,
                //     style: TextStyle(color: Colors.black54),
                //   ),
                // ),
                const Divider(color: kMainColor1, height: 40, thickness: 1.2),
                Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: kGrayText.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.outlined_flag, color: Colors.black54, size: 20),
                    ),
                    horizontalSpaceSmall,
                    const Text('Report this Host profile'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ProviderProfileViewModel(providerId: provider!.id),
    );
  }
}
