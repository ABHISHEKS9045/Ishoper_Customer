import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/review_model.dart';
import 'package:sixvalley_vendor_app/provider/product_review_provider.dart';
import 'package:sixvalley_vendor_app/view/screens/review/widget/review_widget.dart';
class ProductReview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<ProductReviewProvider>(
        builder: (context, reviewProvider, child) {
          List<ReviewModel> reviewList;
          reviewList = reviewProvider.reviewList;
          return Column(children: [
            reviewProvider.reviewList.isNotEmpty ?
            ListView.builder(
              itemCount: reviewList.length,
              // itemCount: 1,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return
                   ReviewWidget(reviewModel: reviewList[index]);
              },
            ):
            Container(
            alignment: Alignment.center,
              margin: EdgeInsets.only(top: 40),
              child: Text('No data Found!!', style: TextStyle(fontSize: 20, color: Colors.orange)),
            ),


          ]);
        },
      ),
    );
  }
}
