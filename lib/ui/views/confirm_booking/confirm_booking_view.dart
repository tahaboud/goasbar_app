import 'package:flutter/material.dart';
import 'package:goasbar/enum/incdecrease.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/checkout/checkout_view.dart';
import 'package:goasbar/ui/views/confirm_booking/confirm_booking_viewmodel.dart';
import 'package:goasbar/ui/widgets/incdecrease_button.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ConfirmBookingView extends HookWidget {
  const ConfirmBookingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var coupon = useTextEditingController();
    var name = useTextEditingController();
    var phone = useTextEditingController();

    return ViewModelBuilder<ConfirmBookingViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_back_sharp).height(40)
                        .width(40)
                        .gestures(
                        onTap: () {
                          model.back();
                        }
                    ),
                    const Text('Confirm Your Booking', style: TextStyle(fontSize: 21),),
                  ],
                ),
                verticalSpaceMedium,
                Row(
                  children: [
                    Container(
                      width: 143,
                      height: 90,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/image4.png"),
                          )
                      ),
                    ).center(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/icons/location.png"),
                            horizontalSpaceTiny,
                            const Text("Dammam , 1 Hour", style: TextStyle(color: kMainGray, fontSize: 11))
                          ],
                        ),
                        verticalSpaceMedium,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.star, color: kStarColor, size: 18),
                            horizontalSpaceTiny,
                            Text('4.0', style: TextStyle(fontWeight: FontWeight.bold,)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(thickness: 1, height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        horizontalSpaceSmall,
                        Text('Available Timings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset('assets/icons/birth_date.png', color: kMainColor1),
                        horizontalSpaceSmall,
                      ],
                    ).gestures(onTap: () => model.showAvailableTimingsPicker(context: context)),
                  ],
                ),
                verticalSpaceMedium,
                SizedBox(
                  height: 80,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: List.generate(10, (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("TH", style: TextStyle(color: index == model.selectedIndexDate ? Colors.white : Colors.black)),
                          verticalSpaceSmall,
                          Text('02', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: index == model.selectedIndexDate ? Colors.white : Colors.black),)
                        ],
                      ),
                    ).decorated(borderRadius: BorderRadius.circular(10), color: index == model.selectedIndexDate ? kMainColor1 : Colors.transparent, animate: true)
                        .animate(const Duration(milliseconds: 300), Curves.easeIn)
                        .gestures(onTap: () {
                      model.changeSelectionDate(index: index);
                    })).toList(),
                  ),
                ),
                verticalSpaceMedium,
                SizedBox(
                  height: 50,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: List.generate(5, (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      child: Text("12AM - 06AM", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: index == model.selectedIndexTime ? Colors.white : kMainColor1)),
                    ).decorated(border: Border.all(color: Colors.black12, width: model.selectedIndexTime == index ? 0 : 2),
                            borderRadius: BorderRadius.circular(10), color: index == model.selectedIndexTime ? kMainColor1 : Colors.transparent,
                            animate: true)
                        .padding(right: 10)
                        .animate(const Duration(milliseconds: 300), Curves.easeIn)
                        .gestures(onTap: () {
                      model.changeSelectionTime(index: index);
                    })).toList(),
                  ),
                ),
                const Divider(thickness: 1.2, height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        horizontalSpaceSmall,
                        Text('Available Places', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('View', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: kMainColor1),).gestures(onTap: () {
                          model.showAvailablePlacesDialog();
                        }),
                        horizontalSpaceSmall,
                      ],
                    ),
                  ],
                ),
                const Divider(thickness: 1.2, height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        horizontalSpaceSmall,
                        Text('Number of Guests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                      ],
                    ),
                    Row(
                      children: [
                        IncDecreaseButton(incDecrease: IncDecrease.increase, model: model),
                        horizontalSpaceSmall,
                        Text(model.numberOfGuests! < 10 ? '0${model.numberOfGuests}' : '${model.numberOfGuests}', style: const TextStyle(fontSize: 20)),
                        horizontalSpaceSmall,
                        IncDecreaseButton(incDecrease: IncDecrease.decrease, model: model),
                        horizontalSpaceSmall,
                      ],
                    ),
                  ],
                ),
                if (model.numberOfGuests! > 0)
                  Column(
                    children: [
                      verticalSpaceSmall,
                      TextField(
                        controller: name,
                        decoration: InputDecoration(
                          hintText: 'Your Full Name',
                          hintStyle: const TextStyle(fontSize: 14),
                          // prefixText: 'Saudi Arabia ( +966 ) | ',
                          fillColor: kTextFiledGrayColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kTextFiledGrayColor),
                          ),
                        ),
                      ),
                      verticalSpaceMedium,
                      TextField(
                        readOnly: true,
                        controller: model.birthDate,
                        decoration: InputDecoration(
                          hintText: '25 . 10 1998',
                          hintStyle: const TextStyle(fontSize: 14),
                          suffixIcon: Image.asset('assets/icons/birth_date.png')
                              .gestures(onTap: () {
                            model.showBirthDayPicker(context);
                          }),
                          fillColor: kTextFiledGrayColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kTextFiledGrayColor),
                          ),
                        ),
                      ),
                      verticalSpaceMedium,
                      TextFormField(
                        controller: phone,
                        validator: model.validatePhoneNumber(value: phone.text),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'xx x - xx x - xx x',
                          hintStyle: const TextStyle(fontSize: 14),
                          // prefixText: 'Saudi Arabia ( +966 ) | ',
                          prefixIcon: const Text('Saudi Arabia ( +966 )  |', style: TextStyle(color: kMainGray, fontSize: 14),).padding(vertical: 20, horizontal: 10),
                          fillColor: kTextFiledGrayColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kTextFiledGrayColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                const Divider(thickness: 1.2, height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        horizontalSpaceSmall,
                        Text('You have Trip coupon ?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidthPercentage(context, percentage: 0.3),
                          height: 40,
                          child: TextField(
                            controller: coupon,
                            decoration: InputDecoration(
                              hintText: 'trips 05',
                              hintStyle: const TextStyle(fontSize: 14,),
                              fillColor: Colors.transparent,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: kTextFiledGrayColor),
                              ),
                            ),
                          ),
                        ),
                        horizontalSpaceSmall,
                      ],
                    ),
                  ],
                ),
                verticalSpaceLarge,
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: kMainGradient,
                  ),
                  child: const Text('Continue with payment', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),).center(),
                ).gestures(
                  onTap:  () {
                    model.navigateTo(view: const CheckoutView());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ConfirmBookingViewModel(),
    );
  }
}
