import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../localization/language_constrants.dart';
import '../../../provider/product_details_provider.dart';
import '../../../provider/theme_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/styles.dart';

class ViewAuctionDetails extends StatefulWidget {
  final String specification;
  final productId;
  ViewAuctionDetails({@required this.specification, this.productId});

  @override
  State<ViewAuctionDetails> createState() => _ViewAuctionDetailsState();
}

class _ViewAuctionDetailsState extends State<ViewAuctionDetails> {
  @override
  void initState() {
    final actionDetails =
        Provider.of<ProductDetailsProvider>(context, listen: false);
    actionDetails.getAuctionproduct(widget.productId);
    super.initState();
  }

  ColorResources color = ColorResources();
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_ios),
      //     color: Theme.of(context).textTheme.bodyText1.color,
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: Text('Auction Details', style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Theme.of(context).textTheme.bodyText1.color)),
      //   centerTitle: true,
      //
      //   backgroundColor:  Colors.orange,
      //   elevation: 0,
      // ),
      appBar: AppBar(
        title: Row(children: [
          InkWell(
            child: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).cardColor, size: 20),
            onTap: () => Navigator.pop(context),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Text(getTranslated('Auction_details', context),
              style: robotoRegular.copyWith(
                  fontSize: 20,
                  color: Theme.of(context).cardColor)),
        ]),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
            ? Colors.black
            : color.colortheme,
      ),
      body: Consumer<ProductDetailsProvider>(builder: (context, details, _) {
        return Padding(
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: details.auctionProductData.length,
            itemBuilder: (context, index) {
              var data = details.auctionProductData[index];
              var bidList = <Map<String, dynamic>>[];

              data['bids'].forEach((number) {
                bidList.add({
                  'customer_name': number['customer_name'],
                  'bid_amount': number['bid_amount'],
                  'date': number['date'],
                  'status': number['is_winner'] == 1 ? "Winner" : "Participant",
                });
              });

              return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        setState(() {
                          details.isShowList[index] =
                              !details.isShowList[index];
                        });
                      },
                      subtitle: Row(
                        children: [
                          Text("${data['auction_start']} - "),
                          Text("${data['auction_end']}"),
                        ],
                      ),
                      title: Text(
                          "Max bid: ${data['bids'][0]["bid_amount"]} SAR"), // Display the max bid from the first bid
                      trailing: Icon(details.isShowList[index]
                          ? Icons.arrow_drop_up_outlined
                          : Icons.arrow_drop_down_outlined),
                    ),
                    if (details.isShowList[index])
                      Container(
                        margin: EdgeInsets.only(left: 16),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            for (var bid in bidList)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildRichText(bid, "Customer Name: ",
                                      bid['customer_name'].toString()),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  buildRichText(bid, "Bid Amount: ",
                                      "${bid['bid_amount']} SAR".toString()),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  buildRichText(
                                      bid, "Date: ", bid['date'].toString()),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  buildRichText(bid, "Status: ", bid['status'].toString()),
                                  Divider(
                                    color: Colors.grey,
                                    thickness: 1.0,
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  RichText buildRichText(
      Map<String, dynamic> bid, String leading, String name ) {
    Color status = name == "Winner" ? Colors.green :  name == "Participant" ?  Colors.red:Color(0xFFFFAA47);
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
              text: leading,
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
          TextSpan(
            text: name,
            style: TextStyle(fontWeight: FontWeight.w500, color: status ),
          ),
        ],
      ),
    );
  }
}
