import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:goasbar/data_models/review_model.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/review/review_viewmodel.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class ReviewView extends HookWidget {
  ReviewView({Key? key, required this.request, required this.completer})
      : super(key: key);

  final SheetRequest request;
  final Function(SheetResponse) completer;

  bool? once = true;

  @override
  Widget build(BuildContext context) {
    var comment = useTextEditingController();
    if (request.data['review'] != null && once!) {
      if (request.data['review'].comment != null) comment.text = request.data['review'].comment;

      once = false;
    }

    return ViewModelBuilder<ReviewViewModel>.reactive(
      builder: (context, model, child) => Container(
        height: screenHeightPercentage(context, percentage: 0.85),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18),),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              verticalSpaceRegular,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Leave your feedback', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)).alignment(Alignment.centerLeft),
                  const Icon(Icons.close, size: 30,).gestures(onTap: () =>model.back(),).alignment(Alignment.centerLeft),
                ],
              ),
              verticalSpaceMedium,
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: request.data['user'] != null ? NetworkImage("$baseUrl${request.data!['user'].image}",)
                            : const AssetImage("assets/images/avatar.png") as ImageProvider,
                        // : FileImage(model.file!) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  horizontalSpaceSmall,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.data['user'] != null ? "${request.data['user'].firstName} ${request.data['user'].lastName}" : "",
                        style: const TextStyle(fontWeight: FontWeight.bold,),
                      ),
                      verticalSpaceTiny,
                      SizedBox(
                        width: screenWidthPercentage(context, percentage: 0.7),
                        child: const Text(
                          'Review are privet and included in your \naccount & trip provider',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: kGrayText, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              verticalSpaceMedium,
              TextField(
                controller: comment,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: 'Describe your experience (optional)',
                  hintStyle: const TextStyle(fontSize: 14),
                  fillColor: Colors.white,
                  filled: true,
                  counterStyle: const TextStyle(color: kMainColor1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black)
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, ),
                  ),
                ),
              ),
              verticalSpaceMedium,
              const Text('Tell us more', style: TextStyle(fontWeight: FontWeight.bold,),).alignment(Alignment.centerLeft),
              verticalSpaceSmall,
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1.2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Evaluation of the professionalism of \nTrip provider',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
                      textAlign: TextAlign.center,
                    ),
                    verticalSpaceSmall,
                    RatingBar.builder(
                      initialRating: request.data['review'] != null ? double.parse(request.data['review'].rate) : 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      glowColor: kMainColor1,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        model.updateRating(value: rating);
                      },
                    )
                  ],
                ).center(),
              ),
              verticalSpaceLarge,
              Container(
                width: MediaQuery.of(context).size.width - 60,
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: kMainGradient,
                ),
                child: model.isClicked! ? const Loader().center() : Center(
                  child: Text('SUBMIT'.tr(), style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500),),
                ),
              ).gestures(
                onTap: () {
                  if (request.data['review'] != null) {
                    Map? body = {};

                    if (model.ratingHasChanged!) body.addAll({"rate": model.rating.toString(),});

                    if (comment.text != request.data['review'].comment && comment.text.isNotEmpty) body.addAll({'comment': comment.text});

                    if (body.isNotEmpty) {
                      model.updateReview(context: context, reviewId: request.data['review'].id, body: body).then((value) {
                        model.updateIsClicked(value: false);
                        if (value is ReviewModel) {
                          completer(SheetResponse(confirmed: true));
                        } else {

                        }
                      });
                    } else {
                      completer(SheetResponse(confirmed: false));
                    }
                  } else {
                    Map? body = {
                      "rate": model.rating.toString(),
                    };

                    if (comment.text.isNotEmpty) body.addAll({'comment': comment.text});

                    model.createReview(context: context, bookingId: request.customData, body: body).then((value) {
                      model.updateIsClicked(value: false);
                      if (value is ReviewModel) {
                        completer(SheetResponse(confirmed: true));
                      } else {

                      }
                    });
                  }
                },
              ),
              verticalSpaceRegular,
            ],
          ),
        ),
      ).height(screenHeightPercentage(context, percentage: 0.85)),
      viewModelBuilder: () => ReviewViewModel(review: request.data['review']),
    );
  }
}