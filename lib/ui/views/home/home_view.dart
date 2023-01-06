import 'package:flutter/material.dart';
import 'package:goasbar/ui/views/home/home_viewmodel.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Home", style: TextStyle(color: Colors.black),),
          ],
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
