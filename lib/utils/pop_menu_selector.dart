import 'package:biz_scan_app/widgets/delete_dialog.dart';
import 'package:biz_scan_app/widgets/share_with_colleague_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<void> handleDropdownSelection(
  String newValue,
  BuildContext context,
) async {
  debugPrint('The new value is $newValue');

  switch (newValue) {
    case 'Share with a colleague':
      showShareDialog(context);
      break;

    case 'Delete contact':
      showDeleteDialog(context);
      break;

    default:
      debugPrint('Unknown option selected');
      break;
  }
}
