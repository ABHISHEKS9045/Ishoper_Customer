import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/data/model/response/chat_model.dart';
import 'package:sixvalley_vendor_app/helper/date_converter.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources2.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

import '../video_player_screen.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel chat;
  final String customerImage;
  MessageBubble({@required this.chat, @required this.customerImage});

  @override
  Widget build(BuildContext context) {
    bool isMe = chat.sentByCustomer == 0;
    return Row(crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isMe ? SizedBox.shrink() : InkWell(child: ClipOval(child: Container(
          color: Theme.of(context).highlightColor,
          child: CachedNetworkImage(
            errorWidget: (ctx, url, err) => Image.asset(Images.placeholder_image),
            placeholder: (ctx, url) => Image.asset(Images.placeholder_image),
            imageUrl: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/$customerImage',
            height: 40,
            width: 40,
            fit: BoxFit.cover,
          ),
        ))),
        Flexible(
          child: InkWell(
            onTap: (){
              if(chat.video!=null && chat.video.isNotEmpty){
                showVideoDialog(context,chat.video);
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (_) {
                //       return VideoPlayerScreen(videoURL: chat.video);
                //     }));
              }
            },
            child: Container(
                margin: isMe ?  EdgeInsets.fromLTRB(70, 5, 10, 5) : EdgeInsets.fromLTRB(10, 10, 50, 10),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                    bottomRight: isMe ? Radius.circular(0) : Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: isMe ? ColorResources.getImageBg(context) : Theme.of(context).highlightColor,
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  !isMe ? Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(chat.createdAt)), style: titilliumRegular.copyWith(
                    fontSize: 8,
                    color: ColorResources.getHint(context),
                  )) : SizedBox.shrink(),

                  chat.message!=null ? Text(chat.message, textAlign: TextAlign.justify, style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)) : SizedBox.shrink(),
                  if(chat.image!=null && chat.image.isNotEmpty)
                    Image.network('${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${chat.image}',
                      height: 100,width: 100,fit: BoxFit.fill,),
                  chat.video!=null ? Text(chat.video, textAlign: TextAlign.justify, style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)) : SizedBox.shrink(),

                ]),
            ),
          ),
        ),
      ],
    );
  }
  Future<void> showVideoDialog(BuildContext context,String url) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 200,
                width: MediaQuery.of(context).size.width*0.9,
                child: VideoPlayerScreen(videoURL: url,)
            ),
          );
        });
  }
}
