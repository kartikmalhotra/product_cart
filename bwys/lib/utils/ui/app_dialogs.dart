import 'package:bwys/config/screen_config.dart';
import 'package:bwys/config/themes/light_theme.dart';
import 'package:bwys/shared/models/rest_api_error_model.dart';
import 'package:bwys/utils/services/app_localization.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:bwys/widget/widget.dart';
import 'package:flutter/material.dart';

class AppDialogs {
  /// This function is used to display the loading dialog on the screen with of which the context has been passed in the argument.
  ///
  /// Required Params:
  /// 1. context of the screen on which to display the loading dialog.
  /// 2. key is the GloblaKey to provide the context information
  ///
  /// Optional Params:
  /// 1. message which has to be displayed on the dialog
  static Future<void> showLoadingDialog(BuildContext context, GlobalKey? key,
      {String? message}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            key: key,
            backgroundColor: Theme.of(context).cardColor,
            children: getAppDialogLoaderWidgets(context, key, message),
          ),
        );
      },
    );
  }

  /// This function returns the list of Widgets to displayed in the loading dialog
  static List<Widget> getAppDialogLoaderWidgets(
      BuildContext context, GlobalKey? key, String? message) {
    List<Widget> _dialogLoaderContent = [
      Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            children: [
              const AppCircularProgressLoader(),
              const SizedBox(height: AppSpacing.ms),
              AppText(
                message ?? 'loading_text',
                style: Theme.of(context).textTheme.bodyText1,
              )
            ],
          ),
        ),
      )
    ];
    return _dialogLoaderContent;
  }

  /// Common Method to display the Bottom sheet in flutter
  static Future<T?> showAppModalBottomSheet<T>(
      BuildContext context, Widget widget,
      {double? bottomSheetHeight,
      bool removePadding = false,
      Color? backgroundColor}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      builder: (BuildContext context) {
        return bottomSheetHeight == null
            ? SafeArea(
                top: false,
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: (!removePadding)
                          ? const EdgeInsets.fromLTRB(AppSpacing.m,
                              AppSpacing.s, AppSpacing.m, AppSpacing.s)
                          : const EdgeInsets.all(0.0),
                      child: widget,
                    ),
                  ],
                ),
              )
            : SafeArea(
                top: false,
                child: SizedBox(
                  height: bottomSheetHeight,
                  width: double.infinity,
                  child: Padding(
                    padding: (!removePadding)
                        ? const EdgeInsets.fromLTRB(AppSpacing.m, AppSpacing.s,
                            AppSpacing.m, AppSpacing.s)
                        : const EdgeInsets.all(0.0),
                    child: widget,
                  ),
                ),
              );
      },
    );
  }

  /// Common Method to display the Dailog on screen
  ///
  /// IF [widget] is passed then all the content of Dialog will be that widget.
  ///
  /// [title], [Description],[actionButtons] are required to show the AlertDialog
  ///
  /// If [actionButton] is not provided the default action button "OK" will be visible to dismis the dialog
  static Future showAppDialog(
    BuildContext context, {
    String? title,
    String? description,
    List<Widget>? actionButtons,
    Widget? widget,
    Color? dialogBackgroundColor,
    bool barrierDismissible = false,
    Function(Map<String, dynamic> data, BuildContext context)?
        onActionButtonPressed,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        if (widget != null) {
          return AppProgressDialog(
            widget: widget,
            dialogBackgroundColor: dialogBackgroundColor,
          );
        } else {
          return _showAlertDialog(
            context,
            title!,
            description,
            actionButtons,
          );
        }
      },
    ).then((data) {
      if (data is RestAPIErrorModel) {
        return Future.value(data);
      } else if (data is Map) {
        return Future.value(
            onActionButtonPressed!(data as Map<String, dynamic>, context));
      }

      return Future.value();
    });
  }

  /// To show the Default Alert Dialog to the user
  static Widget _showAlertDialog(BuildContext context, String title,
      String? description, List<Widget>? actionButtons) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.m),
      ),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .subtitle2!
            .copyWith(color: LightAppColors.primaryTextColor),
      ),
      content: AppText(
        description,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      actions: actionButtons ??
          <Widget>[
            AppTextButton(
              message: AppLocalizations.of(context)!.translate('ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
    );
  }
}

/// Common class to show the dialog in the with the content of the [widget] provided
class AppProgressDialog extends StatelessWidget {
  /// Widget that will be visible in the Dialog
  final Widget widget;

  /// Dialog background color
  final Color? dialogBackgroundColor;

  const AppProgressDialog({
    required this.widget,
    this.dialogBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: LightAppColors.primaryButtonTextColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.m),
      ),
      elevation: 0.0,
      child: widget,
    );
  }
}
