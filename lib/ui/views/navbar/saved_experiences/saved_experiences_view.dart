import 'package:flutter/material.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/navbar/saved_experiences/saved_experiences_viewmodel.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:goasbar/ui/widgets/saved_experience_card/saved_experience_card.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

class SavedExperiencesView extends HookWidget {
  const SavedExperiencesView({Key? key, this.text, this.user}) : super(key: key);
  final String? text;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SavedExperiencesViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        bottomNavigationBar: const BottomAppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              height: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  verticalSpaceMedium,
                  Text(text!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),).alignment(Alignment.centerLeft),
                  verticalSpaceMedium,
                  model.isBusy ? const Loader().center() : model.experienceResults!.isEmpty ? const Text('You have no saved experiences').center() : Expanded(child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 10,
                    ),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: model.experienceResults!.length,
                    itemBuilder: (context, index) {
                      return SavedExperience(experience: model.experienceResults![index], futureToRun: () => model.futureToRun(), unFavorite: () => model.updateUserData(index: index), user: user,);
                    },)
                  ),
                ],
              ),
            ),
          )
        ),
      ),
      viewModelBuilder: () => SavedExperiencesViewModel(user: user),
    );
  }
}