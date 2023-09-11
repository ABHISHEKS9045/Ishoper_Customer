import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixvalley_vendor_app/data/model/response/add_product_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/category_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/edt_product_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/product_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/restaurant_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/base/custom_snackbar.dart';
import 'package:sixvalley_vendor_app/view/base/textfeild/custom_text_feild.dart';
import 'package:sixvalley_vendor_app/view/screens/addProduct/widget/add_product_next_Screen.dart';

class AddProductScreen extends StatefulWidget {
  final Product product;
  final CategoryModel category;
  final AddProductModel addProduct;
  final EditProduct editProduct;
  final String productType;

  AddProductScreen({this.product, this.category, this.addProduct, this.editProduct, this.productType});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  ColorResources color = ColorResources();

  var selectedType = '';
  final List<String> productType = [
    'Product',
    'Auction Product',
  ];
  String selectedValue;

  saveProductType(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('productType', value);
    print(prefs.get('productType'));
  }

  @override
  void initState() {
    print('ProductTypeeeeeeee =======>${widget.productType}');

    Provider.of<SplashProvider>(context, listen: false).configModel.languageList.length;
    if (widget.product != null) {
      Provider.of<RestaurantProvider>(context, listen: false).getEditProduct(context, widget.product.id);
    } else {
      Provider.of<RestaurantProvider>(context, listen: false).getTitleAndDescriptionList(Provider.of<SplashProvider>(context, listen: false).configModel.languageList, null);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.product != null ? getTranslated('update_product', context) : getTranslated('add_product', context),
      ),
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<RestaurantProvider>(
              builder: (context, resProvider, child) {
                return widget.product != null && resProvider.editProduct == null
                    ? Center(
                        child: CircularProgressIndicator(
                          color: color.colortheme,
                          valueColor: AlwaysStoppedAnimation<Color>(color.colorWhite),
                        ),
                      )
                    : Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 8, left: 15, right: 15),
                            color: color.colorWhite,
                            height: 40,
                            width: MediaQuery.of(context).size.width,
                            child: DropdownButtonFormField2(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              isExpanded: true,
                              hint: const Text(
                                'Select Your Product Type',
                                style: TextStyle(fontSize: 15),
                              ),
                              items: productType
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please Select Your Product Type.';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                selectedValue = value.toString();
                                selectedType = selectedValue;
                                print(selectedType);
                                saveProductType(selectedValue);

                                //Do something when changing the item if you want.
                              },
                              onSaved: (value) {},
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.only(left: 0, right: 0),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black45,
                                ),
                                iconSize: 30,
                              ),
                              dropdownStyleData: DropdownStyleData(),
                            ),
                          ),
                          SizedBox(height: 10.0
                            ,),
                          Expanded(
                            child: ListView.builder(
                              itemCount: Provider.of<SplashProvider>(context, listen: false).configModel.languageList.length,
                              itemBuilder: (ctx, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //english
                                      Text(Provider.of<SplashProvider>(context, listen: false).configModel.languageList[index].name ?? "default description", style: robotoRegular.copyWith(fontWeight: FontWeight.w500)),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Text(
                                        getTranslated('product_name', context),
                                        style: robotoRegular.copyWith(color: Color(0xFF9D9D9D), fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextField(
                                        controller: resProvider.titleControllerList[index],
                                        textInputType: TextInputType.name,
                                        hintText: getTranslated('product_title', context),
                                      ),
                                      SizedBox(
                                        height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                                      ),
                                      Text(
                                        getTranslated('product_description', context),
                                        style: robotoRegular.copyWith(color: Color(0xFF9D9D9D), fontWeight: FontWeight.w400, fontSize: Dimensions.FONT_SIZE_SMALL),
                                      ),
                                      SizedBox(
                                        height: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                                      ),
                                      CustomTextField(
                                        controller: resProvider.descriptionControllerList[index],
                                        // focusNode: Provider.of<RestaurantProvider>(context,listen: false).titleNode[index],
                                        textInputType: TextInputType.multiline,
                                        maxLine: 3,
                                        hintText: getTranslated('meta_description_hint', context),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              List<String> titleList = [];
                              List<String> descriptionList = [];
                              Provider.of<RestaurantProvider>(context, listen: false).titleControllerList.forEach((title) {
                                titleList.add(title.text.trim());
                              });
                              Provider.of<RestaurantProvider>(context, listen: false).descriptionControllerList.forEach((description) {
                                descriptionList.add(description.text.trim());
                              });
                              bool _haveBlankTitle = false;
                              bool _haveBlankDes = false;
                              for (String title in titleList) {
                                if (title.isEmpty) {
                                  _haveBlankTitle = true;
                                  break;
                                }
                              }
                              for (String des in descriptionList) {
                                if (des.isEmpty) {
                                  _haveBlankDes = true;
                                  break;
                                }
                              }

                              if (_haveBlankTitle) {
                                showCustomSnackBar(getTranslated('please_input_all_title', context), context);
                              } else if (_haveBlankDes) {
                                showCustomSnackBar(getTranslated('please_input_all_des', context), context);
                              } else if (selectedType == null || selectedType == "") {
                                showCustomSnackBar(getTranslated('Select Your Product Type', context), context);
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => AddProductNextScreen(productType: selectedType, title: titleList, description: descriptionList, product: widget.product, addProduct: widget.addProduct)));
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: BoxDecoration(color: color.colortheme, borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                  child: Text(
                                'Continue',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: Dimensions.FONT_SIZE_LARGE),
                              )),
                            ),
                          )
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
