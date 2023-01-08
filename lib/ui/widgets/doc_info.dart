import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/ui/widgets/dot_item.dart';
import 'package:goasbar/ui/widgets/info_item.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/shared/ui_helpers.dart';

class DocInfo extends StatelessWidget {
  const DocInfo({
    Key? key,
    required this.identityNumber,
    required this.pageController,
    this.onTapBack,
    this.typeOfIdentity,
    this.onTapShowTypeOfIdentity,
    this.condition,
    this.onTapPickImage,
    this.showErrorDialog,
  }) : super(key: key);

  final TextEditingController identityNumber;
  final PageController pageController;
  final Function()? onTapBack;
  final Function()? onTapPickImage;
  final Function? showErrorDialog;
  final Function()? onTapShowTypeOfIdentity;
  final TextEditingController? typeOfIdentity;
  final bool? condition;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: screenHeightPercentage(context, percentage: 0.85),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18),),
        color: Colors.white,
      ),
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.close, size: 30,).gestures(onTap: onTapBack),
              horizontalSpaceTiny,
              const Text('DOCUMENTED INFORMATION', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('2 - 3', style: TextStyle(color: kMainColor1, fontSize: 14, fontWeight: FontWeight.bold),).center(),
                  ).width(40)
                      .height(40)
                      .opacity(0.6),
                  Row(
                    children: const [
                      DotItem(condition: false, color: kMainColor1),
                      horizontalSpaceTiny,
                      DotItem(condition: true, color: kMainColor1),
                      horizontalSpaceTiny,
                      DotItem(condition: false, color: kMainColor1),
                    ],
                  ),
                ],
              ),
            ],
          ),
          verticalSpaceMedium,
          const Text('Identity information', style: TextStyle(fontWeight: FontWeight.bold),),
          verticalSpaceSmall,
          Container(
            decoration: BoxDecoration(
              color: kTextFiledMainColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpaceSmall,
                Row(
                  children: const [
                    horizontalSpaceSmall,
                    Text("Type of identity"),
                  ],
                ),
                SizedBox(
                  height: 40,
                  child: TextField(
                    readOnly: true,
                    controller: typeOfIdentity,
                    decoration: InputDecoration(
                      hintText: '--- --- ---',
                      hintStyle: const TextStyle(fontSize: 14),
                      suffixIcon: const Icon(Icons.arrow_drop_down)
                          .gestures(onTap: onTapShowTypeOfIdentity),
                      fillColor: kTextFiledMainColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpaceRegular,
          InfoItem(
            controller: identityNumber,
            label: 'Identity number',
            hintText: '--- --- ---',
          ),
          verticalSpaceRegular,
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: kTextFiledMainColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/icons/camera.png"),
                const Text("upload identity image", style: TextStyle(color: kGrayText,)),
              ],
            ).center(),
          ),
          verticalSpaceRegular,
          Container(
            width: MediaQuery.of(context).size.width - 60,
            height: 50,
            decoration: condition! ? BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: kMainColor1.withOpacity(0.6),
            ) : const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: kMainGradient,
            ),
            child: const Center(
              child: Text('UPLOAD', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
            ),
          ).gestures(onTap: onTapPickImage,),
          verticalSpaceLarge,
          Container(
            width: MediaQuery.of(context).size.width - 60,
            height: 50,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: kMainGradient,
            ),
            child: const Center(
              child: Text('NEXT', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
            ),
          ).gestures(
            onTap: () {
              if (typeOfIdentity!.text.isNotEmpty && identityNumber.text.isNotEmpty && !condition!) {
                pageController.jumpToPage(2);
              } else {
                showErrorDialog!();
              }
            },
          ),
          verticalSpaceRegular,
        ],
      ),
    );
  }
}