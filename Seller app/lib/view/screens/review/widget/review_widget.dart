import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/data/model/response/review_model.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

import '../../../../provider/product_details_provider.dart';
import '../../../../utill/color_resources.dart';
import '../../addProduct/widget/rating_bar.dart';
class ReviewWidget extends StatelessWidget {
  final ReviewModel reviewModel;
  ReviewWidget({@required this.reviewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
      child: Stack(
        children: [
          Card(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      width: 70,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: CachedNetworkImage(
                              placeholder: (ctx, url) => Image.asset(Images.placeholder_image,),
                              errorWidget: (ctx,url,err) => Image.asset(Images.placeholder_image,),
                              imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${reviewModel.product.thumbnail}',)
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(reviewModel.product.name ?? '', style: robotoRegular, maxLines: 3, overflow: TextOverflow.ellipsis),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                            Row(children: [
                              for(int i = 0; i<reviewModel.rating; i++)
                                Icon(Icons.star, color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.orange, size: 15),


                                 ]),
                            Text(reviewModel.comment ?? '', style: robotoHintRegular, maxLines: 3, overflow: TextOverflow.ellipsis,),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),


                          ],),
                      ),
                    )

                  ],),
              ),

            ],),
          ),

         ],
      ),
    );

  }
}
class ReviewShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: Provider.of<ProductDetailsProvider>(context).reviewList == null,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Row(children: [
          CircleAvatar(
            maxRadius: 15,
            backgroundColor: ColorResources.SELLER_TXT,
            child: Icon(Icons.person),
          ),
          SizedBox(width: 5),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(height: 10, width: 50, color: ColorResources.WHITE),
              SizedBox(width: 5),
              RatingBar(rating: 0, size: 12),
            ]),
            Container(height: 10, width: 50, color: ColorResources.WHITE),
          ]),
        ]),
        SizedBox(height: 5),
        Container(height: 20, width: 200, color: ColorResources.WHITE),
      ]),
    );
  }
}
