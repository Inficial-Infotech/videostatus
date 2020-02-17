import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:videostatus/Databasehelper.dart';
import 'dart:convert';
import 'package:sweetalert/sweetalert.dart';

import 'package:videostatus/OfflineView.dart';

class DownloadList extends StatefulWidget {
  @override
  _DownloadListState createState() => _DownloadListState();
}

class _DownloadListState extends State<DownloadList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new VideoListing(),
    );
  }
}
class VideoListing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return new Column(

      children: <Widget>[
        AllDownlaodVideoList()
      ],
    );
  }
}

class AllDownlaodVideoList extends StatefulWidget {
  @override
  _AllDownlaodVideoListState createState() => _AllDownlaodVideoListState();
}

class _AllDownlaodVideoListState extends State<AllDownlaodVideoList> {
  var db = new DatabaseHelper();
  List Videos=new List();
  List data=new List();
  List<String> VideoList=new List<String>();
  int set=1;
  static const platform = const MethodChannel('rjm.status.videostatus/share');
//  VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   init();



  }
  void init() async{
    await getvideoslist();
  }
  @override
  Widget build(BuildContext context) {

    return data!=null?set==0?new Container(height: MediaQuery.of(context).size.height-140,width: MediaQuery.of(context).size.width,child: new Center(child: Image(image: AssetImage("assets/empty.png"),width: 100.0,height: 100.0,),),):Expanded(child: ListView.builder(
    itemCount:data.length,
        itemBuilder: (context, index) {

      return new InkWell(
          onTap: (){
            var dis = {
              "title":data[index]['imagename'],
              "path":data[index]['path'].toString().substring(6,data[index]['path'].toString().length-1)
            };
            Navigator.push(context, new MaterialPageRoute(builder: (context)=>OfflineView(data:dis)));

          },
          child: new Container(
            height: 295.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                Padding(
                    padding: const EdgeInsets.fromLTRB(20.0,16.0,16.0,7.0),
                    child: new Row(
                      children: <Widget>[

                        new Expanded(child: Text(
                          data[index]['imagename'],
                          style: TextStyle(fontSize: 12.30),
                        )),
                        new IconButton(icon:new Icon(Icons.delete), onPressed: (){

                           deletefile(data[index]['path'].toString().substring(7,data[index]['path'].toString().length-1),index,data[index]['path'].toString());

                        }),
                        new IconButton(icon:new Icon(Icons.share), onPressed: () async{
                          bool test1=await platform.invokeMethod('shareVideo', data[index]['path'].toString().substring(7,data[index]['path'].toString().length-1));
//                          deletefile(data[index]['path'].toString().substring(7,data[index]['path'].toString().length-1),index,data[index]['path'].toString());

                        })
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

                            child: FadeInImage(placeholder: new AssetImage("assets/loader.png"),fit: BoxFit.cover,
                                image: MemoryImage(base64Decode(data[index]['base64']))

                            )
                          )
                      )

                  ),
                ),


                new Container(height: 8.0,color: Colors.black12,),

              ],
            ),
          ));
  })):new CircularProgressIndicator();
}

  getvideoslist() async{

    if (!(await SimplePermissions
        .checkPermission(Permission.WriteExternalStorage)) && !(await SimplePermissions
        .checkPermission(Permission.ReadExternalStorage))) {
      await SimplePermissions
          .requestPermission(Permission.WriteExternalStorage);
      await SimplePermissions
          .requestPermission(Permission.ReadExternalStorage);

    }
    Directory  externalDir = await getExternalStorageDirectory();
    final myDir = new Directory("${externalDir}/videostatus");
    myDir.exists().then((isThere) {
      isThere ? print('exists') :  new Directory(externalDir.path+'/'+'videostatus').create(recursive: true)
// The created directory is returned as a Future.
          .then((Directory directory) {
        print('Path of New Dir: '+directory.path);
        Videos=directory.listSync().toList();
        for (var name in Videos) {
         VideoList.add(name.toString());
        }

        getdata();
      });
    });
//    debugPrint(dire)


 }
  getdata() async {

    //debugPrint(id);
    var db=new DatabaseHelper();

    List download = await db.getAllimage();

    for (int i = 0; i < download.length; i++) {
      debugPrint(VideoList.toString());
//      debugPrint(download[i]['path'].toString());
//      debugPrint(Videos[i].toString());
//      debugPrint(Videos.indexOf(download[i]['path']).toString());
      if(VideoList.contains(download[i]['path'])){
        data.add(download[i]);


//        debugPrint("hello"+data[i]["id"].toString());
      }else{

        await db.deleteimage(download[i]['path']);
        debugPrint("no");
      }

    }

    if(VideoList.length==0){
      set=0;
    }
    setState(() {

    });


//    setState(() {
//      _subType=dataaa;
//    });


  }

  void deletefile(String path,int index,String id) {
    debugPrint(path);
    SweetAlert.show(context,
        subtitle: "Are You Sure?",
        style: SweetAlertStyle.confirm,
        showCancelButton: true, onPress: (bool isConfirm) {
          if(isConfirm){
            File f=new File(path);
            f.delete();
            data.removeAt(index);
            db.deleteimage(id);
            if(data.length==0){
              set=0;
            }
            setState(() {

            });
            return true;
          }else{

            return true;
          }
          // return false to keep dialog

        });
  }
}