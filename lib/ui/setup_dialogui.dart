import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:styled_widget/styled_widget.dart';

void setupDialogUi() {
  var dialogService = locator<DialogService>();

  var builders = {
    DialogType.selection : (BuildContext context, DialogRequest dialogRequest, Function(DialogResponse) completer)
        => Dialog(child: _SelectionCustomDialog(dialogRequest: dialogRequest, onDialogTap: completer,),),

    DialogType.basic : (BuildContext context, DialogRequest dialogRequest, Function(DialogResponse) completer)
        => Container(),

    DialogType.availablePlaces : (BuildContext context, DialogRequest dialogRequest, Function(DialogResponse) completer)
        => Dialog(child: _AvailablePlacesDialog(dialogRequest: dialogRequest, onDialogTap: completer,),),

    DialogType.typeOfIdentity : (BuildContext context, DialogRequest dialogRequest, Function(DialogResponse) completer)
        => Dialog(child: _TypeOfIdentityDialog(dialogRequest: dialogRequest, onDialogTap: completer,),),

    DialogType.error : (BuildContext context, DialogRequest dialogRequest, Function(DialogResponse) completer)
        => Dialog(child: _ErrorDialog(dialogRequest: dialogRequest, onDialogTap: completer,),),
  };

  dialogService.registerCustomDialogBuilders(builders);
}

// class _BasicCustomDialog extends StatelessWidget {
//   final DialogRequest? dialogRequest;
//   final Function(DialogResponse)? onDialogTap;
//   const _BasicCustomDialog({Key? key, this.dialogRequest, this.onDialogTap})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Text(
//             'dialogRequest!.title!',
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Text(
//             'dialogRequest!.description!',
//             style: TextStyle(fontSize: 18),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           GestureDetector(
//             onTap: () => onDialogTap!(DialogResponse(confirmed: true)),
//             child: Container(
//               child: 'dialogRequest.showIconInMainButton' == ''
//                   ? Icon(Icons.check_circle)
//                   : Text('dialogRequest.mainButtonTitle'),
//               alignment: Alignment.center,
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.redAccent,
//                 borderRadius: BorderRadius.circular(5),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

class _AvailablePlacesDialog extends HookWidget {
  final DialogRequest? dialogRequest;
  final Function(DialogResponse)? onDialogTap;
  const _AvailablePlacesDialog({Key? key, this.dialogRequest, this.onDialogTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidthPercentage(context, percentage: 0.4),
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(CupertinoIcons.clear_circled, size: 20),
              horizontalSpaceSmall,
            ],
          ).gestures(onTap: () => onDialogTap!(DialogResponse())),
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  horizontalSpaceMedium,
                  Text('Booked Places : '),
                ],
              ),
              Row(
                children: const [
                  Text("50", style: TextStyle(color: kMainColor1),),
                  Text("Sit",),
                  horizontalSpaceMedium,
                ],
              ),
            ],
          ),
          verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  horizontalSpaceMedium,
                  Text('Available Places : '),
                ],
              ),
              Row(
                children: const [
                  Text("13", style: TextStyle(color: kMainColor1),),
                  Text("Sit",),
                  horizontalSpaceMedium,
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _SelectionCustomDialog extends HookWidget {
  final DialogRequest? dialogRequest;
  final Function(DialogResponse)? onDialogTap;
  const _SelectionCustomDialog({Key? key, this.dialogRequest, this.onDialogTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidthPercentage(context, percentage: 0.4),
      height: 81,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            color : dialogRequest!.data == 'Male' ? kMainDisabledGray : Colors.white,
            child: const Text('Male')
                .center(),
          ).gestures(onTap: () {
            onDialogTap!(DialogResponse(data: 'Male',));
          }),
          const Divider(height: 1, thickness: 2),
          // verticalSpaceRegular,
          Container(
            height: 40,
            color : dialogRequest!.data == 'Female' ? kMainDisabledGray : Colors.white,
            child: const Text('Female')
                .center(),
          ).gestures(onTap: () {
            onDialogTap!(DialogResponse(data: 'Female',));
          }),
        ],
      ),
    );
  }
}

class _TypeOfIdentityDialog extends HookWidget {
  final DialogRequest? dialogRequest;
  final Function(DialogResponse)? onDialogTap;
  const _TypeOfIdentityDialog({Key? key, this.dialogRequest, this.onDialogTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidthPercentage(context, percentage: 0.4),
      height: 81,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            color : dialogRequest!.data == 'Passport' ? kMainDisabledGray : Colors.white,
            child: const Text('Passport')
                .center(),
          ).gestures(onTap: () {
            onDialogTap!(DialogResponse(data: 'Passport',));
          }),
          const Divider(height: 1, thickness: 2),
          // verticalSpaceRegular,
          Container(
            height: 40,
            color : dialogRequest!.data == 'National Card ID' ? kMainDisabledGray : Colors.white,
            child: const Text('National Card ID')
                .center(),
          ).gestures(onTap: () {
            onDialogTap!(DialogResponse(data: 'National Card ID',));
          }),
        ],
      ),
    );
  }
}

class _ErrorDialog extends HookWidget {
  final DialogRequest? dialogRequest;
  final Function(DialogResponse)? onDialogTap;
  const _ErrorDialog({Key? key, this.dialogRequest, this.onDialogTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
              verticalSpaceRegular,
              const Text(
                "Error",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              verticalSpaceSmall,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'You got errors',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpaceRegular,
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 50,
                  width: screenWidthPercentage(context, percentage: 0.6),
                  decoration: const BoxDecoration(
                    gradient: kMainGradient,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Center(
                    child: Text(
                      "Try again",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).height(220);
  }
}
