import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/ui/views/add_experience/add_experience_viewmodel.dart';
import 'package:goasbar/ui/views/add_experience/step_1.dart';
import 'package:goasbar/ui/views/add_experience/step_2.dart';
import 'package:goasbar/ui/views/add_experience/step_3.dart';
import 'package:goasbar/ui/views/add_experience/step_4.dart';
import 'package:goasbar/ui/views/add_experience/step_5.dart';
import 'package:pinput/pinput.dart';
import 'package:stacked/stacked.dart';

class AddExperienceView extends HookWidget {
  const AddExperienceView({super.key, this.experience});

  final ExperienceResults? experience;

  @override
  Widget build(BuildContext context) {
    var title = useTextEditingController();
    var description = useTextEditingController();
    var activities = useTextEditingController();
    var age = useTextEditingController();
    var notes = useTextEditingController();
    var duration = useTextEditingController();
    var link = useTextEditingController();
    var price = useTextEditingController();
    var pageController = usePageController();

    if (experience != null) {
      title.setText(experience?.title ?? "");
      description.setText(experience?.description ?? "");
      activities.setText(experience?.events ?? "");
      age.setText(experience?.minAge.toString() ?? "");
      notes.setText(experience?.locationNotes ?? "");
      duration.setText(experience?.duration ?? "");
      link.setText(experience?.youtubeVideo ?? "");
      price.setText(experience?.price ?? "");
    }

    void handlePublishExperience(AddExperienceInfoViewModel model) async {
      Map<String, dynamic>? body = {};

      body.addAll({
        'title': title.text,
        'min_age': age.text,
        'description': description.text,
        'events': activities.text,
        'city': model.city,
        'price': price.text,
        'gender': model.genderConstraint,
        'duration': duration.text,
        'location_notes': notes.text,
        'categories': model.selectedExperienceCategory!,
        'youtube_video': link.text,
        'longitude': model.latLon!.longitude,
        'latitude': model.latLon!.latitude,
        'provided_goods': model.providedGoodsText,
        'requirements': model.requirementsText
      });

      if (model.isProfileImageFromLocal!) {
        if (!model.mainImage!.path.contains("/media/")) {
          var pickedFile = await MultipartFile.fromFile(
            model.mainImage!.path,
            filename: model.mainImage!.path
                .substring(model.mainImage!.absolute.path.lastIndexOf('/') + 1),
          );
          body.addAll({'profile_image': pickedFile});
        }
      }

      if (model.images! > 0 && model.isHasAdditionalImagesFromLocal!) {
        for (var i = 0; i < model.images!; i++) {
          if (model.additionalImages![i]!.id == null) {
            var pickedFile = await MultipartFile.fromFile(
              model.additionalImages![i]!.image!,
              filename: model.additionalImages![i]!.image!.substring(
                  model.additionalImages![i]!.image!.lastIndexOf('/') + 1),
            );
            body.addAll({'image_set[$i]image': pickedFile});
          }
        }
      }

      if (context.mounted) {
        model
            .createExperience(
          context: context,
          body: body,
        )
            .then((value) {
          model.updateIsClicked(value: false);
          if (value == "duplicate_title") {
            model.updateDuplicateTitle(value: true);
            pageController.jumpToPage(0);
          } else if (value == "created") {
            model.showPublishSuccessBottomSheet().then((value) {
              model.back();
            });
          }
        });
      }
    }

    return ViewModelBuilder<AddExperienceInfoViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
          body: SizedBox(
              child: PageView(
        scrollDirection: Axis.horizontal,
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => model.changeIndex(index: index),
        children: [
          AddExperienceStep1View(
            title: title,
            model: model,
            age: age,
            duration: duration,
            pageController: pageController,
          ),
          AddExperienceStep2View(
              model: model, link: link, pageController: pageController),
          AddExperienceStep3View(
              model: model,
              description: description,
              activities: activities,
              pageController: pageController),
          AddExperienceStep4View(model: model, pageController: pageController),
          AddExperienceStep5View(
            model: model,
            pageController: pageController,
            notes: notes,
            price: price,
            handlePublishExperience: handlePublishExperience,
          ),
        ],
      ))),
      viewModelBuilder: () =>
          AddExperienceInfoViewModel(experience: experience),
      onViewModelReady: (model) => model.onStart(),
    );
  }
}
