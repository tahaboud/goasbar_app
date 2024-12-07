import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:styled_widget/styled_widget.dart';

class ExperienceInfoSection extends StatelessWidget {
  const ExperienceInfoSection({super.key, required this.experience});

  final ExperienceResults experience;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: screenWidthPercentage(context, percentage: 0.4),
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: experience.profileImage != null
                  ? experience.profileImage!.contains('/asbar-icon.ico')
                      ? BoxFit.none
                      : BoxFit.cover
                  : BoxFit.contain,
              image: experience.profileImage != null &&
                      !experience.profileImage!.contains('/asbar-icon.ico')
                  ? NetworkImage("$baseUrl${experience.profileImage}")
                      as ImageProvider
                  : const AssetImage("assets/images/image4.png"),
            ),
          ),
        ).center(),
        horizontalSpaceRegular,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: screenWidthPercentage(context, percentage: 0.4),
                child: Text(
                  experience.title ?? "",
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                )),
            Row(
              children: [
                Image.asset("assets/icons/location.png"),
                horizontalSpaceTiny,
                SizedBox(
                  width: 160,
                  child: Text(
                    "${context.locale == const Locale("ar", "SA") ? experience.city.nameAr : experience.city.nameEn} , ${experience.duration!} ${double.parse(experience.duration!) >= 2 ? 'Hours'.tr() : 'Hour'.tr()}",
                    style: const TextStyle(color: kMainGray, fontSize: 11),
                  ),
                ),
              ],
            ),
            verticalSpaceMedium,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: kStarColor, size: 18),
                horizontalSpaceTiny,
                Text(experience.rate! == "0.00" ? "0.0" : experience.rate!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
