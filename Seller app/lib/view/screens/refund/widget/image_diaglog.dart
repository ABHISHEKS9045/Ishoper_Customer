import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';



class ImageDialog extends StatelessWidget {
  final String imageUrl;
   ImageDialog({Key key, @required this.imageUrl}) : super(key: key);

  @override
    ColorResources color = ColorResources();
  Widget build(BuildContext context) {
    return Dialog(
      
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: color.colortheme),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage.assetNetwork(
                  placeholder: Images.placeholder_image, image: imageUrl, fit: BoxFit.contain,
                  imageErrorBuilder: (c, o, s) => Image.asset(
                    Images.placeholder_image, height: MediaQuery.of(context).size.width - 130,
                    width: MediaQuery.of(context).size.width, fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          ],
        ),
      ),
    );
  }
}
