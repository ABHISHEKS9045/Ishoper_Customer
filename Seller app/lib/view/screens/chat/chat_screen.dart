import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixvalley_vendor_app/data/model/body/MessageBody.dart';
import 'package:sixvalley_vendor_app/data/model/response/chat_model.dart';
import 'package:sixvalley_vendor_app/provider/chat_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources2.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/base/custom_app_bar.dart';
import 'package:sixvalley_vendor_app/view/screens/chat/video_player_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/chat/widget/message_bubble.dart';

class ChatScreen extends StatelessWidget {
  final Customer customer;
  final int customerIndex;
  final List<MessageModel> messages;
  ChatScreen({@required this.customer, @required this.customerIndex, @required this.messages});

  final ImagePicker picker = ImagePicker();
  final TextEditingController _controller = TextEditingController();
  ColorResources color = ColorResources();
  ImagePicker _imagepick = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Consumer<ChatProvider>(builder: (context, chat, child) {
        return Column(children: [

          CustomAppBar(title: customer.fName+' '+customer.lName),

          // Chats
          Expanded(child: chat.chatList != null ? messages.length != 0 ? ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            itemCount: messages.length,
            reverse: true,
            itemBuilder: (context, index) {
              List<MessageModel> chats = messages.reversed.toList();
              return MessageBubble(chat: chats[index], customerImage: customer.image);
            },
          ) : SizedBox.shrink() : ChatShimmer()),

          // Bottom TextField
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: 70,
                child: Card(
                  color: Theme.of(context).highlightColor,
                  shadowColor: Colors.grey[200],
                  elevation: 2,
                  margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                    child: Row(children: [
                      InkWell(
                        onTap: (){
                          _showChoiceDialog(context);
                        },
                          child: Icon(Icons.camera_alt_outlined,color: color.colortheme,)),
                      SizedBox(width: 10,),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: titilliumRegular,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          expands: true,
                          decoration: InputDecoration(
                            hintText: 'Type here...',
                            hintStyle: titilliumRegular.copyWith(color: ColorResources.HINT_TEXT_COLOR),
                            border: InputBorder.none,
                          ),
                          onChanged: (String newText) {
                            if(newText.isNotEmpty && !Provider.of<ChatProvider>(context, listen: false).isSendButtonActive) {
                              Provider.of<ChatProvider>(context, listen: false).toggleSendButtonActivity();
                            }else if(newText.isEmpty && Provider.of<ChatProvider>(context, listen: false).isSendButtonActive) {
                              Provider.of<ChatProvider>(context, listen: false).toggleSendButtonActivity();
                            }
                          },
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          if(Provider.of<ChatProvider>(context, listen: false).isSendButtonActive){
                            MessageBody messageBody = MessageBody(sellerId: customer.id.toString(), message: _controller.text.trim());
                            Provider.of<ChatProvider>(context, listen: false).sendMessage(messageBody, customerIndex, context);
                            _controller.text = '';
                          }
                        },
                        child: Icon(
                          Icons.send,
                          color: Provider.of<ChatProvider>(context).isSendButtonActive ? color.colortheme : ColorResources.HINT_TEXT_COLOR,
                          size: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),

            ],
          ),
        ]);
      }),
    );
  }
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
                      _showImageVideoChoiceDialog(context);
                      // pickMultipleImage(ImageSource.gallery);
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.image_sharp,
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

  Future<void> _showImageVideoChoiceDialog(BuildContext context) {
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
                      selectImage(true,context);
                      // pickMultipleImage(ImageSource.gallery);
                    },
                    title: Text("Image"),
                    leading: Icon(
                      Icons.image,
                      color: color.colortheme,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: color.colortheme,
                  ),
                  ListTile(
                    onTap: () {
                      selectImage(false,context);
                    },
                    title: Text("Video"),
                    leading: Icon(
                      Icons.video_call_rounded,
                      color: color.colortheme,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  route(bool isSuccess, String name, String type,context) async {
    if (isSuccess){
      MessageBody messageBody = MessageBody(sellerId: customer.id.toString(), message: name);
      Provider.of<ChatProvider>(context, listen: false).sendAttachment(messageBody,type=='video' ? false : true,customerIndex, context);
    } else {
      print('Image upload problem');
    }
  }
  void selectImage(bool isImage,BuildContext context)async{
    if(isImage){
      XFile selectedImage = await _imagepick.pickImage(source: ImageSource.gallery);
      if (selectedImage!=null){
        await Provider.of<ChatProvider>(context, listen: false).addProductImage(selectedImage.path,'product', route,context);
        print(selectedImage.path);
        // imagefileList.clear();
        // imagefileList.addAll(selectedImage);

        // setState(() {});
      }
    }
    else{
      XFile selectedvideo = await _imagepick.pickVideo(source: ImageSource.gallery);

      if(selectedvideo!=null){
        await Provider.of<ChatProvider>(context, listen: false).addProductVideo(selectedvideo.path, route,context);
        print(selectedvideo.path);
      }
    }

    // XFile selectedvideo = await _imagepick.pickVideo(source: ImageSource.gallery);


    // if (selectedvideo != null){
    //   // imagefileList.clear();
    //   imagefileList.add(selectedvideo);
    //   setState(() {});
    // }
    Navigator.of(context).pop();
    Navigator.of(context).pop();

  }
  void _openCamera(BuildContext context) async {
    XFile pickedFile = await _imagepick.pickImage(source: ImageSource.camera,);

    if(pickedFile!=null) {
      await Provider.of<ChatProvider>(context, listen: false).addProductImage(pickedFile.path,'product', route,context);
      print(pickedFile.path);
    }
    Navigator.pop(context);
  }


}

class ChatShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      shrinkWrap: true,
      reverse: true,
      itemBuilder: (context, index) {

        bool isMe = index%2 == 0;
        return Shimmer.fromColors(
          baseColor: isMe ? Colors.grey[300] : ColorResources.IMAGE_BG,
          highlightColor: isMe ? Colors.grey[100] : ColorResources.IMAGE_BG.withOpacity(0.9),
          enabled: Provider.of<ChatProvider>(context).chatList == null,
          child: Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              isMe ? SizedBox.shrink() : InkWell(child: CircleAvatar(child: Icon(Icons.person))),
              Expanded(
                child: Container(
                  margin: isMe ?  EdgeInsets.fromLTRB(50, 5, 10, 5) : EdgeInsets.fromLTRB(10, 5, 50, 5),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                        bottomRight: isMe ? Radius.circular(0) : Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: isMe ? ColorResources.IMAGE_BG : ColorResources.WHITE
                  ),
                  child: Container(height: 20),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}

