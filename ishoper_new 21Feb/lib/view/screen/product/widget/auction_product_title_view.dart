import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/mycartpage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:slide_countdown/slide_countdown.dart';

class AuctionProductTitleView extends StatelessWidget {
  static const String TAG = "AuctionProductTitleView";

  final productModel;
  final countBids;
  final isActive;

  AuctionProductTitleView({
    @required this.productModel,
    this.isActive,
    this.countBids,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("$TAG  details.isActivedata, ============> ${isActive}");

    DateTime currentDateTime = DateTime.now();

    double _startingPrice = 0;
    double _endingPrice;

    return productModel != null
        ? Container(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Consumer<ProductDetailsProvider>(
              builder: (context, details, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  productModel['name'] ?? '',
                                  style: titleRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              isActive != 0 ?
                              Container(child:   countBids == null
                                 ? Text(
                               '',
                               style: titilliumRegular.copyWith(
                                 color: color.Pricecolor,
                                 fontSize: Dimensions.FONT_SIZE_LARGE,
                               ),
                             )
                                 : Container(
                               child: countBids['latest_bid'].toString() != details.auctionData['reserve_price']
                                   ?
                                 Text(
                                 'Current Bid: ${countBids['latest_bid']}',
                                 style: titilliumRegular.copyWith(
                                   color: color.Pricecolor,
                                   fontSize: Dimensions.FONT_SIZE_LARGE,
                                 ),
                               )
                                   : Container(),
                             ),):Container()
                            ],
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          isActive != 0
                              ? Row(
                                  children: [
                                    // productModel['is_done'] == 0
                                    Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          details.diff != null
                                              ? Text(
                                                  '${details.diff.isAfter(currentDateTime) ? "UpComing In" : "Ends In"}',

                                                  style: titilliumRegular.copyWith(
                                                    color: Colors.black,
                                                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                                  ),
                                                )
                                              : Container(),
                                          SizedBox(
                                            height: 5,

                                          ),
                                          details.diff != null
                                              ? Container(
                                                  child: details.diff.isAfter(currentDateTime)
                                                      ? SlideCountdownSeparated(
                                                          duration: Duration(days: details.days, hours: details.hours, minutes: details.minutes, seconds: details.seconds),
                                                          decoration: BoxDecoration(
                                                            color: HexColor("#FFBE81"),
                                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                                          ),
                                                        )
                                                      : SlideCountdownSeparated(
                                                          separatorType: SeparatorType.symbol,
                                                          separatorStyle: TextStyle(),
                                                          duration: Duration(days: details.days1, hours: details.hours1, minutes: details.minutes1, seconds: details.seconds1),
                                                          decoration: BoxDecoration(
                                                            color: HexColor("#FFBE81"),
                                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                                          ),
                                                        ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ),

                                    Expanded(child: SizedBox.shrink()),
                                    SizedBox(width: 5),
                                    countBids != null
                                        ? Container(
                                            child: countBids['bid_user_count'].toString() != null
                                                ? Text('${countBids['bid_user_count'].toString()} Bids',
                                                    style: titilliumRegular.copyWith(
                                                      color: Colors.black,
                                                      fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                                    ))
                                                : Container(),
                                          )
                                        : Container()
                                  ],
                                )
                              : Container()
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Row(
                      children: [
                        Text(
                          '${details.reviewList != null ? details.reviewList.length : 0} reviews | ',
                          style: titilliumRegular.copyWith(
                            color: Theme.of(context).hintColor,
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                        Text(
                          '${details.orderCount} orders | ',
                          style: titilliumRegular.copyWith(
                            color: Theme.of(context).hintColor,
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                        Text(
                          '${details.wishCount} wish',
                          style: titilliumRegular.copyWith(
                            color: Theme.of(context).hintColor,
                            fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          ),
                        ),
                        Expanded(child: SizedBox.shrink()),
                        SizedBox(width: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: HexColor('#EEC200'),
                            ),
                            Text('${productModel['rating'] != null ? productModel['rating'].length > 0 ? double.parse(productModel['rating'][0]['average']) : 0.0 : 0.0}')
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    productModel['colors'].length > 0
                        ? Row(
                            children: [
                              Text(
                                '${getTranslated('select_variant', context)} : ',
                                style: titilliumRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  itemCount: productModel['colors'].length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    String colorString = '0xff' + productModel['colors'][index]['code'].substring(1, 7);
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Color(int.parse(colorString)),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                    productModel['colors'].length > 0 ? SizedBox(height: Dimensions.PADDING_SIZE_SMALL) : SizedBox(),
                    productModel['choiceOptions'] != null && productModel['choiceOptions'].length > 0
                        ? Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: productModel['choiceOptions'].length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${getTranslated('available', context)}' + ' ' + '${productModel['choiceOptions'][index]['title']} :',
                                      style: titilliumRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE,
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: GridView.builder(
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 6,
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 5,
                                            childAspectRatio: (1 / .7),
                                          ),
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: productModel['choiceOptions'][index]['options'].length,
                                          itemBuilder: (context, i) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(width: .4, color: Colors.grey),
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  productModel['choiceOptions'][index]['options'][i].trim(),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: titilliumRegular.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        : SizedBox(),
                  ],
                );
              },
            ),
          )
        : SizedBox();
  }

  DateTime getDateTime(var dateTime) {
    debugPrint("$TAG date time from auction product ============> $dateTime");
    return DateTime.parse(dateTime);
  }
}
