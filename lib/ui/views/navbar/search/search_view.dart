import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/confirm_booking/confirm_booking_view.dart';
import 'package:goasbar/ui/views/navbar/search/search_viewmodel.dart';
import 'package:goasbar/ui/widgets/close_view.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

class SearchView extends HookWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var searchCity = useTextEditingController();
    var searchDate = useTextEditingController();
    var participantsCategory = useTextEditingController();
    var price = useTextEditingController();
    var price2 = useTextEditingController();
    var experienceCategory = useTextEditingController();

    return ViewModelBuilder<SearchViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpaceMedium,
                  const Text('Where are you going ?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  verticalSpaceMedium,
                  TextField(
                    controller: searchCity,
                    decoration: InputDecoration(
                      hintText: 'Search City',
                      hintStyle: const TextStyle(fontSize: 14),
                      prefixIcon: Image.asset("assets/icons/navbar/search.png"),
                      fillColor: kTextFiledGrayColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kTextFiledGrayColor),
                      ),
                    ),
                  ),
                  verticalSpaceRegular,
                  TextField(
                    controller: searchDate,
                    decoration: InputDecoration(
                      hintText: 'Search Date',
                      hintStyle: const TextStyle(fontSize: 14),
                      prefixIcon: Image.asset('assets/icons/birth_date.png'),
                      fillColor: kTextFiledGrayColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kTextFiledGrayColor),
                      ),
                    ),
                  ),
                  verticalSpaceRegular,
                  TextField(
                    controller: participantsCategory,
                    decoration: InputDecoration(
                      hintText: 'Participants Category',
                      hintStyle: const TextStyle(fontSize: 14),
                      prefixIcon: Image.asset("assets/icons/user_square.png"),
                      fillColor: kTextFiledGrayColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: kTextFiledGrayColor),
                      ),
                    ),
                  ),
                  verticalSpaceRegular,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: screenWidthPercentage(context, percentage: 0.42),
                        child: TextField(
                          controller: price,
                          decoration: InputDecoration(
                            hintText: 'Price 00.00 SR',
                            hintStyle: const TextStyle(fontSize: 14),
                            prefixIcon: Image.asset("assets/icons/receipt.png"),
                            fillColor: kTextFiledGrayColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: kTextFiledGrayColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidthPercentage(context, percentage: 0.42),
                        child: TextField(
                          controller: price2,
                          decoration: InputDecoration(
                            hintText: '00.00 SR',
                            hintStyle: const TextStyle(fontSize: 14),
                            fillColor: kTextFiledGrayColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: kTextFiledGrayColor),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  verticalSpaceRegular,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidthPercentage(context, percentage: 0.72),
                        child: TextField(
                          controller: experienceCategory,
                          decoration: InputDecoration(
                            hintText: 'Experience Category',
                            hintStyle: const TextStyle(fontSize: 14),
                            prefixIcon: Image.asset("assets/icons/navbar/experience.png"),
                            fillColor: kTextFiledGrayColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: kTextFiledGrayColor),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 55,
                        height: 55,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: kMainGradient,
                        ),
                        child: Center(
                          child: Image.asset("assets/icons/navbar/search.png", color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  verticalSpaceLarge,
                  const Text('Popular search', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  verticalSpaceMedium,
                  SizedBox(
                    height: 255,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          height: 250,
                          width: 200,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 1,
                                offset: Offset(0, 0),
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 200,
                                height: 150,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/image4.png"),
                                  )
                                ),
                              ).center(),
                              verticalSpaceSmall,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Dammam Trip', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Row(
                                    children: const [
                                      Text('4.0'),
                                      horizontalSpaceTiny,
                                      Icon(Icons.star, color: kStarColor,)
                                    ],
                                  )
                                ],
                              ),
                              verticalSpaceSmall,
                              Row(
                                children: [
                                  Image.asset("assets/icons/location.png"),
                                  horizontalSpaceTiny,
                                  const Text("Dammam , 1 Hour", style: TextStyle(color: kMainGray, fontSize: 11))
                                ],
                              ),
                              verticalSpaceSmall,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Text('76.00 SR', style: TextStyle(color: kMainColor1, fontSize: 9)),
                                      Text(' / Person', style: TextStyle(color: kMainGray, fontSize: 9)),
                                    ],
                                  ),
                                  Container(
                                    width: 70,
                                    height: 25,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      gradient: kMainGradient,
                                    ),
                                    child: const Text('Book Now', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),).center(),
                                  ).gestures(onTap: () {
                                    model.navigateTo(view: const ConfirmBookingView());
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                        horizontalSpaceRegular,
                        Container(
                          height: 250,
                          width: 200,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 1,
                                offset: Offset(0, 0),
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 200,
                                height: 150,
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/image4.png"),
                                    )
                                ),
                              ).center(),
                              verticalSpaceSmall,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Dammam Trip', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Row(
                                    children: const [
                                      Text('4.0'),
                                      horizontalSpaceTiny,
                                      Icon(Icons.star, color: kStarColor,)
                                    ],
                                  )
                                ],
                              ),
                              verticalSpaceSmall,
                              Row(
                                children: [
                                  Image.asset("assets/icons/location.png"),
                                  horizontalSpaceTiny,
                                  const Text("Dammam , 1 Hour", style: TextStyle(color: kMainGray, fontSize: 11))
                                ],
                              ),
                              verticalSpaceSmall,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Text('76.00 SR', style: TextStyle(color: kMainColor1, fontSize: 9)),
                                      Text(' / Person', style: TextStyle(color: kMainGray, fontSize: 9)),
                                    ],
                                  ),
                                  Container(
                                    width: 70,
                                    height: 25,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      gradient: kMainGradient,
                                    ),
                                    child: const Text('Book Now', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),).center(),
                                  ).gestures(onTap: () {
                                    model.navigateTo(view: const ConfirmBookingView());
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ),
      ),
      viewModelBuilder: () => SearchViewModel(),
    );
  }
}