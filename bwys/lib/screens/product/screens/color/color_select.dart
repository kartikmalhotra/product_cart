import 'package:bwys/config/screen_config.dart';
import 'package:bwys/screens/product/model/product_model.dart';
import 'package:bwys/shared/models/product_model.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:flutter/material.dart';

class ColourSelectWidget extends StatefulWidget {
  final Product product;
  const ColourSelectWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _ColourSelectWidgetState createState() => _ColourSelectWidgetState();
}

class _ColourSelectWidgetState extends State<ColourSelectWidget> {
  late Product product;

  @override
  void initState() {
    product = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AppText(
                  "Color",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            AppSizedBoxSpacing(heightSpacing: AppSpacing.l),
            // _showProductColour(),
            AppSizedBoxSpacing(heightSpacing: AppSpacing.xs),
          ],
        ),
      ),
    );
  }

  // Widget _showProductColour() {
  //   return Container(
  //     height: 40,
  //     width: double.maxFinite,
  //     child: ListView.builder(
  //       shrinkWrap: true,
  //       scrollDirection: Axis.horizontal,
  //       itemCount: product.colors.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return Padding(
  //           padding: const EdgeInsets.only(right: 20.0),
  //           child: InkWell(
  //             onTap: () => _productColourSelected(index),
  //             child: Column(
  //               children: [
  //                 Container(
  //                   width: 40.0,
  //                   height: 40,
  //                   decoration: BoxDecoration(
  //                     border: Border.all(
  //                       style: BorderStyle.solid,
  //                       color: product.colors[index].isSelected
  //                           ? Colors.black
  //                           : Colors.white,
  //                       width: 1,
  //                     ),
  //                     shape: BoxShape.circle,
  //                     color: product.colors[index].color,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // void _productColourSelected(int index) {
  //   setState(() {
  //     product.colors.forEach((element) => element.isSelected = false);
  //     product.colors[index].isSelected = true;
  //   });
  // }
}
