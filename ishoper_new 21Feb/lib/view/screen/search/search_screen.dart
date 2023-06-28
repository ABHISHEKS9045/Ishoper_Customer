import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/search_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/search_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/search/widget/search_product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SearchScreen extends StatelessWidget {
  ColorResources color = ColorResources();
  @override
  Widget build(BuildContext context) {
    Provider.of<SearchProvider>(context, listen: false).cleanSearchProduct();
    Provider.of<SearchProvider>(context, listen: false).initHistoryList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorResources.getIconBg(context),
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding:
                        EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT),
                        child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(Icons.arrow_back_ios)),
                      ),
                      Expanded(
                        child: Container(
                          child: SearchWidget(
                            hintText: getTranslated('SEARCH_HINT', context),
                            onSubmit: (String text) {
                              Provider.of<SearchProvider>(context, listen: false)
                                  .searchProduct(text, context);
                              Provider.of<SearchProvider>(context, listen: false)
                                  .saveSearchAddress(text);
                            },
                            onClearPressed: () =>
                                Provider.of<SearchProvider>(context, listen: false)
                                    .cleanSearchProduct(),
                            // onTextChanged: (String text) => Provider.of<SearchProvider>(context, listen: false)
                            //     .searchHintProduct(text, context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Consumer<SearchProvider>(
                    builder: (context, searchProvider, child) {
                      return searchProvider.searchHintList!=null && searchProvider.searchHintList.length > 0
                          ? Container(
                            height: (searchProvider.searchHintList.length*6).h,
                            padding: EdgeInsets.only(left: 13.w,right: 5.w),
                            child: ListView.builder(
                                itemCount: searchProvider.searchHintList.length,
                                itemBuilder: (context, index) => InkWell(
                                  onTap: (){
                                    Provider.of<SearchProvider>(context, listen: false)
                                        .searchProduct(searchProvider.searchHintList[index], context);
                                    Provider.of<SearchProvider>(context, listen: false)
                                        .saveSearchAddress(searchProvider.searchHintList[index]);
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                        child: Text(searchProvider.searchHintList[index]),
                                      ),
                                      Divider(height: 0.1.h,)
                                    ],
                                  ),
                                )
                            ),
                          )
                          : Container();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Dimensions.PADDING_SIZE_DEFAULT,
            ),
            Consumer<SearchProvider>(
              builder: (context, searchProvider, child) {
                return !searchProvider.isClear
                    ? searchProvider.searchProductList != null
                        ? searchProvider.searchProductList.length > 0
                            ? Expanded(
                                child: SearchProductWidget(
                                    products: searchProvider.searchProductList,
                                    isViewScrollable: true))
                            : Expanded(
                                child:
                                    NoInternetOrDataScreen(isNoInternet: false))
                        : Expanded(
                            child: ProductShimmer(
                                isHomePage: false,
                                isEnabled: Provider.of<SearchProvider>(context)
                                        .searchProductList ==
                                    null))
                    : Expanded(
                        flex: 4,
                        child: Container(
                          // color: Colors.red,
                          // padding:
                          //     EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                          padding: EdgeInsets.only(top: 7,),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Consumer<SearchProvider>(
                                builder: (context, searchProvider, child) =>
                                    StaggeredGridView.countBuilder(
                                  crossAxisCount: 2,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: searchProvider.historyList.length,
                                  itemBuilder: (context, index) => Container(
                                      alignment: Alignment.center,
                                      child: InkWell(
                                        onTap: () =>
                                            Provider.of<SearchProvider>(context,
                                                    listen: false)
                                                .searchProduct(
                                                    searchProvider
                                                        .historyList[index],
                                                    context),
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),

                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: ColorResources.getGrey(
                                                  context)
                                          // color: Colors.red
                                          ),
                                          width: double.infinity,
                                          child: Center(
                                            child: Text(
                                              Provider.of<SearchProvider>(
                                                          context,
                                                          listen: false)
                                                      .historyList[index] ??
                                                  "",
                                              style: titilliumItalic.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_DEFAULT,
                                                  color: color.colortheme),
                                            ),
                                          ),
                                        ),
                                      )),
                                  staggeredTileBuilder: (int index) =>
                                      new StaggeredTile.fit(1),
                                  mainAxisSpacing: 0.1,
                                  crossAxisSpacing: 4.0,
                                ),
                              ),
                              Positioned(
                                top: -34,
                                left: 0,
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(

                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            getTranslated(
                                                'SEARCH_HISTORY', context),
                                            style: robotoBold),
                                        // TextButton(onPressed: (){
                                        //   print("object");
                                        // }, child: Text('Remove'))



                                MaterialButton(
                                    onPressed: (){
                                      Provider.of<SearchProvider>(
                                          context,
                                          listen: false)
                                          .clearSearchAddress();
                                      print('object');

                                    },

                                    child: Container(
                                      child: Text(
                                        getTranslated(
                                            'REMOVE', context),
                                        style: titilliumRegular
                                            .copyWith(
                                            fontSize: 15,
                                            color:
                                            color.colortheme),
                                      ),
                                    ),
                                )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
