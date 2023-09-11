// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:hexcolor/hexcolor.dart';

class MyCart extends StatefulWidget {
  MyCart({Key key}) : super(key: key);

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  ColorResources color = ColorResources();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        color.sizedboxheight(25.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            color.sizedboxwidth(20.0),
            Padding(
              padding: const EdgeInsets.only(right: 90.0),
              child: InkWell(
                  onTap: () {
                    // Get.back();
                  },
                  child: Card(
                      elevation: 3,
                      child: Image.asset("assets/images/backarrow.png"))),
            ),
            Text("My Cart",
                textAlign: TextAlign.center,
                style: TextStyle(
                    // color: textColor,
                    fontFamily: "Inter",
                    fontSize: 24.0,
                    color: color.textColor,
                    fontWeight: color.fontWeight600))
          ],
        ),
        color.sizedboxheight(10.0),
        myCartWidget(context),
        color.sizedboxheight(300.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                        color: color.colorgrey,
                        fontWeight: color.fontWeight400),
                  ),
                  Text(
                    "Rs. 2488",
                    style: TextStyle(
                        color: color.colorblack,
                        fontWeight: color.fontWeight600),
                  )
                ],
              ),
            ),
            payNowbtn(context)
          ],
        )
      ],
    ));
  }
}

ColorResources color = ColorResources();
Widget myCartWidget(context) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 110.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0)),

            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120.0,
                    height: 150.0,
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        image: DecorationImage(
                            image:
                                ExactAssetImage("assets/images/image (2).png"),
                            fit: BoxFit.contain)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      color.sizedboxheight(10.0),
                      Text(
                        "White Blazer Dress",
                        style: TextStyle(
                            color: HexColor("#2C2C2C"),
                            fontSize: 16.0,
                            fontWeight: color.fontWeight400),
                      ),
                      color.sizedboxheight(5.0),
                      Row(
                        children: [
                          Text(
                            "Size : S",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: HexColor("#747474"),
                              fontSize: 12.0,
                            ),
                          ),
                          color.sizedboxwidth(5.0),
                          Text(
                            "Color : White",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: HexColor("#747474"),
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Rs. 799",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: color.colorblack,
                            fontSize: 16.0,
                            fontWeight: color.fontWeight700),
                      )
                    ],
                  ),
                  color.sizedboxheight(10.0),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: Image.asset("assets/images/delete1.png"),
                  )
                ]),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 110.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0)),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120.0,
                    height: 150.0,
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        image: DecorationImage(
                            image:
                                ExactAssetImage("assets/images/image (3).png"),
                            fit: BoxFit.contain)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      color.sizedboxheight(10.0),
                      Text(
                        "White Blazer Dress",
                        style: TextStyle(
                            color: HexColor("#2C2C2C"),
                            fontSize: 16.0,
                            fontWeight: color.fontWeight400),
                      ),
                      color.sizedboxheight(5.0),
                      Row(
                        children: [
                          Text(
                            "Size : S",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: HexColor("#747474"),
                              fontSize: 12.0,
                            ),
                          ),
                          color.sizedboxwidth(5.0),
                          Text(
                            "Color : White",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: HexColor("#747474"),
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Rs. 799",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: color.colorblack,
                            fontSize: 16.0,
                            fontWeight: color.fontWeight700),
                      )
                    ],
                  ),
                  color.sizedboxheight(10.0),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: Image.asset("assets/images/delete1.png"),
                  )
                ]),
          ),
        ),
      ),
    ],
  );
}

Widget payNowbtn(context) {
  return Container(
      margin: EdgeInsets.all(8.0),
      width: 150.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [HexColor("#E07B7D"), HexColor("#F79294")],
          )),
      child: ElevatedButton(
        ////#F79294
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onSurface: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text("Pay Now "),
      ));
}
