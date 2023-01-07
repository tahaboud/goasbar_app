import 'package:flutter/material.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/chat_with_agency/chat_with_agency_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChatWithAgencyView extends HookWidget {
  const ChatWithAgencyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var message = useTextEditingController();

    return ViewModelBuilder<ChatWithAgencyViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                verticalSpaceRegular,
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
                    const Text('E-salam Agency', style: TextStyle(fontSize: 21),),
                  ],
                ),
                verticalSpaceMedium,
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/images/user.png"),
                          horizontalSpaceSmall,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: const Text("Hello sir").padding(horizontal: 20, vertical: 10),
                              ).decorated(
                                color: kAgencyColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              verticalSpaceTiny,
                              SizedBox(
                                child: const Text("Did you arrive in my Home address").padding(horizontal: 20, vertical: 10),
                              ).decorated(
                                color: kAgencyColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              verticalSpaceTiny,
                              Row(
                                children: [
                                  const Text('15 m', style: TextStyle(color: kMainGray, fontSize: 13),),
                                  horizontalSpaceSmall,
                                  Image.asset("assets/icons/sms.png"),
                                ],
                              ),
                              verticalSpaceSmall,
                            ],
                          )
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            child: const Text("Hello sir", style: TextStyle(color: Colors.white),).padding(horizontal: 20, vertical: 10),
                          ).decorated(
                            color: kMainColor1,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(5),
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          verticalSpaceTiny,
                          SizedBox(
                            child: const Text("Did you arrive in my Home address", style: TextStyle(color: Colors.white),).padding(horizontal: 20, vertical: 10),
                          ).decorated(
                            color: kMainColor1,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          verticalSpaceTiny,
                          const Text('Seen . 27m', style: TextStyle(color: kMainGray, fontSize: 13),),
                          verticalSpaceSmall,
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/images/user.png"),
                          horizontalSpaceSmall,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: const Text("Hello sir").padding(horizontal: 20, vertical: 10),
                              ).decorated(
                                color: kAgencyColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              verticalSpaceTiny,
                              SizedBox(
                                child: const Text("Did you arrive in my Home address").padding(horizontal: 20, vertical: 10),
                              ).decorated(
                                color: kAgencyColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  topLeft: Radius.circular(5),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              verticalSpaceTiny,
                              Row(
                                children: [
                                  const Text('15 m', style: TextStyle(color: kMainGray, fontSize: 13),),
                                  horizontalSpaceSmall,
                                  Image.asset("assets/icons/sms.png"),
                                ],
                              ),
                              verticalSpaceSmall,
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            child: const Text("Hello sir", style: TextStyle(color: Colors.white),).padding(horizontal: 20, vertical: 10),
                          ).decorated(
                            color: kMainColor1,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(5),
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          verticalSpaceTiny,
                          SizedBox(
                            child: const Text("Did you arrive in my Home address", style: TextStyle(color: Colors.white),).padding(horizontal: 20, vertical: 10),
                          ).decorated(
                            color: kMainColor1,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          verticalSpaceTiny,
                          const Text('Seen . 27m', style: TextStyle(color: kMainGray, fontSize: 13),),
                          verticalSpaceSmall,
                        ],
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: message,
                  decoration: InputDecoration(
                    hintText: 'Type Something...',
                    hintStyle: const TextStyle(fontSize: 14),
                    suffixIcon: Image.asset("assets/icons/import.png").gestures(onTap: () => model.upload()),
                    icon: Image.asset("assets/icons/file.png").gestures(onTap: () => model.file()),
                    fillColor: kTextFiledGrayColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: kTextFiledGrayColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ChatWithAgencyViewModel(),
    );
  }
}