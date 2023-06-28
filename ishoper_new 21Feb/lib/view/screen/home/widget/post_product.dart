import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/CategoryProductModel.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/ColorProductModel.dart';
import 'package:flutter_sixvalley_ecommerce/provider/ServiceProduct.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/buttonfile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../../data/model/AddProductModel.dart';
import '../../../../data/model/ViewProductSizeModel.dart';
import '../../../../data/model/getSizeAndMatrial.dart';
import '../../../../http_request_helper.dart';

class PostProductPage extends StatefulWidget {
  PostProductPage({Key key}) : super(key: key);

  @override
  State<PostProductPage> createState() => _PostProductPageState();
}

class _PostProductPageState extends State<PostProductPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    colorproductApi();
    categoryproductApi();

  }

  // TextEditingController productName = TextEditingController();
  TextEditingController productDes = TextEditingController();
  TextEditingController productName = TextEditingController();
  TextEditingController productSize = TextEditingController();
  TextEditingController productMaterial = TextEditingController();
  // TextEditingController sizeText = TextEditingController();

  bool isLoading = false;

  AddProductModel addProductModel;
  ColorProductModel _colorProductModel;
  CategoryProductModel _categoryProductModel;
  CategoryProductModel _subCategoryProductModel;
  ViewProductSizeModel viewProductSizeModel;
  GetSizeAndMaterialModel getSizeAndMaterialModel;
  SharedPreferences pref;

  void addproductApi() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });


     addProductModel = await ServiceProduct.uploadFileAddProduct(
        productDes.text,
        colorCode,
        1,
        selectedCategoryId.toString(),
        selectedSubCategoryId.toString(),
        imagefileList,
        _image1,
        pref.getString(AppConstants.TOKEN).toString(),
        productSize.text,
      productName.text,
    );

    if (addProductModel.status == 200) {
      Fluttertoast.showToast(
          msg: addProductModel.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: addProductModel.message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR);
    }
    setState(() {
      isLoading = true;
    });
  }

  void colorproductApi() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });

    _colorProductModel = await ServiceProduct()
        .colorProduct(pref.getString(AppConstants.TOKEN).toString());

    if (_colorProductModel.status == 200) {
      for (int i = 0; i < _colorProductModel.dataColor.length; i++) {
        colorList.add(_colorProductModel.dataColor[i].name.toString());
      }
      print("Susseccessfully");
    } else {
      print("errorr color product");
    }

    setState(() {
      isLoading = true;
    });
  }


  void categoryproductApi() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });

    _categoryProductModel = await ServiceProduct()
        .categoryProduct(pref.getString(AppConstants.TOKEN).toString());

    if (_categoryProductModel.status == 200) {
      for (int i = 0; i < _categoryProductModel.data.length; i++) {
        categoryList.add(_categoryProductModel.data[i].name);
        categoryListId.add(_categoryProductModel.data[i].id);

        print(_categoryProductModel.data[i].name);
      }
      print("test");
    } else {
      print("errorr color product");
    }

    setState(() {
      isLoading = true;
    });
  }

  void subCategoryproductApi(subCat) async {
    subCategoryList = [];
    subCategoryListId = [];
    subClickPosition = -1;
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });

    _subCategoryProductModel = await ServiceProduct()
        .subCategoryProduct(pref.getString(AppConstants.TOKEN).toString(),subCat);

    if (_subCategoryProductModel.status == 200) {
      for (int i = 0; i < _subCategoryProductModel.data.length; i++) {
        subCategoryList.add(_subCategoryProductModel.data[i].name);
        subCategoryListId.add(_subCategoryProductModel.data[i].id);

        print(_subCategoryProductModel.data[i].name);
      }
      print("test");
    } else {
      print("errorr color product");
    }

    setState(() {
      isLoading = true;
    });
  }

  void sizeProductApi(String getCategoryId) async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
    });

    viewProductSizeModel = await ServiceProduct().viewProductSize(
        pref.getString(AppConstants.TOKEN).toString(), getCategoryId);

    if (viewProductSizeModel.status == 200) {
      for (int i = 0; i < viewProductSizeModel.data.length; i++) {
        sizeList.add(viewProductSizeModel.data[i].name);
        sizeListId.add(viewProductSizeModel.data[i].id);
      }
      print("Susseccessfully");
    } else {
      print("errorr size product");
    }

    setState(() {
      isLoading = true;
    });
  }
  List aSize = [];


  // void getSizeAndMaterial(String getCategoryId)async{
  //   pref = await SharedPreferences.getInstance();
  //   setState(() {
  //     isLoading = false;
  //   });
  //
  //   getSizeAndMaterialModel = await ServiceProduct.getSizeAndMaterial(
  //       pref.getString(AppConstants.TOKEN).toString(), getCategoryId
  //   );
  //
  // }



  int addColor = 0;

  List categoryList = [];
  List subCategoryList = [];
  List<String> colorList = [];
  String setStringColor = "";
  List categoryListId = [];
  List subCategoryListId = [];
  int selectedCategoryId = 0;
  int selectedSubCategoryId = 0;
  String colorCode = "";
  String categoryId = "";
  String subCategoryId = "";
  int clickPosition = -1;
  int subClickPosition = -1;
  String dropdownvalue = 'Select color';
  String dropdownvalueSize = 'Select size';
  List<String> sizeList = [];
  List sizeListId = [];

  XFile _image;
  XFile _image1;

  final ImagePicker _picker = ImagePicker();

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: color.colortheme),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: color.colortheme,
                  ),
                  ListTile(
                    onTap: () {
                      selectImage();
                      // pickMultipleImage(ImageSource.gallery);
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.account_box,
                      color: color.colortheme,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: color.colortheme,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera,
                      color: color.colortheme,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


 List<XFile> imagefileList = [];

  ImagePicker _imagepick = ImagePicker();
  void selectImage()async{
    List<XFile> selectedImage = await _imagepick.pickMultiImage();
    // XFile selectedvideo = await _imagepick.pickVideo(source: ImageSource.gallery);

    if (selectedImage.isNotEmpty){
      // imagefileList.clear();
      imagefileList.addAll(selectedImage);

      setState(() {});
    }
    // if (selectedvideo != null){
    //   // imagefileList.clear();
    //   imagefileList.add(selectedvideo);
    //   setState(() {});
    // }
    Get.back();

  }

  // void _openGallery(BuildContext context) async {
  //   var pickedFile = await _picker.getImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     _image = XFile(pickedFile.path);
  //     _image1 = XFile(pickedFile.path);
  //   });
  //
  //   Navigator.pop(context);
  // }
  //
  //

  void _openCamera(BuildContext context) async {
    var pickedFile = await _picker.pickImage(source: ImageSource.camera,

    );
    _image = XFile(pickedFile.path);
    imagefileList.add(_image);


    setState(() {
      // _image = XFile(pickedFile.path);
      _image1 = XFile(pickedFile.path);
    });
    Navigator.pop(context);
  }

  ColorResources color = ColorResources();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoading ? Center(
        child: Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: color.colortheme,
            )),
      )
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            color.sizedboxheight(30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                color.sizedboxwidth(20.0),
                Padding(
                  padding: const EdgeInsets.only(right: 70.0),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Card(

                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Icon(Icons.arrow_back,color: color.colortheme,),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Post Product",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      // color: textColor,
                      fontFamily: "Inter",
                      fontSize: 24.0,
                      color: color.textColor,
                      fontWeight: color.fontWeight600),
                ),
              ],
            ),
            color.sizedboxheight(5.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
              child: Row(
                children: [
                  imagefileList.isEmpty ?
                  InkWell(
                    onTap:(){
                      _showChoiceDialog(context);
                    },
                    child: Container(
                      height: 26.h,
                      width: 70.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 3,color: Colors.black)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image,color: Colors.black,size: 50,),
                          Text('Click to pick an Image.',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),)
                        ],
                      ),
                    ),
                  ) : Container(height: 26.h,
                      width: 70.w,
                      child: Image.file(File(imagefileList[0].path),fit: BoxFit.cover,)
                  ),
                  SizedBox(width: 5.w,),
                  Column(
                    children: [
                      imagefileList.length >= 2 ?
                      Container(height: 8.h,
                          width: 8.h,
                          child: Image.file(File(imagefileList[1].path),fit: BoxFit.cover,)
                      ) :
                      InkWell(
                        onTap:(){
                          _showChoiceDialog(context);
                        },
                        child: Container(
                          height: 8.h,
                          width: 8.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(width: 2,color: Colors.black)
                          ),
                          child: Icon(Icons.image,color: Colors.black,size: 24,),
                        ),
                      )  ,
                      SizedBox(height: 1.h,),
                      imagefileList.length >= 3 ?
                      Container(height: 8.h,
                          width: 8.h,
                          child: Image.file(File(imagefileList[2].path),fit: BoxFit.cover,)
                      ) :
                      InkWell(
                        onTap:(){
                          _showChoiceDialog(context);
                        },
                        child: Container(
                          height: 8.h,
                          width: 8.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 2,color: Colors.black)
                          ),
                          child: Icon(Icons.image,color: Colors.black,size: 24,),
                        ),
                      )  ,
                      SizedBox(height: 1.h,),
                      imagefileList.length >= 4 ?
                      Container(height: 8.h,
                          width: 8.h,
                          child: Image.file(File(imagefileList[3].path),fit: BoxFit.cover,)
                      ) :
                      InkWell(
                        onTap:(){
                          _showChoiceDialog(context);
                        },
                        child: Container(
                          height: 8.h,
                          width: 8.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 2,color: Colors.black)
                          ),
                          child: Icon(Icons.image,color: Colors.black,size: 24,),
                        ),
                      ) ,
                    ],
                  )
                ],
              ),
            ),
            /*Container(
              margin: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
              height: 200.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(0.0)
                ),
              ),
              child: InkWell(
                onTap: () {
                  _showChoiceDialog(context);
                },
                child:
                     imagefileList.isNotEmpty
                    ?
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                        crossAxisCount: 5,
                        crossAxisSpacing: 4,
                        childAspectRatio: 1,
                        mainAxisSpacing: 4
                    ),
                    itemCount: imagefileList.length,
                    itemBuilder: (BuildContext context, index){
                      return Image.file(File(imagefileList[index].path),fit: BoxFit.cover,);

                    }):
                     Container(
                         width: MediaQuery.of(context).size.width,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.all(
                             Radius.circular(15.0),
                           ),
                           */
            /*image: DecorationImage(
                               image: AssetImage("assets/images/placeholder.png"),

                           ),*/
            /*
                         ),
                       child: Image.asset('assets/images/placeholder.png',color: Colors.black,),

                     )



                // _image != null
                //     ? Container(
                //         width: MediaQuery.of(context).size.width,
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.all(
                //             Radius.circular(15.0),
                //           ),
                //            image: DecorationImage(
                //              image: ExactAssetImage(
                //                  "assets/images/placeholder.png"),
                //               fit: BoxFit.cover),
                //         ),
                //         child: ClipRRect(
                //           borderRadius: BorderRadius.circular(25),
                //           child: Image.file(
                //             File(_image.path),
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //       )
                //     : Container(
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.all(
                //             Radius.circular(15.0),
                //           ),
                //           image: DecorationImage(
                //               image: ExactAssetImage(
                //                   "assets/images/upload_image.png"),
                //               fit: BoxFit.cover),
                //         ),
                //       ),
              ),
            ),*/
            color.sizedboxheight(10.0),
            // InkWell(
            //   child: Container(
            //     padding: EdgeInsets.symmetric(
            //         horizontal: Dimensions.PADDING_SIZE_SMALL,
            //         vertical: Dimensions.PADDING_SIZE_SMALL),
            //     color: ColorResources.getHomeBg(context),
            //     alignment: Alignment.center,
            //     child: Card(
            //       elevation: 5,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(20.0)),
            //       child: Container(
            //         // height: 45,
            //         alignment: Alignment.center,
            //         decoration: BoxDecoration(
            //           color: Theme.of(context).cardColor,
            //           boxShadow: [
            //             BoxShadow(
            //                 color: Colors.grey[
            //                     Provider.of<ThemeProvider>(context).darkTheme
            //                         ? 900
            //                         : 200],
            //                 spreadRadius: 1,
            //                 blurRadius: 1)
            //           ],
            //           borderRadius: BorderRadius.circular(
            //               Dimensions.PADDING_SIZE_Thirty_Five),
            //         ),
            //         child: TextField(
            //           controller: productName,
            //           textAlign: TextAlign.left,
            //           decoration: InputDecoration(
            //             border: OutlineInputBorder(
            //               borderSide: BorderSide.none,
            //             ),
            //             hintText: 'Product Name',
            //           ),
            //           style: robotoRegular.copyWith(
            //             color: Colors.black,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // Container(
            //   padding: EdgeInsets.symmetric(
            //       horizontal: Dimensions.PADDING_SIZE_SMALL,
            //       vertical: Dimensions.PADDING_SIZE_SMALL),
            //   color: ColorResources.getHomeBg(context),
            //   alignment: Alignment.center,
            //   child: Card(
            //     elevation: 5,
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20.0)),
            //     child: Container(
            //       // height: 45,
            //       alignment: Alignment.center,
            //       decoration: BoxDecoration(
            //         color: Theme.of(context).cardColor,
            //         boxShadow: [
            //           BoxShadow(
            //               color: Colors.grey[
            //                   Provider.of<ThemeProvider>(context).darkTheme
            //                       ? 900
            //                       : 200],
            //               spreadRadius: 1,
            //               blurRadius: 1),
            //         ],
            //         borderRadius: BorderRadius.circular(
            //             Dimensions.PADDING_SIZE_Thirty_Five),
            //       ),
            //       child: TextField(
            //         controller: sizeText,
            //         textAlign: TextAlign.left,
            //         decoration: InputDecoration(
            //           border: OutlineInputBorder(
            //             borderSide: BorderSide.none,
            //           ),
            //           hintText: 'Size',
            //         ),
            //         style: robotoRegular.copyWith(
            //           color: Colors.black,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                "Select Category",
                style: TextStyle(
                    color: color.textColor,
                    fontSize: 18.0,
                    fontWeight: color.fontWeight600),
              ),
            ),
            select5btnall(),
            color.sizedboxheight(10.0),
            if(clickPosition!=-1)
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  "Select Sub-Category",
                  style: TextStyle(
                      color: color.textColor,
                      fontSize: 18.0,
                      fontWeight: color.fontWeight600),
                ),
              ),
            if(clickPosition!=-1)
              color.sizedboxheight(10.0),
            if(clickPosition!=-1)
              selectSubCategory(),
            color.sizedboxheight(10.0),
            Padding(
                  padding: EdgeInsets.only(left: 15.0),
              child: Text(
                "Product Name",
                style: TextStyle(
                    color: color.textColor,
                    fontSize: 18.0,
                    fontWeight: color.fontWeight700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
              child: Card(
                  elevation: 3,
                  child: Container(
                    height: 6.h,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0), border: color.borderCustom()),
                    child: Center(
                      child: TextFormField(
                        controller: productName,
                        // validator: validaterequired,
                        style: TextStyle(
                            color: color.colorblack, fontWeight: FontWeight.w500, fontSize: 18),
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          fillColor: color.colorWhite,
                          filled: true,
                          // hintText: 'comment'.tr(),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintStyle: TextStyle(
                            color: color.colorWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  )
              ),
            ),
            color.sizedboxheight(10.0),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Description",
                style: TextStyle(
                    color: color.textColor,
                    fontSize: 18.0,
                    fontWeight: color.fontWeight700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
              child: Card(elevation: 3, child: messagebox(context, productDes)),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0,bottom: 5,top:5),
              child: Text("Product Size",
                  style: TextStyle(
                      color: color.textColor,
                      fontSize: 18.0,
                      fontWeight: color.fontWeight700)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
              child: Card(
                  elevation: 3,
                  child: Container(
                    height: 6.h,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0), border: color.borderCustom()),
                    child: Center(
                      child: TextFormField(
                        controller: productSize,
                        // validator: validaterequired,
                        style: TextStyle(
                            color: color.colorblack, fontWeight: FontWeight.w500, fontSize: 18),
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          fillColor: color.colorWhite,
                          filled: true,
                          // hintText: 'comment'.tr(),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintStyle: TextStyle(
                            color: color.colorWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0,bottom: 5,top:5),
              child: Text("Product Material",
                  style: TextStyle(
                      color: color.textColor,
                      fontSize: 18.0,
                      fontWeight: color.fontWeight700)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
              child: Card(
                  elevation: 3,
                  child: Container(
                    height: 6.h,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0), border: color.borderCustom()),
                    child: Center(
                      child: TextFormField(
                        controller: productMaterial,
                        // validator: validaterequired,
                        style: TextStyle(
                            color: color.colorblack, fontWeight: FontWeight.w500, fontSize: 18),
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          fillColor: color.colorWhite,
                          filled: true,
                          // hintText: 'comment'.tr(),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          hintStyle: TextStyle(
                            color: color.colorWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0,bottom: 5,top:5),
              child: Text("Product Color",
                  style: TextStyle(
                      color: color.textColor,
                      fontSize: 18.0,
                      fontWeight: color.fontWeight700)),
            ),
            if(_colorProductModel!=null)
              Container(
              margin: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              padding: EdgeInsets.only(left: 15, right: 15),
              decoration:
              BoxDecoration(border: Border.all(color: Colors.black)),
              child: DropdownButton(
                // Initial Value
                // value: dropdownvalue,
                isExpanded: true,
                hint: Text(
                  dropdownvalue,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14),
                ),

                // Down Arrow Icon
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
                items: _colorProductModel.dataColor.map((DatumColor items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Row(
                      children: [
                        Container(
                          height: 4.h,
                          width: 4.h,
                          color: Color(int.parse('FF'+items.code.substring(1),radix: 16)),
                        ),
                        SizedBox(width: 5.w,),
                        Text(
                          items.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 14),
                        )
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (DatumColor newValue) {
                  setState(() {
                    dropdownvalue = newValue.name;
                    colorCode = newValue.code;
                    // for (var i = 0; i < _colorProductModel.dataColor.length; i++) {
                    //   colorCode = _colorProductModel.dataColor[i].code;
                    // }
                  });
                },
                underline: DropdownButtonHideUnderline(child: Container()),
              ),
            ),
            /*Padding(
              padding: EdgeInsets.only(left: 15.0,right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  *//*Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Button(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        btnfontsize: 3.0,
                        btnstyle: TextStyle(fontWeight: FontWeight.w600),
                        btnWidth: 28.w,
                        btnColor: color.colorWhite,
                        elevation: 29.0,
                        btnHeight: 40.0,
                        buttonName: "Add Size",
                        textColor: color.textColor,
                        onPressed: () {
                          setState(() {
                            addColor = 2;
                          });
                        }),
                  ),
                  color.sizedboxwidth(1.0),*//*
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Button(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        btnfontsize: 3.0,
                        btnstyle: TextStyle(fontWeight: FontWeight.w600),
                        btnWidth: 28.w,
                        elevation: 30.0,
                        btnColor: color.colorWhite,
                        btnHeight: 40.0,
                        buttonName: "Color",
                        textColor: color.textColor,
                        onPressed: () {
                          setState(() {
                            addColor = 1;
                          });
                        }),
                  ),
                  *//*color.sizedboxwidth(1.0),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Button(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        btnfontsize: 3.0,
                        elevation: 30.0,
                        btnstyle: TextStyle(fontWeight: FontWeight.w600),
                        btnWidth: 28.w,
                        btnColor: color.colorWhite,
                        btnHeight: 40.0,
                        buttonName: "Material",
                        textColor: color.textColor,
                        onPressed: () {
                          addColor = 3;

                        }),
                  ),*//*
                ],
              ),
            ),*/
            /*if (addColor == 1) // Colore Tab
              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: DropdownButton(
                  // Initial Value
                  // value: dropdownvalue,
                  isExpanded: true,
                  hint: Text(
                    dropdownvalue,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 14),
                  ),

                  // Down Arrow Icon
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                  items: _colorProductModel.dataColor.map((DatumColor items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Row(
                        children: [
                          Container(
                            height: 4.h,
                            width: 4.h,
                            color: Color(int.parse('FF'+items.code.substring(1),radix: 16)),
                          ),
                          SizedBox(width: 5.w,),
                          Text(
                            items.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (DatumColor newValue) {
                    setState(() {
                      dropdownvalue = newValue.name;
                      for (var i = 0;
                          i < _colorProductModel.dataColor.length;
                          i++) {
                        colorCode = _colorProductModel.dataColor[i].code;
                      }
                    });
                  },
                  underline: DropdownButtonHideUnderline(child: Container()),
                ),
              )
            else
              Container(),*/
            /*if (addColor == 2)// Add size
              Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration:
                BoxDecoration(border: Border.all(color: Colors.black)),
                child: DropdownButton(
                  // Initial Value
                  // value: dropdownvalue,
                  isExpanded: true,
                  hint: Text(
                    dropdownvalueSize,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 14),
                  ),

                  // Down Arrow Icon
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  ),
                  items: sizeList.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(
                        items,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownvalueSize = newValue;
                      for (var i = 0;
                      i < viewProductSizeModel.data.length;
                      // i < aSize.length;
                      i++) {
                        productSize =
                        // aSize[i].toString();
                        viewProductSizeModel.data[i].id.toString();
                      }
                    });
                  },
                  underline: DropdownButtonHideUnderline(child: Container()),
                ),
              )
            else
              Container(),*/



            color.sizedboxheight(10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [HexColor("#FFBE81"), HexColor("#FFBE81")],
                    )),
                child: Button(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    btnfontsize: 20.0,
                    elevation: 30.0,
                    btnstyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: color.colorWhite,
                        fontSize: 20.0),
                    btnWidth: color.deviceWidth(context, 1.0),
                    btnColor: Colors.transparent,
                    btnHeight: 60.0,
                    buttonName: "Upload",
                    textColor: Colors.white,
                    onPressed: () {
                      // if (productName.text.isEmpty) {
                      //   Fluttertoast.showToast(
                      //     msg: "please enter product name",
                      //     toastLength: Toast.LENGTH_SHORT,
                      //     gravity: ToastGravity.SNACKBAR,
                      //   );
                      // } else
                      if (categoryId == null) {
                        Fluttertoast.showToast(
                          msg: "please select product category",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                        );
                      } else if (productDes.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "please enter product descripion",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                          // duration
                        );
                      } else if (productName.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "please enter product name",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                          // duration
                        );
                      } else if (productSize.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "please enter product size",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                          // duration
                        );
                      }  else if (productMaterial.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "please enter product material",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                          // duration
                        );
                      }else if (imagefileList == null) {
                        Fluttertoast.showToast(
                          msg: "please select image",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                        );
                      } else {
                        print("image file>>>>>" + _image.toString());
                        print(">>>>>>>>>>>>>>");

                        addproductApi();
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget select5btnall() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      child: ListView.builder(
        itemCount: categoryList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final bool pressPosition = clickPosition == index;
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Button(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                btnfontsize: 3.0,
                btnstyle: TextStyle(
                    color: pressPosition ? color.colorblack : color.colorgrey,
                    fontWeight: FontWeight.w600),
                btnColor: color.colorWhite,
                elevation: 30.0,
                btnWidth: color.deviceWidth(context, 0.3),
                buttonName: categoryList[index].toString(),
                textColor: color.colorblack,
                onPressed: () async {
                  await subCategoryproductApi(categoryListId[index]);
                  setState(() {
                    clickPosition = index;
                    selectedCategoryId = categoryListId[index];
                    for (var i = 0;
                        i < _categoryProductModel.data.length;
                        i++) {
                      categoryId = _categoryProductModel.data[i].id.toString();
                    }
                    // sizeProductApi(ColornameId.toString());
                    print("id category      " + selectedCategoryId.toString());
                    print("category id    " + selectedCategoryId.toString());
                  });
                }),
          );
        },
      ),
    );
  }

  Widget selectSubCategory() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      child: ListView.builder(
        itemCount: subCategoryList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final bool pressPosition = subClickPosition == index;
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Button(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                btnfontsize: 3.0,
                btnstyle: TextStyle(
                    color: pressPosition ? color.colorblack : color.colorgrey,
                    fontWeight: FontWeight.w600),
                btnColor: color.colorWhite,
                elevation: 30.0,
                btnWidth: color.deviceWidth(context, 0.3),
                buttonName: subCategoryList[index].toString(),
                textColor: color.colorblack,
                onPressed: () {
                  setState(() {
                    subClickPosition = index;
                    selectedSubCategoryId = subCategoryListId[index];
                    for (var i = 0;
                    i < _subCategoryProductModel.data.length;
                    i++) {
                      subCategoryId = _subCategoryProductModel.data[i].id.toString();
                    }
                    // sizeProductApi(ColornameId.toString());
                    // print("id category      " + ColornameId.toString());
                    // print("category id    " + ColornameId.toString());
                  });
                }),
          );
        },
      ),
    );
  }
}

ColorResources color = ColorResources();
Widget messagebox(context, productDes) {
  return Container(
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7.0), border: color.borderCustom()),
    child: TextFormField(
      controller: productDes,
      // validator: validaterequired,
      maxLines: 3,
      style: TextStyle(
          color: color.colorblack, fontWeight: FontWeight.w500, fontSize: 18),
      decoration: InputDecoration(
        counterText: '',
        border: InputBorder.none,
        fillColor: color.colorWhite,
        filled: true,
        // hintText: 'comment'.tr(),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintStyle: TextStyle(
          color: color.colorWhite,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}

// Widget specificationbtn(context) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     children: [
//       Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//         ),
//         child: Button(
//             borderRadius: BorderRadius.all(Radius.circular(20.0)),
//             btnfontsize: 3.0,
//             btnstyle: TextStyle(fontWeight: FontWeight.w600),
//             btnWidth: color.deviceWidth(context, 0.3),
//             btnColor: color.colorWhite,
//             elevation: 30.0,
//             btnHeight: 40.0,
//             buttonName: "Add Size",
//             textColor: color.textColor,
//             onPressed: () {}),
//       ),
//       color.sizedboxwidth(1.0),
//       Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//         ),
//         child: Button(
//             borderRadius: BorderRadius.all(Radius.circular(20.0)),
//             btnfontsize: 3.0,
//             btnstyle: TextStyle(fontWeight: FontWeight.w600),
//             btnWidth: color.deviceWidth(context, 0.3),
//             elevation: 30.0,
//             btnColor: color.colorWhite,
//             btnHeight: 40.0,
//             buttonName: "Color",
//             textColor: color.textColor,
//             onPressed: () {}),
//       ),
//       color.sizedboxwidth(1.0),
//       Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(20.0)),
//         ),
//         child: Button(
//             borderRadius: BorderRadius.all(Radius.circular(20.0)),
//             btnfontsize: 3.0,
//             elevation: 30.0,
//             btnstyle: TextStyle(fontWeight: FontWeight.w600),
//             btnWidth: color.deviceWidth(context, 0.3),
//             btnColor: color.colorWhite,
//             btnHeight: 40.0,
//             buttonName: "material",
//             textColor: color.textColor,
//             onPressed: () {}),
//       ),
//     ],
//   );
// }
