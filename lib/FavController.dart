//import 'package:rxdart/rxdart.dart';
//import 'package:videostatus/Databasehelper.dart';
//import 'package:videostatus/FavModel.dart';
//class FavController{
//  final _Fav = PublishSubject<List<FavModel>>();
//  Observable<List<FavModel>> get allFav => _Fav.stream;
//  getdata() async {
//    //debugPrint(id);
//    var db=new DatabaseHelper();
//    List<FavModel> data = await db.getAllUsers();
//    _Fav.sink.add(data);
//  }
//  dispose() {
//    _Fav.close();
//  }
//}
//final Faverite = FavController();