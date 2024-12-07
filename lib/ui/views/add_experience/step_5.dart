import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/add_experience/add_experience_viewmodel.dart';
import 'package:goasbar/ui/widgets/dot_item.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:goasbar/ui/widgets/previous_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:styled_widget/styled_widget.dart';

typedef PublishExperienceCallback = void Function(
    AddExperienceInfoViewModel model);

class AddExperienceStep5View extends HookWidget {
  const AddExperienceStep5View(
      {super.key,
      required this.model,
      required this.pageController,
      required this.price,
      required this.handlePublishExperience,
      required this.notes});

  final AddExperienceInfoViewModel model;
  final PageController pageController;
  final TextEditingController notes;
  final TextEditingController price;
  final PublishExperienceCallback handlePublishExperience;

  @override
  Widget build(BuildContext context) {
    var priceError = useState<String?>(null);
    var meetingPointError = useState<String?>(null);
    var cityError = useState<String?>(null);

    bool validateStep5() {
      bool isValid = true;

      if (price.text.isEmpty || double.parse(price.text) < 1) {
        priceError.value = "Price must be greater than 1 SR";
        isValid = false;
      }

      if (model.latLon == null) {
        meetingPointError.value = "Meeting point must be set on the map";
        isValid = false;
      }

      if (model.city == null || model.city == null) {
        cityError.value = "This field is required.";
        isValid = false;
      }

      return isValid;
    }

    void handleNextStep() {
      var isValid = validateStep5();
      if (isValid) {
        handlePublishExperience(model);
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: screenHeightPercentage(context, percentage: 0.85),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        color: Colors.white,
      ),
      child: ListView(
        children: [
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.close,
                size: 30,
              ).gestures(
                onTap: () => model.back(),
              ),
              horizontalSpaceTiny,
              Text('EXPERIENCE LOCATION'.tr(),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '5 - 6',
                      style: TextStyle(
                          color: kMainColor1,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ).center(),
                  ).width(40).height(40).opacity(0.6),
                  const Row(
                    children: [
                      DotItem(condition: false, color: kMainColor1),
                      horizontalSpaceTiny,
                      DotItem(condition: false, color: kMainColor1),
                      horizontalSpaceTiny,
                      DotItem(condition: true, color: kMainColor1),
                    ],
                  ),
                ],
              ),
            ],
          ),
          verticalSpaceMedium,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpaceSmall,
              Text("City".tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              verticalSpaceSmall,
              Container(
                height: 50,
                width: screenWidthPercentage(context, percentage: 1),
                decoration: BoxDecoration(
                  color: kTextFiledMainColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField<String>(
                      value: model.city,
                      decoration: InputDecoration(errorText: cityError.value),
                      iconSize: 24,
                      icon: (null),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      onChanged: (value) {
                        model.updateCity(value: value);
                        cityError.value = null;
                      },
                      items: () {
                        var cityItems = model.cities
                            .map((city) => DropdownMenuItem(
                                  value: city.id.toString(),
                                  onTap: () {},
                                  child: SizedBox(
                                    child: Text(
                                      context.locale == const Locale("ar", "SA")
                                          ? city.nameAr
                                          : city.nameEn,
                                      style:
                                          const TextStyle(fontFamily: 'Cairo'),
                                    ),
                                  ),
                                ))
                            .toList();
                        if (model.experience?.city != null &&
                            !model.cities.any((city) =>
                                city.id == model.experience?.city.id)) {
                          cityItems = [
                            ...cityItems,
                            DropdownMenuItem(
                              value: model.experience?.city.id.toString(),
                              enabled: false,
                              onTap: () {},
                              child: SizedBox(
                                child: Text(
                                  context.locale == const Locale("ar", "SA")
                                      ? model.experience!.city.nameAr
                                      : model.experience!.city.nameEn,
                                  style: const TextStyle(fontFamily: 'Cairo'),
                                ),
                              ),
                            )
                          ];
                        }
                        return cityItems;
                      }(),
                    ),
                  ),
                ),
              ),
              verticalSpaceRegular,
              Text("Starting Point".tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              verticalSpaceSmall,
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: kTextFiledMainColor,
                    border: Border.all(
                        color: meetingPointError.value == null
                            ? Colors.transparent
                            : Colors.red)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenWidthPercentage(context, percentage: 0.5),
                      child: Text(model.address != null
                          ? "${model.address!.thoroughfare!} - ${model.address!.locality!}"
                          : "Street name".tr()),
                    ),
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
                ),
              ),
              model.kGooglePlex == null
                  ? const SizedBox()
                  : verticalSpaceRegular,
              model.isBusy
                  ? const SizedBox()
                  : model.kGooglePlex == null
                      ? const SizedBox()
                      : Container(
                          height: 300,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: meetingPointError.value == null
                                      ? Colors.transparent
                                      : Colors.red)),
                          child: GoogleMap(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            mapType: MapType.normal,
                            gestureRecognizers:
                                <Factory<OneSequenceGestureRecognizer>>{}..add(
                                    Factory<EagerGestureRecognizer>(
                                        () => EagerGestureRecognizer())),
                            initialCameraPosition: model.kGooglePlex!,
                            onMapCreated: (GoogleMapController controller) {
                              model.controller.complete(controller);
                            },
                            onTap: (latLon) {
                              model.getTappedPosition(latLon);
                              meetingPointError.value = null;
                            },
                            markers: model.customMarkers.toSet(),
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                          ),
                        ),
              meetingPointError.value == null
                  ? const SizedBox()
                  : Text(meetingPointError.value ?? "",
                      style: const TextStyle(color: Colors.red)),
              verticalSpaceRegular,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpaceSmall,
                  Text("Description Or Notes".tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                  verticalSpaceSmall,
                  SizedBox(
                    height: 100,
                    child: TextField(
                      maxLines: 10,
                      controller: notes,
                      maxLength: 1024,
                      decoration: InputDecoration(
                        hintText: "Add Notes...".tr(),
                        hintStyle: const TextStyle(fontSize: 14),
                        fillColor: kTextFiledMainColor,
                        filled: true,
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          verticalSpaceRegular,
          Text(
            'Pricing'.tr(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          verticalSpaceSmall,
          SizedBox(
            height: 50,
            child: TextField(
              controller: price,
              keyboardType: TextInputType.number,
              onChanged: (value) => {priceError.value = null},
              decoration: InputDecoration(
                hintStyle: const TextStyle(fontSize: 14),
                suffix: Text("SR".tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                fillColor: kTextFiledMainColor,
                errorText: priceError.value,
                filled: true,
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          verticalSpaceLarge,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PreviousButton(onTap: () => pageController.jumpToPage(3)),
              Container(
                width: screenWidthPercentage(context, percentage: 0.4),
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: kMainGradient,
                ),
                child: model.isClicked!
                    ? const Loader().center()
                    : Center(
                        child: Text(
                          'PUBLISH'.tr(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
              ).gestures(
                onTap: handleNextStep,
              ),
            ],
          ),
          verticalSpaceRegular,
        ],
      ),
    );
  }
}
