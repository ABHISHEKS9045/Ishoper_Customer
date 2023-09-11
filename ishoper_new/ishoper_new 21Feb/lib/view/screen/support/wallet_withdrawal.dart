import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/support_ticket_body.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/support_ticket_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_expanded_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/support/walletTicketModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../provider/wallet_transaction_provider.dart';

class WalletWithdrawalScreen extends StatefulWidget {
  final String type;

  WalletWithdrawalScreen({
    @required this.type,
  });

  @override
  _WalletWithdrawalScreenState createState() => _WalletWithdrawalScreenState();
}

class _WalletWithdrawalScreenState extends State<WalletWithdrawalScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _walletController = TextEditingController();
  final FocusNode _subjectNode = FocusNode();
  final FocusNode _descriptionNode = FocusNode();
  final FocusNode _walletNode = FocusNode();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  var walletAmount = 0;
  String token;

  @override
  Future<void> initState()  {
    var amount =
        Provider.of<WalletTransactionProvider>(context, listen: false).amount;
        Provider.of<WalletTransactionProvider>(context, listen: false).token;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    // token = jsonDecode(prefs.getString("token")).toString();
    // print("hgkjhglkshglsjg$token");

    walletAmount = amount.toInt();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomExpandedAppBar(
      title: getTranslated('support_ticket', context),
      isGuestCheck: true,
      child: Consumer<WalletTransactionProvider>(builder: (context, model, _) {
        return ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            children: [
              Text(getTranslated('add_new_ticket', context),
                  style: titilliumSemiBold.copyWith(fontSize: 20)),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
              Container(
                color: ColorResources.getLowGreen(context),
                margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_LARGE),
                child: ListTile(
                  leading: Icon(Icons.query_builder,
                      color: ColorResources.getPrimary(context)),
                  title: Text("Wallet withdrawal", style: robotoBold),
                  onTap: () {},
                ),
              ),
              CustomTextField(
                focusNode: _subjectNode,
                nextNode: _walletNode,
                textInputAction: TextInputAction.next,
                hintText: getTranslated('write_your_subject', context),
                controller: _subjectController,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Consumer<WalletTransactionProvider>(
                          builder: (context, profile, _) {
                        return Row(
                          children: [
                            Text(
                              getTranslated('wallet_amount', context),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              ),
                            ),
                            SizedBox(
                              width: Dimensions.PADDING_SIZE_SMALL,
                            ),
                            Text(
                              "${profile.amount.toStringAsFixed(2)}",
                              style: TextStyle(
                                //fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    CustomTextField(
                      focusNode: _walletNode,
                      nextNode: _descriptionNode,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.numberWithOptions(),
                      hintText:
                          getTranslated('write_wallet_withdrawal', context),
                      //hintText: "Wallet Withdrawal",
                      controller: _walletController,
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              CustomTextField(
                focusNode: _descriptionNode,
                textInputAction: TextInputAction.newline,
                hintText: getTranslated('issue_description', context),
                textInputType: TextInputType.multiline,
                controller: _descriptionController,
                maxLine: 5,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
              Provider.of<SupportTicketProvider>(context).isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)))
                  : Builder(
                      key: _scaffoldKey,
                      builder: (context) => CustomButton(
                          buttonText: getTranslated('submit', context),
                          onTap: () {
                            print("Walletamount${_walletController.text}");
                            if (_subjectController.text.isEmpty) {
                              showCustomSnackBar(
                                  'Subject box should not be empty', context);
                            } else if (_descriptionController.text.isEmpty) {
                              showCustomSnackBar(
                                  'Description box should not be empty',
                                  context);
                            } else if (_walletController.text.isEmpty) {
                              showCustomSnackBar(
                                  'Wallet Withdrawal box should not be empty',
                                  context);
                            } else if (int.parse(_walletController.text) >
                                walletAmount) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('fail_wallet_withdrawal', context)), backgroundColor: Colors.red));
                            } else {
                              model.walletwithdeawalticket(
                                  context,
                                  widget.type,
                                  _subjectController.text,
                                  _descriptionController.text,
                                  _walletController.text.toString()

                                   );
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('successful_wallet_withdrawal', context)), backgroundColor: Colors.green));
                            }
                          }),
                    ),
            ]);
      }),
    );
  }

  void callback(bool isSuccess, String message) {
    print(message);
    if (isSuccess) {
      _subjectController.text = '';
      _descriptionController.text = '';
      _walletController.text = '';
      Navigator.of(context).pop();
    } else {}
  }
}
