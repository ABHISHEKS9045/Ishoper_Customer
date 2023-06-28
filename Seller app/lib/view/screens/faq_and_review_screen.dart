import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/view/screens/review/widget/review_widget.dart';

import '../../data/model/response/review_model.dart';
import '../../localization/language_constrants.dart';
import '../../utill/dimensions.dart';
import '../../utill/styles.dart';
import '../base/custom_app_bar.dart';

class ReviewScreen extends StatelessWidget {
  final List<ReviewModel> reviewList;
  ReviewScreen({this.reviewList});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        CustomAppBar(title: getTranslated('reviews', context)),

        Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Text(getTranslated('reviews', context)+'(${reviewList.length})', style: robotoBold),
        ),

        Expanded(child: ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          itemCount: reviewList.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              color: Theme.of(context).highlightColor,
              child: ReviewWidget(reviewModel: reviewList[index]),
            );
          },
        )),

      ]),
    );
  }
}
