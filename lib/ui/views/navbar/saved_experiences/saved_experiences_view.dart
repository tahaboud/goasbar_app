import 'package:flutter/material.dart';
import 'package:goasbar/ui/views/navbar/saved_experiences/saved_experiences_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/ui/widgets/saved_experiences.dart';
import 'package:goasbar/ui/widgets/load_header.dart';

class SavedExperiencesView extends HookWidget {
  const SavedExperiencesView({Key? key, this.text}) : super(key: key);
  final String? text;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SavedExperiencesViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        bottomNavigationBar: const BottomAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: model.isBusy ? LoadHeader(text: text)
                  : SavedExperiences(text: text, onTap: () => model.back()),
            ),
          )
        ),
      ),
      viewModelBuilder: () => SavedExperiencesViewModel(),
      onModelReady: (model) => model.loadData(),
    );
  }
}