import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wallet_transaction_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/not_loggedin_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../provider/profile_provider.dart';
import '../../../utill/custom_themes.dart';
import '../dashboard/dashboard_screen.dart';
import 'TamaraPaymentScreen.dart';


class WalletScreen extends StatefulWidget {
  final bool isBacButtonExist;
  final bool isFromPaymentPage;

  WalletScreen({this.isBacButtonExist = true,  this.isFromPaymentPage = false});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  // final hyperSDK = HyperSDK();
  final TextEditingController amountController = TextEditingController();

  ColorResources color = ColorResources();

  var customerId;

 BackButtonPage(){
   widget.isFromPaymentPage ?
   Navigator.push(
     context,
     MaterialPageRoute(builder: (context) => DashBoardScreen()),
   ) : Navigator.pop(context);
 }

  Future<void> getData(BuildContext context) async {
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    await profile.getUserInfo(context);
    customerId = profile.customerId;
    Provider.of<WalletTransactionProvider>(context, listen: false).getWalletAmount(customerId);
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<ThemeProvider>(context, listen: false).darkTheme;
    bool isFirstTime = true;
    bool isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (isFirstTime) {
      if (!isGuestMode) {
        getData(context);
      }
      isFirstTime = false;
    }
    return WillPopScope(
     onWillPop: (){
       return BackButtonPage();
     },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Provider.of<ThemeProvider>(context).darkTheme ? Colors.black : Colors.white,
          title: Text(
            getTranslated('wallet', context),
            textAlign: TextAlign.center,
            style: titilliumRegular.copyWith(
              fontSize: 20,
              color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: IconButton(
            onPressed: () {
              widget.isFromPaymentPage ?
              Navigator.push(
                context,
                 MaterialPageRoute(builder: (context) => DashBoardScreen()),
              ) : Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.black,

            ),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.add_circle_outlined,
                  color: Color(0xFFFE8551),
                  size: 28,
                ),
              onPressed: () async {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TamaraPaymentScreen(customerId = customerId)),
                );

              },
            ),
          ],
        ),
        backgroundColor: ColorResources.getIconBg(context),
        body:
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: isGuestMode
              ? NotLoggedInWidget()
              : Container(
                  child: Consumer<WalletTransactionProvider>(builder: (context, profile, _) {
                    return ModalProgressHUD(
                        inAsyncCall: profile.is_loding,
                        opacity: 0.7,
                        progressIndicator: CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                        child:
                      Column(
                      children: [
                        SizedBox(
                          height: Dimensions.PADDING_SIZE_LARGE,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width / 2.5,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                          margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            color: color.colortheme,
                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                            boxShadow: [BoxShadow(color: Colors.grey[darkMode ? 900 : 200], spreadRadius: 0.5, blurRadius: 0.3)],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: Dimensions.LOGO_HEIGHT,
                                    height: Dimensions.LOGO_HEIGHT,
                                    child: Image.asset(
                                      Images.wallet,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        getTranslated('wallet_amount', context),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                        ),
                                      ),
                                      SizedBox(
                                        height: Dimensions.PADDING_SIZE_SMALL,
                                      ),
                                      Text(
                                        "${profile.amount.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: Dimensions.LOGO_HEIGHT,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.PADDING_SIZE_LARGE,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: Dimensions.HOME_PAGE_PADDING, right: Dimensions.HOME_PAGE_PADDING),
                          child: Text(
                            '${getTranslated('transaction_history', context)}',
                            style: robotoBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.PADDING_SIZE_LARGE,
                        ),
                        if (profile.walletList != null && profile.walletList.isNotEmpty)
                          Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: profile.walletList.length,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) {
                                return Divider(
                                  thickness: .4,
                                  color: Theme.of(context).hintColor.withOpacity(.8),
                                );
                              },
                              itemBuilder: (ctx, index) {
                                var data = profile.walletList[index];
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.HOME_PAGE_PADDING, vertical: Dimensions.PADDING_SIZE_SMALL),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data["transaction_amount"],
                                                  style: robotoRegular.copyWith(color: ColorResources.getTextTitle(context), fontSize: Dimensions.FONT_SIZE_LARGE),
                                                ),
                                                SizedBox(
                                                  height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                                ),
                                                Text(
                                                  data["transaction_type"],
                                                  style: robotoRegular.copyWith(color: ColorResources.getHint(context)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                DateConverter.localDateToIsoStringAMPM(
                                                  DateTime.parse(data["created_at"]),
                                                ),
                                                style: robotoRegular.copyWith(color: ColorResources.getHint(context)),
                                              ),
                                              SizedBox(
                                                height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                              ),
                                              Text(
                                                '${data["transaction_method"] != null ? data["transaction_method"].toString() : ""}',
                                                style: robotoRegular.copyWith(color: ColorResources.getHint(context)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ));
                  }),
                ),
        ),
      ),
    );
  }
}

class OrderShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: Dimensions.MARGIN_SIZE_DEFAULT),
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          color: Theme.of(context).highlightColor,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 10, width: 150, color: ColorResources.WHITE),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: Container(height: 45, color: Colors.white)),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Container(height: 20, color: ColorResources.WHITE),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(height: 10, width: 70, color: Colors.white),
                              SizedBox(width: 10),
                              Container(height: 10, width: 20, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
