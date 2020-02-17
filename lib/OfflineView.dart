import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';


class OfflineView extends StatefulWidget {
  var data;

  OfflineView({Key key, this.data}) : super(key: key);
  @override
  _OfflineViewState createState() => _OfflineViewState();
}

class _OfflineViewState extends State<OfflineView> {

  VideoPlayerController videoPlayerController;
 var  chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = VideoPlayerController.file(
        File(widget.data['path']))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          videoPlayerController.play();
        });
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          aspectRatio: videoPlayerController.value.aspectRatio,
          looping: true,
          cupertinoProgressColors: ChewieProgressColors(backgroundColor: Colors.black54),
            materialProgressColors: ChewieProgressColors(backgroundColor: Colors.white,handleColor: Colors.red.shade500),


        );

      });


  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: Colors.black,
//        floatingActionButton: new Row(
//          crossAxisAlignment: CrossAxisAlignment.end,
//          mainAxisAlignment: MainAxisAlignment.end,
//          mainAxisSize: MainAxisSize.min,


//          children: <Widget>[

//            new Padding(padding: EdgeInsets.only(right: 10.0),child:new SizedBox(width: 49.00,height: 49.0,child: new RawMaterialButton(
//                elevation: 5.0,
//                fillColor: Colors.white,
//                padding: const EdgeInsets.all(10.0),
//                shape: CircleBorder(side: BorderSide(style: BorderStyle.solid)),
//                child: Icon(
//                  Icons.share,
//                  color: Colors.black,
//                ),
//                onPressed: () {
//                  String url="http://deshkideals.com/ytd/main.php?Vid_Vid_video="+widget.data['id'];
//                  download(url,2);
//                }),),),
//            new Padding(padding: EdgeInsets.only(right: 10.0),child:new SizedBox(width: 49.00,height: 49.0,child: new RawMaterialButton(
//                elevation: 5.0,
//                fillColor: Colors.white,
//                padding: const EdgeInsets.all(10.0),
//                shape: CircleBorder(side: BorderSide(style: BorderStyle.solid)),
//                child: Icon(
//                  Icons.favorite_border,
//                  color: Colors.black,
//                ),
//                onPressed: () {}),),),
//            FloatingActionButton.extended(
//              shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black),borderRadius: BorderRadius.circular(30.0)),
//              onPressed: () {
//                debugPrint("click");
//                String url="http://deshkideals.com/ytd/main.php?Vid_Vid_video="+widget.data['id'];
//                download(url,1);
//              },
//              backgroundColor: Colors.white,
//              icon: Icon(Icons.save,color: Colors.black,),
//              label: Text("Save",style: TextStyle(color: Colors.black),),
//            ),
//          ],
//        ),


        body: SingleChildScrollView(
          child: new Container(
            height:MediaQuery.of(context).size.height ,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                Expanded(

                  child: videoPlayerController.value.initialized
                      ? Chewie(
                    controller: chewieController,
                  )
                      : Container(),
                ),

              ],
            ),
          )
        ));
  }
  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

}
