import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/helper/price_converter.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/bank_info_provider.dart';
import 'package:sixvalley_vendor_app/provider/order_provider.dart';
import 'package:sixvalley_vendor_app/provider/product_provider.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/provider/theme_provider.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/screens/home/widget/order_type_button.dart';
import 'package:sixvalley_vendor_app/view/screens/home/widget/order_type_button_head.dart';
import 'package:sixvalley_vendor_app/view/screens/home/widget/stock_out_product_widget.dart';
import 'package:sixvalley_vendor_app/view/screens/home/widget/transaction_chart.dart';

class HomeScreen extends StatelessWidget {
  final Function callback;
  HomeScreen({@required this.callback});

  Future<void> _loadData(BuildContext context, bool reload) async {
    await Provider.of<BankInfoProvider>(context, listen: false).getUserEarnings(context);
    await Provider.of<BankInfoProvider>(context, listen: false).getUserCommissions(context);
    await Provider.of<ProfileProvider>(context, listen: false).getSellerInfo(context);
    await Provider.of<BankInfoProvider>(context, listen: false).getBankInfo(context);
    await Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
    await Provider.of<SplashProvider>(context, listen: false).getColorList();
    await Provider.of<ProductProvider>(context, listen: false).getStockOutProductList(1, context, 'en');
  }

  ColorResources color = ColorResources();
  @override
  Widget build(BuildContext context) {
    _loadData(context, false);
    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 0,
        title: Row(
          children: [
            SizedBox(width: 10),
            Text(AppConstants.APP_NAME, style: titilliumBold.copyWith(color: Theme.of(context).textTheme.bodyText1.color)),
          ],
        ),
        backgroundColor: ColorResources.getBottomSheetColor(context),
        elevation: 0,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, order, child) {
          return order.orderList != null
              ? SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await _loadData(context, true);
                    },
                    backgroundColor: color.colortheme,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          order.pendingList != null
                              ? Consumer<OrderProvider>(
                                  builder: (context, orderProvider, child) => Padding(
                                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    child: SizedBox(
                                      height: MediaQuery.of(context).size.width - Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GridView.count(
                                          physics: NeverScrollableScrollPhysics(),
                                          crossAxisCount: 2,
                                          shrinkWrap: true,
                                          children: [
                                            OrderTypeButtonHead(
                                              color: Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Theme.of(context).disabledColor : Color(0xFF3E215D),
                                              text: getTranslated('pending', context),
                                              index: 1,
                                              subText: getTranslated('orders', context),
                                              orderList: orderProvider.pendingList,
                                              callback: callback,
                                            ),
                                            OrderTypeButtonHead(
                                              color: Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Theme.of(context).disabledColor : Color(0xFF053742),
                                              text: getTranslated('processing', context),
                                              index: 2,
                                              orderList: orderProvider.processing,
                                              callback: callback,
                                              subText: getTranslated('orders', context),
                                            ),
                                            OrderTypeButtonHead(
                                              color: Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Theme.of(context).disabledColor : Color(0xFF001E6C),
                                              text: getTranslated('confirmed', context),
                                              index: 7,
                                              subText: getTranslated('orders', context),
                                              orderList: orderProvider.confirmedList,
                                              callback: callback,
                                            ),
                                            OrderTypeButtonHead(
                                              color: Provider.of<ThemeProvider>(context, listen: false).darkTheme ? Theme.of(context).disabledColor : Color(0xFF343A40),
                                              text: getTranslated('out_for_delivery', context),
                                              index: 8,
                                              subText: '',
                                              orderList: orderProvider.outForDeliveryList,
                                              callback: callback,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(height: 150, child: Center(child: CircularProgressIndicator(color: color.colortheme, valueColor: AlwaysStoppedAnimation(color.colorWhite)))),
                          order.pendingList != null
                              ? Consumer<OrderProvider>(
                                  builder: (context, orderProvider, child) => Padding(
                                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    child: SizedBox(
                                      height: 130,
                                      child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          OrderTypeButton(
                                            text: getTranslated('delivered', context),
                                            index: 3,
                                            orderList: orderProvider.deliveredList,
                                            callback: callback,
                                            icon: Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.white,
                                            ),
                                          ),
                                          OrderTypeButton(
                                            text: getTranslated('cancelled', context),
                                            index: 6,
                                            orderList: orderProvider.canceledList,
                                            callback: callback,
                                            icon: Icon(
                                              Icons.delete_forever,
                                              color: Colors.white,
                                            ),
                                          ),
                                          OrderTypeButton(
                                            text: getTranslated('return', context),
                                            index: 4,
                                            orderList: orderProvider.returnList,
                                            callback: callback,
                                            icon: Icon(
                                              Icons.replay,
                                              color: Colors.white,
                                            ),
                                          ),
                                          OrderTypeButton(
                                            text: getTranslated('failed', context),
                                            index: 5,
                                            orderList: orderProvider.failedList,
                                            callback: callback,
                                            icon: Icon(
                                              Icons.sms_failed,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(height: 150, child: Center(child: CircularProgressIndicator(color: color.colortheme, valueColor: AlwaysStoppedAnimation(color.colorWhite)))),
                          SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          StockOutProductView(isHome: true),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Consumer<BankInfoProvider>(builder: (context, bankInfo, child) {
                              List<double> _earnings = [];
                              List<double> _commissions = [];
                              for (double earn in bankInfo.userCommissions) {
                                _earnings.add(PriceConverter.convertAmount(earn, context));
                              }
                              for (double commission in bankInfo.userEarnings) {
                                _commissions.add(PriceConverter.convertAmount(commission, context));
                              }
                              List<double> _counts = [];
                              List<double> _comCounts = [];
                              _counts.addAll(_earnings);
                              _comCounts.addAll(_commissions);
                              _counts.sort();
                              _comCounts.sort();
                              double _lim = 0.0;
                              double _max = _counts[_counts.length - 1];
                              double _maxx = _comCounts[_comCounts.length - 1];
                              if (_max > _maxx) {
                                _lim = _max;
                              } else {
                                _lim = _maxx;
                              }
                              return TransactionChart(earnings: _earnings, commissions: _commissions, max: _lim);
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(child: CircularProgressIndicator(color: color.colortheme, valueColor: AlwaysStoppedAnimation(color.colorWhite)));
        },
      ),
    );
  }
}
