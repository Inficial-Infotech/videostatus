import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:videostatus/Databasehelper.dart';
import 'package:videostatus/VideoView.dart';
import 'package:videostatus/main.dart';

class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {

  bool flag=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:VideoStatusState.data.length==0?new Center(child: Image(image: AssetImage("assets/empty.png"),width: 100.0,height: 100.0,),):new Column(
        children: <Widget>[
          Expanded(child: ListView.builder(
              itemCount:VideoStatusState.data.length,
              itemBuilder: (context, index) {

                return new InkWell(
                    onTap: ()async{
                      var senddata = {
                        "title":VideoStatusState.data[index]['title'],
                        "id":VideoStatusState.data[index]['youtubeid'],
                        "image":VideoStatusState.data[index]['image']
                      };
                      Map result=await Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                              new VideoView(data:senddata)));

                      if(result!=null)
                      {
                        setState(() {

                        });
                      }

                      debugPrint(result.toString());

                    },
                    child: new Container(
                      height: 280.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[

                          Padding(
                              padding: const EdgeInsets.fromLTRB(10.0,16.0,16.0,7.0),
                              child: new Row(
                                children: <Widget>[
                                  new Container(
                                    width: 10.0,

                                    color: Colors.blueGrey,
                                  ),
                                  new Expanded(child: Text(
                                    VideoStatusState.data[index]['title'],
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
                                      child:FadeInImage(placeholder: new AssetImage("assets/loader.png"),
                                        image: AdvancedNetworkImage(
                                          VideoStatusState.data[index]['image'],
                                          useDiskCache: true,
                                          cacheRule: CacheRule(maxAge: const Duration(days: 7)),
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    )
                                )

                            ),
                          ),


                          new Container(height: 8.0,color: Colors.black12,),

                        ],
                      ),
                    ));
              }))
        ],
      )
    );
  }
}
