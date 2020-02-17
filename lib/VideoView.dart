import 'dart:convert';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:videostatus/Databasehelper.dart';
import 'package:videostatus/main.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:youtube_player/youtube_player.dart';
import 'package:youtube_player/youtube_player.dart';

import 'constant.dart';

var Rec=0;
var Totle=0;
class VideoView extends StatefulWidget {
  var data;

  VideoView({Key key, this.data}) : super(key: key);
  TextEditingController _idController = TextEditingController();

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
   AdmobInterstitial interstitialAd = AdmobInterstitial(
    adUnitId: 'ca-app-pub-9835721468083818/2287158664',
  );

  static const platform = const MethodChannel('rjm.status.videostatus/share');
  GlobalKey<ScaffoldState> _scaffold=new GlobalKey<ScaffoldState>();
  var resdata;
  String id;
  var db = new DatabaseHelper();
  var flag=0;
  double prog=0.0;
  VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    init();

  }
  init() async
  {
    int count=await db.getCount(widget.data['id']);
    debugPrint("count"+count.toString());
    if(count>0)
    {
      flag=1;
    }
    else
    {
      flag=0;
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    interstitialAd.load();
    return WillPopScope(onWillPop:_onWillPop ,child:Scaffold(
      key: _scaffold,
        floatingActionButton: new Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,


          children: <Widget>[

            new Padding(padding: EdgeInsets.only(right: 10.0),child:new SizedBox(width: 49.00,height: 49.0,child: new RawMaterialButton(
                elevation: 5.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(10.0),
                shape: CircleBorder(side: BorderSide(style: BorderStyle.solid)),
                child: Icon(
                  Icons.share,
                  color: Colors.black,
                ),
                onPressed: () {
                  String url="http://deshkideals.com/ytd/main.php?Vid_Vid_video="+widget.data['id'];
                  download(url,2);
                }),),),
            new Padding(padding: EdgeInsets.only(right: 10.0),child:new SizedBox(width: 49.00,height: 49.0,child: new RawMaterialButton(
                elevation: 5.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(10.0),
                shape: CircleBorder(side: BorderSide(style: BorderStyle.solid)),
                child: Icon(
                  flag==0?Icons.favorite_border:Icons.favorite,
                  color:  flag==0?Colors.black:Colors.red,
                ),
                onPressed: () {

                  if(flag==1){
                    deletefav();
                  }else{
                    addFev(widget.data['id'], widget.data['image'], widget.data['title']);}
                  VideoStatusState.getdata();

                }),),),

            prog==0.0?new Padding(padding: EdgeInsets.only(right: 10.0),child:new SizedBox(width: 49.00,height: 49.0,child: new RawMaterialButton(
                elevation: 5.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(10.0),
                shape: CircleBorder(side: BorderSide(style: BorderStyle.solid)),
                child: Icon(
                 Icons.cloud_download,
                  color: Colors.black,
                ),
                onPressed: () {
                  debugPrint("click");
                  String url="http://deshkideals.com/ytd/main.php?Vid_Vid_video="+widget.data['id'];
                  download(url,1);
                }),),):
                new Material(
                  elevation: 6.0,
                  shape: CircleBorder(side: BorderSide(color: Colors.black )),

                  child: new CircularPercentIndicator(
                    radius: 48.0,
                    lineWidth: 5.0,
                    percent: prog/100,
                    backgroundColor: Colors.transparent,
                    center: new Icon(Icons.cloud_download),
                    progressColor: Colors.black,
                  ) ,
                )
             ,
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
          ],
        ),

        appBar: AppBar(
          title: Text("Video Status"),
          backgroundColor:Colors.white,
        ),
        body: SingleChildScrollView(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                fit: FlexFit.loose,
                child:YoutubePlayer(

                  aspectRatio: 1.7,
                  context: context,
                  source: widget.data['id'],
                  quality: YoutubeQuality.MEDIUM,
                  onVideoEnded: (){

                  },
                  callbackController: (controller) {
                    this. _controller = controller;
                  },
                  autoPlay: true,
                  showVideoProgressbar: true,
                  showThumbnail: true,






                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.data['title'],

                ),
              ),

//              Banneraddds()
            ],
          ),
        )));
    }
   download(String url,int flag) async
  {
    constant.downloadcount++;
    debugPrint("//////////////////////////"+constant.downloadcount.toString());

    if(constant.downloadcount>1){
      if (await interstitialAd.isLoaded) {
        interstitialAd.show();


      }

      constant.downloadcount=0;
      debugPrint(constant.downloadcount.toString());
    }
    if(constant.downloadcount==1){interstitialAd.dispose();}
    _scaffold.currentState.showSnackBar(new SnackBar(
      content: new Text("Waiting...."),));
    var data1;
    http.Response response=await http.get(url);
    if(response.statusCode==200)
    {
      String data=response.body;
      var data1=json.decode(data);
setState(() {
  resdata=data1;
});


      debugPrint(data1.toString());
//      if (!(await SimplePermissions
//          .checkPermission(Permission.WriteExternalStorage)) && !(await SimplePermissions
//          .checkPermission(Permission.ReadExternalStorage))) {
//        await SimplePermissions
//            .requestPermission(Permission.WriteExternalStorage);
//        await SimplePermissions
//            .requestPermission(Permission.ReadExternalStorage);
//
//      }

      final externalDir = await getExternalStorageDirectory();
      final myDir = new Directory("${externalDir}/videostatus");

      //create a new directory .....

      myDir.exists().then((isThere) {
        isThere ? print('exists') :  new Directory(externalDir.path+'/'+'videostatus').create(recursive: true)
// The created directory is returned as a Future.
            .then((Directory directory) {
          print('Path of New Dir: '+directory.path);
        });
      });
      final filePath = path.join(externalDir.path,"videostatus");
      final filePath1 = path.join(externalDir.path,"videostatus",widget.data['title']+widget.data['id'] + "."+data1['type']);

      final file = new File(filePath1);
      debugPrint(file.toString());
      if(await file.exists())
      {
        if(flag==2){


          debugPrint("filepath///////////////:"+filePath.toString());
          bool test1=await platform.invokeMethod('shareVideo', filePath1);

        }else{
          _scaffold.currentState.showSnackBar(new SnackBar(
            content: new Text("Already downloaded"),));
        }

      }else{

//        debugPrint(data1['link']);
        addDownloadList(widget.data['image'],filePath1,widget.data['title']);
//      downloadd(data1['link'],filePath);
        var id = await FlutterDownloader.enqueue(
          url: data1['link'],
          savedDir:filePath ,
          fileName: widget.data['title']+widget.data['id'] + "."+data1['type'],
          showNotification: true, // show download progress in status bar (for Android)
          openFileFromNotification: true
        // click on notification to open downloaded file (for Android)
        );
        FlutterDownloader.registerCallback((id, status, progress) {
          // code to update your UI
          debugPrint("progress"+progress.toString());
          prog=progress+0.0;
          debugPrint("prog"+progress.toString());
          setState(() {

          });
        });
//        FlutterDownloader.registerCallback((id, status, progress) {
//          prog=progress as double;
//         debugPrint(progress.toString());
//          setState(() {
//
//          });
//          debugPrint("progress"+progress.toString());
//        });

        if(flag==2){
//          debugPrint("filepath///////////////:"+filePath.toString());
          bool test1=await platform.invokeMethod('shareVideo', filePath1);
        }
      }



    }

  }
  Future addDownloadList (link,path,imagename)
  async {
    http.Response response = await http.get(
      link
    );
    String base64 = base64Encode(response.bodyBytes);
      int res=await db.saveimage(base64,File(path).toString(),imagename);
    debugPrint(res.toString());
//    setState(() {
//      state=true;
//    });
  }

  Future addFev (id,image,title)
  async {

    int res=await db.saveUser(id,image,title);
    debugPrint(res.toString());
    setState(() {
      flag=1;
    });
  }

  void deletefav() async{

    int data=await db.deleteUser(widget.data['id']);
    setState(() {
      flag=0;
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();


  }
  Future<bool> _onWillPop() {

    Navigator.of(context).pop({"result":true});

  }

//  void downloadd(url,filePath) async{
//    Dio dio=new Dio();
//
//    await dio.download(url, filePath, onReceiveProgress: (rec,totle){
//      print("REC:$rec,TOTLE:$totle");
//      progress=((rec / totle) * 100);
//      setState(() {
//
//      });
//
//    });
//  }
  Future<File> downloadd(String url, String filePath) async {
    http.Client client = new http.Client();
    var req = await client.get(Uri.parse(url)).then((msg){
      debugPrint(msg.toString());
    });
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File(filePath);
    await file.writeAsBytes(bytes);
    return file;
  }




}

class Banneraddds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdmobBanner(
        adUnitId: 'ca-app-pub-3940256099942544/6300978111',
        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {

        });
  }
}
