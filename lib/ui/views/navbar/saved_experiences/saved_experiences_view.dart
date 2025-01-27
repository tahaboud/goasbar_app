import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/navbar/saved_experiences/saved_experiences_viewmodel.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:goasbar/ui/widgets/saved_experience_card/saved_experience_card.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class SavedExperiencesView extends HookWidget {
  const SavedExperiencesView({super.key, this.text, this.isUser, this.user});
  final String? text;
  final UserModel? user;
  final bool? isUser;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SavedExperiencesViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            height: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                verticalSpaceMedium,
                Text(
                  text!,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ).alignment(Alignment.centerRight),
                verticalSpaceMedium,
                model.isBusy
                    ? const Loader().center()
                    : model.experienceResults!.isEmpty
                        ? Text('You have no saved experiences'.tr()).center()
                        : Expanded(
                            child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              mainAxisSpacing: 10,
                            ),
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: model.experienceResults!.length,
                            itemBuilder: (context, index) {
                              return SavedExperience(
                                isUser: isUser,
                                experience: model.experienceResults![index],
                                futureToRun: () => model.futureToRun(),
                                unFavorite: () => model.updateUserData(
                                    context: context, index: index),
                                user: user,
                              );
                            },
                          )),
              ],
            ),
          ),
        )),
      ),
      viewModelBuilder: () =>
          SavedExperiencesViewModel(user: user, context: context),
    );
  }
}
