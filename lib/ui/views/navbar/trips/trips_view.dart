import 'package:flutter/material.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/ui/views/navbar/trips/trips_viewmodel.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:goasbar/ui/widgets/trip_card/trip_card.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

class TripsView extends HookWidget {
  const TripsView({Key? key, this.text, this.user}) : super(key: key);
  final String? text;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TripsViewModel>.reactive(
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
                  model.isBusy ? const Loader().center() : model.data == null ? const Text('No trips right now').center() : model.data!.isEmpty ? const Text('No trips right now').center() : Expanded(child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: model.experienceModels!.count,
                    itemBuilder: (context, index) {
                      return TripItem(experience: model.experienceModels!.results![index], user: user,);
                    },)
                  ),
                ],
              ),
            ),
          )
        ),
      ),
      viewModelBuilder: () => TripsViewModel(),
    );
  }
}