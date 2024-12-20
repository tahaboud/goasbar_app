import 'package:goasbar/enum/bottom_sheet_type.dart';
import 'package:goasbar/ui/views/be_hosted/be_hosted_view.dart';
import 'package:goasbar/ui/views/publish_success/publish_success_view.dart';
import 'package:goasbar/ui/views/review/review_view.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';

void setupBottomSheetUi() {
  final bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.beHosted: (context, sheetRequest, completer) =>
        BeHostedView(request: sheetRequest, completer: completer),
    BottomSheetType.publishSuccess: (context, sheetRequest, completer) =>
        PublishSuccessView(request: sheetRequest, completer: completer),
    BottomSheetType.review: (context, sheetRequest, completer) =>
        ReviewView(request: sheetRequest, completer: completer),
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}
