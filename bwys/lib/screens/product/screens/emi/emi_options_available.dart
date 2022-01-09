import 'package:bwys/config/screen_config.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:flutter/material.dart';

class EmiOptionsAvailable extends StatelessWidget {
  const EmiOptionsAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                "EMI option available",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              AppText(
                "View Plan",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.pinkAccent),
              )
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          AppText("EMI starting from Rs. 50/month"),
        ],
      ),
    );
  }
}
