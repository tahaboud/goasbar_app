import 'package:flutter/material.dart';
import 'package:goasbar/ui/views/navbar/trips/trips_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/ui/widgets/trips.dart';
import 'package:goasbar/ui/widgets/load_header.dart';

class TripsView extends HookWidget {
  const TripsView({Key? key, this.text}) : super(key: key);
  final String? text;

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
              child: model.isBusy ? LoadHeader(text: text)
                  : Trips(text: text, model: model),
            ),
          )
        ),
      ),
      viewModelBuilder: () => TripsViewModel(),
      onModelReady: (model) => model.loadData(),
    );
  }
}