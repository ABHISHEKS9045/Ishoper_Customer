import 'package:get/get.dart';

import 'http_request_helper.dart';


class AddsizeControlller extends GetxController{

  List sizes = [];


  @override
  void onInit(){
    super.onInit();
    addsize();
  }

  Future<dynamic> addsize()async {
    NetworkData networkData = NetworkData('https://mactosys.com/iShoper/api/v1/getSizeAndMaterials?category_id=5');
    List addsizeList = await networkData.getData();

    sizes = addsizeList[0]['sizes'];



    print(">>>>>>Add size$addsizeList");

    // print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${addsizeList[0]}');




  }


}