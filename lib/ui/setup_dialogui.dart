import 'package:goasbar/ui/widgets/dialogs/add_data/add_data_view.dart';
import 'package:goasbar/ui/widgets/dialogs/available_places_dialog.dart';
import 'package:goasbar/ui/widgets/dialogs/booking_list/booking_list_dialog.dart';
import 'package:goasbar/ui/widgets/dialogs/error_dialog.dart';
import 'package:goasbar/ui/widgets/dialogs/profile_booked/profile_booked_dialog.dart';
import 'package:goasbar/ui/widgets/dialogs/selection_custom_dialog.dart';
import 'package:goasbar/ui/widgets/dialogs/type_of_identity_dialog.dart';
import 'package:flutter/material.dart';
import 'package:goasbar/app/app.locator.dart';
import 'package:goasbar/enum/dialog_type.dart';
import 'package:goasbar/ui/widgets/dialogs/wait_until_payment_fiished_dialog.dart';
import 'package:stacked_services/stacked_services.dart';

void setupDialogUi() {
  var dialogService = locator<DialogService>();

  var builders = {
    DialogType.selection : (BuildContext context, DialogRequest dialogRequest, Function(DialogResponse) completer)
        => Dialog(child: SelectionCustomDialog(dialogRequest: dialogRequest, onDialogTap: completer,),),

    DialogType.basic : (BuildContext context, DialogRequest dialogRequest, Function(DialogResponse) completer)
        => Container(),

    DialogType.availablePlaces : (BuildContext context, DialogRequest dialogRequest, Function(DialogResponse) completer)
        => Dialog(child: AvailablePlacesDialog(dialogRequest: dialogRequest, onDialogTap: completer,),),

    DialogType.typeOfIdentity : (BuildContext context, DialogRequest dialogRequest, Function(DialogResponse) completer)
        => Dialog(child: TypeOfIdentityDialog(dialogRequest: dialogRequest, onDialogTap: completer,),),

    DialogType.error : (BuildContext context, DialogRequest dialogRequest, Function(DialogResponse) completer)
        => Dialog(child: ErrorDialog(dialogRequest: dialogRequest, onDialogTap: completer,),),

    DialogType.bookingList : (BuildContext context, DialogRequest dialogRequest, Function(DialogResponse) completer)
        => Dialog(child: BookingListDialog(dialogRequest: dialogRequest, onDialogTap: completer,),),

    DialogType.addData : (BuildContext context, DialogRequest dialogRequest, Function(DialogResponse) completer)
        => Dialog(child: AddDataView(dialogRequest: dialogRequest, onDialogTap: completer,),),

    DialogType.profile : (BuildContext context, DialogRequest dialogRequest, Function(DialogResponse) completer)
        => Dialog(child: ProfileBookedDialog(dialogRequest: dialogRequest, onDialogTap: completer,),),

    DialogType.waitingUntilPaymentFinished : (BuildContext context, DialogRequest dialogRequest, Function(DialogResponse) completer)
        => Dialog(child: WaitingUntilPaymentFinishedDialog(dialogRequest: dialogRequest, onDialogTap: completer,),),
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
