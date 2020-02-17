import 'dart:convert';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alert/flutter_alert.dart';


import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

import 'package:videostatus/Databasehelper.dart';
import 'package:videostatus/VideoView.dart';

import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'constant.dart';


class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  static List videos=new List();
  static String token="";
  static String playlistid="PLi0zYwJsoR9wPRKCDaoZl7IH_SUBkakiS";
  var db = new DatabaseHelper();
  var ids=['PLi0zYwJsoR9wPRKCDaoZl7IH_SUBkakiS','PLi0zYwJsoR9z6cUzE1s-TeNKKCM5t-wgG','PLi0zYwJsoR9xGEC52uUKhnmBHWdeog39K','PLi0zYwJsoR9wZC_IrjhGno9THsV2HDt6c','PLi0zYwJsoR9ygATDCSAJ0FMxWFr6XLYv_','PLi0zYwJsoR9xmzvrOKp417ZkqHaqxnOpm','PLi0zYwJsoR9zSNft-PDV0KG-Ptk8c6G9v','PLi0zYwJsoR9xVBvYJ78x-gyxN7MIVOFuZ','PLi0zYwJsoR9wy3zx8vXiIrl8pdvJX3NQg','PLi0zYwJsoR9zmfstMGFa36P8vsc6jINJF','PLi0zYwJsoR9yCtRqj4lJBtpV5Hm6eyZr3','PLi0zYwJsoR9wmuLmBEJTJtURJrLhFowRn','PLi0zYwJsoR9zL_XIhiH17y1Qp6JT5lnG6'];
  static var cat=['Popular','Festivals','Love','Romantic','ગુજરતી','Sad','Cute','Birthday','Evergreen','ਮਰਾਠੀ','ਪੰਜਾਬੀ','தமிழ்','English'];
  static var images=[ 'assets/popular.png','assets/festival.png','assets/love.png','assets/rommentic.png','assets/gujarati.png','assets/sad.png','assets/cute.png','assets/birthday.png','assets/evergreen.png','assets/marathi.png','assets/punjabi.png','assets/kannad.png','assets/english.png'];
  static var totle=0;
  var flagg=false;
  AdmobInterstitial interstitialAd = AdmobInterstitial(
    adUnitId: 'ca-app-pub-9835721468083818/7731057035',
  );
  AdmobInterstitial interstitialAd1 = AdmobInterstitial(
    adUnitId: 'ca-app-pub-9835721468083818/7515434618',
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    if(videos.length==0) {
      loaddata(
          "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=12&playlistId=" +
              playlistid + "&key=AIzaSyA332Vyo9vgQDb4F836a8MwL4lPw-vRy-4");
    }

    }
  BuildContext _context;
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    _context=context;
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // Expanded(flex: 1, child: new InstaStories()),
        Flexible(child: new Column(

          children: <Widget>[
            new Material(

              elevation: 10.0,

              child: new SizedBox(
                child: new Container(
                  margin: const EdgeInsets.fromLTRB(00.0, 2.0, 00.0, 5.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: new Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: new ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: cat.length,
                            itemBuilder: (context, index) => new InkWell(
                              onTap: ()async{
                                setState(() {
                                  playlistid=ids[index];
                                });
                                constant.cat++;
                                interstitialAd1.load();
                                if(constant.cat>3){
                                  if (await interstitialAd1.isLoaded) {
                                    interstitialAd1.show();
                                    constant.cat=0;

                                  }
                                }
                                if(constant.cat==1){
                                  interstitialAd1.dispose();
                                }

                                loaddata("https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=12&playlistId="+playlistid+"&key=AIzaSyA332Vyo9vgQDb4F836a8MwL4lPw-vRy-4");

                              },
                              child: new Padding(padding: EdgeInsets.fromLTRB(5.0, 0.0, 10.0, 10.0),child: new Stack(
//          alignment: Alignment.bottomRight,
                                children: <Widget>[
                                  new Container(
                                    width: 65.0,
                                    height: 65.0,

                                    decoration: new BoxDecoration(
                                      shape: BoxShape.rectangle,

                                      borderRadius: BorderRadius.circular(10.0),
                                      image: new DecorationImage(

                                          fit: BoxFit.cover,

                                          image: AssetImage(images[index])),
                                    ),
//              margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                  ),

                                  new Container(
                                      width: 65.0,
                                      height: 65.0,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),color: Colors.black.withOpacity(0.5), ),

                                      child:new Center(
                                        child: Center(
                                          child: new Text(cat[index],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,decorationStyle: TextDecorationStyle.solid),),
                                        ),

                                      ))
                                ],
                              ),),
                            )
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                height: 80.0,

              ),
            ),



            videos.length!=0?Expanded(child: LazyLoadScrollView(
              onEndOfPage: (){
                if(token!=null) {
                  showProgress(_context);
                  loaddata1(
                      "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=12&pageToken=" +
                          token + "&playlistId=" + playlistid +
                          "&key=AIzaSyA332Vyo9vgQDb4F836a8MwL4lPw-vRy-4",
                      context);
                }
              },
              child: ListView.builder(
                itemCount: videos.length,
                  itemBuilder: (context, index) {
//          debugPrint(videos.length.toString());
//          debugPrint( videos[index]['snippet']['thumbnails'].toString());
//                  if((index)==(videos.length-1) && token!=null){
//
//
//                    loaddata1("https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=12&pageToken="+token+"&playlistId="+playlistid+"&key=AIzaSyA332Vyo9vgQDb4F836a8MwL4lPw-vRy-4",context);
//
//                  }
                    return videos[index]['snippet']['thumbnails']!=null?new Column(
                        children: <Widget>[
                          new InkWell(
                              onTap: ()async{
                                var data = {
                                  "title":videos[index]['snippet']['title'],
                                  "id":videos[index]['snippet']['resourceId']['videoId'],
                                  "image":videos[index]['snippet']['thumbnails']['high']['url']
                                };
                                constant.touchcount++;
                                interstitialAd.load();
                                    if(constant.touchcount>2){
                                        if (await interstitialAd.isLoaded) {
                                          interstitialAd.show();
//                                          interstitialAd.dispose();
                                          constant.touchcount=0;
                                        }


                                    }
                                    if(constant.touchcount==1){
                                      interstitialAd.dispose();
                                    }
                                Navigator.push(context, new MaterialPageRoute(builder: (context)=>VideoView(data:data)));

                              },
                              child: new Container(
                                height: 280.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    new Container(height: 8.0,color: Colors.black12,),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(10.0,16.0,16.0,7.0),
                                        child: new Row(
                                          children: <Widget>[
                                            new Container(
                                              width: 10.0,

                                              color: Colors.blueGrey,
                                            ),
                                            new Expanded(child: Text(
                                              videos[index]['snippet']['title'],
                                              style: TextStyle(fontSize: 12.30),
                                            ))
                                            ,],
                                        )
                                    ),
                                    new Container(

                                      child: Flexible(

                                          fit: FlexFit.loose,
                                          child: new Container(
                                              padding: EdgeInsets.all(15.0),
                                              decoration: BoxDecoration(shape: BoxShape.rectangle,borderRadius: BorderRadius.circular(10.0)),
                                              child:  new ClipRRect(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  child: FadeInImage(placeholder: new AssetImage("assets/loader.png"), image: AdvancedNetworkImage(
                                                    videos[index]['snippet']['thumbnails']['high']['url'],
                                                    useDiskCache: true,
                                                    cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                                                  ),
                                                    fit: BoxFit.cover,
                                                  )

                                              )
                                          )

                                      ),
                                    ),



                                  ],
                                ),
                              )),
                          index%6==0 && index!=0?new Container(height: 8.0,color: Colors.black12,):Container(),
                          index%6==0 && index!=0?Banneraddds():Container()

                        ]
                    ):new Container();}
              ),
            ),):new Container(height: MediaQuery.of(context).size.height-230,child: new Center(child: SpinKitChasingDots (
                    color: Colors.black,
                    size: 50.0,
                  ),),)
          ],
        ))
      ],
    );
  }

  loaddata(String url) async
  {

    videos=[];
    debugPrint(url);
    try{
      http.Response response=await http.get(url);

      if(response.statusCode==200)
      {
        String data=response.body;
        var data1=json.decode(data);

        setState(() {

          videos=data1['items'];
          token=data1['nextPageToken'];
          totle=data1['pageInfo']['totalResults'];
        });


      }else{

        errorblock();
      }}catch(e){


      errorblock();

    }

  }
  errorblock(){
    showAlert(
      context: context,
      barrierDismissible: false,
      title: "Alert",
      body: "Please tern on Internet",
      actions: [
        AlertAction(
          text: "Ok",
          isDestructiveAction: true,
          onPressed: () {
            loaddata("https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=12&playlistId="+playlistid+"&key=AIzaSyA332Vyo9vgQDb4F836a8MwL4lPw-vRy-4");

            // TODO
          },
        ),
        AlertAction(
          text: "Cancel",
          isDestructiveAction: true,
          onPressed: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            // TODO
          },
        ),
      ],

    );

//    showDialog(
//        context: context,
//        builder: (BuildContext context) {
//
//          return RichAlertDialog(
//            alertTitle: richTitle("Please tern on internet"),
//            alertType: RichAlertType.SUCCESS,
//            actions: <Widget>[
//              FlatButton(
//                child: Text("OK"),
//                onPressed: (){
//                              loaddata("https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=12&playlistId=PLi0zYwJsoR9yu_gFyeAKngLE_ugRpwyBT&key=AIzaSyC9TS2RFXI5j741UVFSiFqhIHlH-bQhArE");
//
//                  Navigator.pop(context);},
//              ),
//              FlatButton(
//                child: Text("Cancel"),
//                onPressed: (){Navigator.pop(context);},
//              ),
//            ],
//          );
//        }
//    );

  }
  loaddata1(String url,context) async
  {
      debugPrint(url);
    http.Response response=await http.get(url);
    Navigator.of(_context).pop();
    if(response.statusCode==200)
    {
      String data=response.body;
      var data1=json.decode(data);
      setState(() {

        videos=videos+data1['items'];
        try {
          token=data1['nextPageToken'];
          debugPrint(token);
        } catch (e) {
          token="End";
        }

      });


    }

  }
  showProgress(BuildContext context) {

    showDialog(

      barrierDismissible: false,
        context: context,

        builder: (context) => Center(

          child: new Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),

            child: SpinKitCubeGrid (
              color: Colors.white,
              size: 50.0,
            ),
          )
        ),);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    interstitialAd.dispose();
  }
}

class Banneraddds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdmobBanner(
        adUnitId: 'ca-app-pub-9835721468083818/6254323834',
        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {

    });
  }
}

