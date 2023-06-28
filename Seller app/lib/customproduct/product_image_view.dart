// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/provider/restaurant_provider.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';

import '../provider/splash_provider.dart';
import '../provider/theme_provider.dart';
import '../utill/color_resources.dart';
import '../utill/dimensions.dart';
import '../utill/images.dart';

class ProductImageView extends StatelessWidget {
  var images;
  bool isForCustomProduct;

  ProductImageView({@required this.images, this.isForCustomProduct});

  final PageController _controller = PageController();
  ColorResources color = ColorResources();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          child: images != null
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300], spreadRadius: 1, blurRadius: 5)],
                    gradient: Provider.of<ThemeProvider>(context).darkTheme
                        ? null
                        : LinearGradient(
                            colors: [ColorResources.WHITE, ColorResources.IMAGE_BG],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                  ),
                  child: Stack(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width,
                      child: images != null
                          ? PageView.builder(
                              controller: _controller,
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return FadeInImage.assetNetwork(
                                  fit: BoxFit.fill,
                                  placeholder: Images.placeholder_image,
                                  height: MediaQuery.of(context).size.width,
                                  width: MediaQuery.of(context).size.width,
                                  image: isForCustomProduct ? AppConstants.imageBaseUrl + images[index] : '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${images[index]}',
                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                    Images.placeholder_image,
                                    height: MediaQuery.of(context).size.width,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                              onPageChanged: (index) {
                                Provider.of<RestaurantProvider>(context, listen: false).setImageSliderSelectedIndex(index);
                              },
                            )
                          : SizedBox(),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _indicators(context),
                          ),
                          Spacer(),
                          Provider.of<RestaurantProvider>(context).imageSliderIndex != null
                              ? Padding(
                                  padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_DEFAULT, bottom: Dimensions.PADDING_SIZE_DEFAULT),
                                  child: Text('${Provider.of<RestaurantProvider>(context).imageSliderIndex + 1}' + '/' + '${images.length.toString()}'),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    SizedBox.shrink(),
                  ]),
                )
              : SizedBox(),
        ),
      ],
    );
  }

  List<Widget> _indicators(BuildContext context) {
    List<Widget> indicators = [];
    for (int index = 0; index < images.length; index++) {
      indicators.add(TabPageSelectorIndicator(
        backgroundColor: index == Provider.of<RestaurantProvider>(context).imageSliderIndex ? color.colortheme : ColorResources.WHITE,
        borderColor: ColorResources.WHITE,
        size: 10,
      ));
    }
    return indicators;
  }
}
