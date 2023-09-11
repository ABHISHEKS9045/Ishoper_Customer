// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sixvalley_ecommerce/view/basewidget/rating_bar.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:provider/provider.dart';
//
// import '../../data/model/response/product_model.dart';
// import '../../helper/price_converter.dart';
// import '../../provider/product_provider.dart';
// import '../../provider/splash_provider.dart';
// import '../../utill/color_resources.dart';
// import '../../utill/custom_themes.dart';
// import '../../utill/dimensions.dart';
// import '../../utill/images.dart';
// import '../screen/chat/widget/mycartpage.dart';
// import '../screen/product/product_details_screen.dart';
//
// class productActionwidget extends StatefulWidget {
//   final Product productModel;
//   final index;
//   final  product_id;
//   productActionwidget({ this.auctionModel, this.product_id, this.index});
//
//   @override
//   State<productActionwidget> createState() => _productActionwidgetState();
// }
//
// class _productActionwidgetState extends State<productActionwidget> {
//   @override
//   void initState(){
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       final model = Provider.of<ProductProvider>(context,  listen: false);
//       await model. auctionList();
//
//     });
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return
//       Consumer<ProductProvider>(
//           builder: (context,model, index )
//           {
//             return
//
//               InkWell(
//                 // onTap: () {
//                 //   Navigator.push(
//                 //     context,
//                 //     PageRouteBuilder(
//                 //       transitionDuration: Duration(milliseconds: 1000),
//                 //       pageBuilder: (context, anim1, anim2) =>
//                 //           ProductDetails(product: productModel),
//                 //
//                 //
//                 //     ),
//                 //
//                 //
//                 //   );
//                 // },
//                 child: Container(
//                   height: MediaQuery
//                       .of(context)
//                       .size
//                       .width / 1.5,
//                   margin: EdgeInsets.all(5),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Theme
//                         .of(context)
//                         .highlightColor,
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.grey.withOpacity(0.2),
//                           spreadRadius: 1,
//                           blurRadius: 5)
//                     ],
//                   ),
//                   child: Stack(children: [
//                     Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           // Product Image
//                           Expanded(
//                             child: Container(
//                               height: MediaQuery
//                                   .of(context)
//                                   .size
//                                   .width / 2.50,
//                               decoration: BoxDecoration(
//                                 color: ColorResources.getIconBg(context),
//                                 borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(10),
//                                     topRight: Radius.circular(10)),
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(10),
//                                     topRight: Radius.circular(10)),
//                                 child: FadeInImage.assetNetwork(
//                                   placeholder: Images.placeholder,
//                                   fit: BoxFit.cover,
//                                   height: MediaQuery
//                                       .of(context)
//                                       .size
//                                       .width / 2.45,
//                                   image:
//                                   '${Provider
//                                       .of<SplashProvider>(context, listen: false)
//                                       .baseUrls
//                                       .productThumbnailUrl}/${model.auctionData}',
//                                   imageErrorBuilder: (c, o, s) =>
//                                       Image.asset(
//                                           Images.placeholder_1x1,
//                                           fit: BoxFit.cover,
//                                           height: MediaQuery
//                                               .of(context)
//                                               .size
//                                               .width / 2.45),
//                                 ),
//                               ),
//                             ),
//                           ),
//
//                           // Product Details
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 top: Dimensions.PADDING_SIZE_SMALL,
//                                 bottom: 5,
//                                 left: 5,
//                                 right: 5),
//                             child: Container(
//                               child: Center(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(model.auctionDataList[index]["name"] ?? '',
//                                         textAlign: TextAlign.center,
//                                         style: robotoRegular.copyWith(
//                                             fontSize: Dimensions.FONT_SIZE_SMALL,
//                                             fontWeight: FontWeight.w400),
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis),
//                                     SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                                     Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           RatingBar(
//                                             rating: 2.0,
//                                             size: 18,
//                                           ),
//                                           Text(
//                                               '(${model.auctionDataList[0]["reviewCount"] .toString() ?? 0})',
//                                               style: robotoRegular.copyWith(
//                                                 fontSize: Dimensions.FONT_SIZE_SMALL,
//                                               )),
//                                         ]),
//                                     SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                                     model.auctionDataList[0]["discount"] != null && model.auctionDataList[0]["discount"] > 0
//                                         ? Text(
//                                       PriceConverter.convertPrice(
//                                           context, model.auctionDataList[0]["unitPrice"]),
//                                       style: titleRegular.copyWith(
//                                         color: HexColor('#828282'),
//                                         fontWeight: FontWeight.w400,
//                                         decoration: TextDecoration.lineThrough,
//                                         fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
//                                       ),
//                                     )
//                                         : SizedBox.shrink(),
//                                     SizedBox(
//                                       height: 2,
//                                     ),
//                                     // Text(
//                                     //   PriceConverter.convertPrice(
//                                     //       context, model.auctionDataList[0]["unitPrice"],
//                                     //       discountType: model.auctionDataList[0]["discountType"],
//                                     //       discount: double.parse(model.auctionDataList[0]["discount"])),
//                                     //   style:
//                                     //   titilliumSemiBold.copyWith(color: color.Pricecolor
//                                     //     // ColorResources.getPrimary(context)
//                                     //   ),
//                                     // ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ]),
//
//                     // Off
//
//                     model.auctionDataList[0]["discount"] > 0
//                         ? Positioned(
//                       top: 0,
//                       left: 0,
//                       child: Container(
//                         height: 20,
//                         padding: EdgeInsets.symmetric(
//                             horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                         decoration: BoxDecoration(
//                           color: color.colortheme,
//                           // ColorResources.getPrimary(context),
//                           borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(10),
//                               bottomRight: Radius.circular(10)),
//                         ),
//                         child: Center(
//                           child: Text(
//                             PriceConverter.percentageCalculation(
//                                 context,
//                                 model.auctionDataList[0]["unitPrice"],
//                                 model.auctionDataList[0]["discount"],
//                                 model.auctionDataList[0]["discountType"]),
//                             style: robotoRegular.copyWith(
//                                 color: Theme
//                                     .of(context)
//                                     .highlightColor,
//                                 fontSize: Dimensions.FONT_SIZE_SMALL),
//                           ),
//                         ),
//                       ),
//                     )
//                         : SizedBox.shrink(),
//                   ]),
//                 ),
//               );
//           });
//   }}
