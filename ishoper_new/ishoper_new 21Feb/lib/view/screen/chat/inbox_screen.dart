// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/chat_info_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/chat_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/chat_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class InboxScreen extends StatefulWidget {
  final bool isBackButtonExist;

  InboxScreen({this.isBackButtonExist = true});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  ColorResources color = ColorResources();
  bool isGuestMode = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAPI();
  }

  loadAPI() async {
    isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    if (!isGuestMode) await Provider.of<ChatProvider>(context, listen: false).initChatInfo(context);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Column(
        children: [
          // AppBar
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                child: Image.asset(
                  Images.toolbar_background,
                  fit: BoxFit.fill,
                  height: 100,
                  width: double.infinity,
                  color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : color.colortheme,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                height: 90 - MediaQuery.of(context).padding.top,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    widget.isBackButtonExist
                        ? IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: ColorResources.WHITE,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        : SizedBox.shrink(),
                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Expanded(
                      child: Provider.of<ChatProvider>(context).isSearching
                          ? TextField(
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                border: InputBorder.none,
                                hintStyle: titilliumRegular.copyWith(
                                  color: ColorResources.GAINS_BORO,
                                ),
                              ),
                              style: titilliumSemiBold.copyWith(
                                color: ColorResources.WHITE,
                                fontSize: Dimensions.FONT_SIZE_LARGE,
                              ),
                              onChanged: (String query) {
                                Provider.of<ChatProvider>(context, listen: false).filterList(query);
                              },
                            )
                          : Text(
                              getTranslated('inbox', context),
                              style: titilliumRegular.copyWith(
                                fontSize: 20,
                                color: ColorResources.WHITE,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                    IconButton(
                      icon: Icon(
                        Provider.of<ChatProvider>(context).isSearching ? Icons.close : Icons.search,
                        size: Dimensions.ICON_SIZE_LARGE,
                        color: ColorResources.WHITE,
                      ),
                      onPressed: () => Provider.of<ChatProvider>(context, listen: false).toggleSearch(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          isLoading
              ? Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: isGuestMode
                      ? NotLoggedInWidget()
                      : RefreshIndicator(
                          backgroundColor: color.colortheme,
                          onRefresh: () async {
                            await Provider.of<ChatProvider>(context, listen: false).initChatInfo(context);
                          },
                          child: Consumer<ChatProvider>(
                            builder: (context, chat, child) {
                              return chat.chatInfoModel != null
                                  ? chat.uniqueShopList.length != 0
                                      ? ListView.builder(
                                          itemCount: chat.uniqueShopList.length,
                                          padding: EdgeInsets.all(0),
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                ListTile(
                                                    leading: ClipOval(
                                                      child: Container(
                                                        color: Theme.of(context).highlightColor,
                                                        child: FadeInImage.assetNetwork(
                                                          placeholder: Images.placeholder,
                                                          fit: BoxFit.cover,
                                                          height: 50,
                                                          width: 50,
                                                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.sellerImageUrl}'
                                                              '/${chat.uniqueShopList[index].sellerInfo != null ? chat.uniqueShopList[index].sellerInfo.image : ''}',
                                                          imageErrorBuilder: (c, o, s) => Image.asset(
                                                            Images.placeholder,
                                                            fit: BoxFit.cover,
                                                            height: 50,
                                                            width: 50,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    title: Text(
                                                      chat.uniqueShopList[index].sellerInfo != null ? shopName(chat.uniqueShopList[index].shop) : '',
                                                      style: titilliumSemiBold,
                                                    ),
                                                    subtitle: Container(
                                                      child: Text(
                                                        chat.uniqueShopList[index].message,
                                                        maxLines: 4,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: titilliumRegular.copyWith(
                                                          fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                                        ),
                                                      ),
                                                    ),
                                                    trailing: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          DateConverter.localDateToIsoStringAMPM(DateTime.parse(chat.uniqueShopList[index].createdAt)),
                                                          style: titilliumRegular.copyWith(
                                                            fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      if (chat.uniqueShopList[index].shop != null) {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) {
                                                              return ChatScreen(seller: null, shopId: chat.uniqueShopList[index].shopId, shopName: chat.uniqueShopList[index].shop.name, image: chat.uniqueShopList[index].sellerInfo.image);
                                                            },
                                                          ),
                                                        );
                                                      } else {
                                                        Fluttertoast.showToast(msg: 'Shop is not exist');
                                                      }
                                                    }),
                                                Divider(
                                                  height: 2,
                                                  color: ColorResources.CHAT_ICON_COLOR,
                                                ),
                                              ],
                                            );
                                          },
                                        )
                                      : NoInternetOrDataScreen(isNoInternet: false)
                                  : InboxShimmer();
                            },
                          ),
                        ),
                ),
        ],
      ),
    );
  }

  String shopName(Shop shop) {
    if (shop != null) {
      if (shop.name != null && shop.name.toString() != "null" && shop.name.toString() != "") {
        return shop.name;
      } else {
        return "";
      }
    } else {
      return "";
    }
  }
}

class InboxShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          enabled: Provider.of<ChatProvider>(context).uniqueShopList == null,
          child: Padding(
            padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
            child: Row(
              children: [
                CircleAvatar(child: Icon(Icons.person), radius: 30),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                    child: Column(
                      children: [
                        Container(height: 15, color: ColorResources.WHITE),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Container(height: 15, color: ColorResources.WHITE),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 10, width: 30, color: ColorResources.WHITE),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    Container(
                      height: 15,
                      width: 15,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
