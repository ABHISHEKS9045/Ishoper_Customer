import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../localization/language_constrants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/dimensions.dart';
import '../../../base/title_row.dart';
import '../specification_screen.dart';
import '../view_auction_details.dart';

class ProductSpecification extends StatelessWidget {
  final String productSpecification;
  var productType;
  var productId;
  ProductSpecification({@required this.productSpecification, this.productType, this.productId });
  ColorResources color = ColorResources();
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    return Column(
      children: [
        TitleRow(
          title: getTranslated('specification', context),
          isDetailsPage: true,
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        productSpecification.isNotEmpty
        // var data2 = productSpecification
            ? Expanded(
                child: Html(
                  data: productSpecification,
                  tagsList: Html.tags,

                  customRenders: {
                    tableMatcher(): tableRender(),
                  },
                  style: {
                    "body": Style(
                      fontSize: FontSize(15.0),
                      textAlign: TextAlign.justify

                    ),


                    // "table": Style(
                    //   backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                    //   fontSize: FontSize.larger
                    //
                    // ),
                    "tr": Style(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    "th": Style(
                      padding: EdgeInsets.all(6),
                      backgroundColor: Colors.grey,
                    ),
                    "td": Style(
                      padding: EdgeInsets.all(6),
                      alignment: Alignment.topLeft,
                    ),
                  },
                ),
              )
            : Center(child: Text('No specification')),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
        Row(
          mainAxisAlignment: productType == 2? MainAxisAlignment.spaceAround : MainAxisAlignment.center   ,
          children: [
            InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SpecificationScreen(
                            specification: productSpecification))),
                child: Text(
                  getTranslated('view_full_detail', context),
                  style: titilliumRegular.copyWith(color: color.colortheme),
                )
            ),
            productType == 2 ? InkWell(
                onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ViewAuctionDetails(
                        productId: productId,
                      )),
                    );
                },
                child:Text(
                  getTranslated('view_auction_detail', context),
                  style: titilliumRegular.copyWith(color: color.colortheme),
                )):Container(),
          ],
        )
      ],
    );
  }
}
