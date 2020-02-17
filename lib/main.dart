import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:videostatus/Databasehelper.dart';
import 'package:videostatus/DownloadList.dart';
import 'package:videostatus/Favourite.dart';
import 'package:videostatus/Videos.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:share/share.dart';
void main(){
  Admob.initialize('ca-app-pub-9835721468083818~9296308190');
  Routes();
}
class Routes {

var routes = <String, WidgetBuilder>{
//  "/SignUp": (BuildContext context) => new wallpaper(),

};

Routes() {

  runApp(new MaterialApp(

//    debugShowCheckedModeBanner: false,
    title: "Video Status",
    onGenerateTitle: (BuildContext contex)=>"Video Status",
    home: new VideoStatus(),
    theme: new ThemeData(
        accentColor: Colors.black,
        primaryColor: Colors.white,
        primaryColorDark: Colors.white,
        indicatorColor: Colors.white,
        backgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(

        )

    ),
    routes: routes,
  ));
}
}
class VideoStatus extends StatefulWidget {
  @override
  VideoStatusState createState() => VideoStatusState();
}

class VideoStatusState extends State<VideoStatus>  with TickerProviderStateMixin {


  int _currentIndex = 0;
  BottomNavigationBarType _type = BottomNavigationBarType.shifting;
  List<NavigationIconView> _navigationViews;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static List data=new List();
  @override
  void initState() {
    getdata();
    _getPushToken();
    super.initState();
    _navigationViews = <NavigationIconView>[
      NavigationIconView(
        icon: const Icon(Icons.video_library,color: Colors.black,),
        title: 'Videos',
        color: Colors.white,
        vsync: this,
      ),
      NavigationIconView(
        icon:new Icon(Icons.favorite_border,color: Colors.black,),
        title: 'Favourite',
        color: Colors.white,
        vsync: this,
      ),

      NavigationIconView(
        icon: const Icon(Icons.cloud_download,color: Colors.black,),
        title: 'Downloads',
        color: Colors.white,
        vsync: this,
      ),

    ];

    _navigationViews[_currentIndex].controller.value = 1.0;
  }

  static getdata() async {
    //debugPrint(id);
    var db=new DatabaseHelper();
    VideoStatusState.data = await db.getAllUsers();

  }
  @override
  void dispose() {
    for (NavigationIconView view in _navigationViews)
      view.controller.dispose();
    super.dispose();
  }
  Future<String> _getPushToken() async {

    print('called _getPushToken');

    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));

    String _token = await _firebaseMessaging.getToken();
    print('received token'+_token);
    return _token;
  }

  Widget _buildTransitionsStack() {
//    final List<FadeTransition> transitions = <FadeTransition>[];
//
//    for (NavigationIconView view in _navigationViews)
//      transitions.add(view.transition(_type, context));
//
//    // We want to have the newly animating (fading in) views on top.
//    transitions.sort((FadeTransition a, FadeTransition b) {
//      final Animation<double> aAnimation = a.opacity;
//      final Animation<double> bAnimation = b.opacity;
//      final double aValue = aAnimation.value;
//      final double bValue = bAnimation.value;
//      return aValue.compareTo(bValue);
//    });
//
//    return Stack(children: transitions);
  }

  setbody(int pos)
  {
    switch(pos)
    {
      case 0:return VideoList();
      case 1:return Favourite();
      case 2:return DownloadList();
      case 3:return Favourite();

    }

  }
  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = BottomNavigationBar(
      items: _navigationViews
          .map<BottomNavigationBarItem>((NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: _type,
      //iconSize: 4.0,
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Status'),
        backgroundColor:Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.star_border),
            onPressed: () {
              LaunchReview.launch(androidAppId: "rjm.status.videostatus",iOSAppId: "585027354");

//              _select(choices[0]);
            },
          ),
          // action button
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share('Download 10000+ amazing video status app https://play.google.com/store/apps/details?id=rjm.status.videostatus&hl=en');

//              _select(choices[1]);
            },
          ),
        ],
      ),
      body: Center(
          child: setbody(_currentIndex)
      ),
      bottomNavigationBar: botNavBar,
    );
  }
}
class NavigationIconView {
  NavigationIconView({
    Widget icon,
    Widget activeIcon,
    String title,
    Color color,
    TickerProvider vsync,
  }) : _icon = icon,
        _color = color,
        _title = title,
        item = BottomNavigationBarItem(
          icon: icon,
          activeIcon: activeIcon,
          title: Text(title,style: TextStyle(color: Colors.black),),
          backgroundColor: color,
        ),
        controller = AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = controller.drive(CurveTween(
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    ));
  }

  final Widget _icon;
  final Color _color;
  final String _title;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  Animation<double> _animation;

  FadeTransition transition(BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: _animation.drive(
          Tween<Offset>(
            begin: const Offset(0.0, 0.02), // Slightly down.
            end: Offset.zero,
          ),
        ),
        child: IconTheme(
          data: IconThemeData(
            color: iconColor,
            size: 120.0,
          ),
          child: Semantics(
            label: 'Placeholder for $_title tab',
            child: _icon,
          ),
        ),
      ),
    );
  }
}

