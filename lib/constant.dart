

import 'package:admob_flutter/admob_flutter.dart';

class constant{
  static var intid="id";
  static var bannerid="id";
  static var int="";
  static var reward="";
  static var touchcount=0;
  static var downloadcount=0;
  static var cat=0;
  static AdmobBanner banner=AdmobBanner(
        adUnitId: constant.bannerid,
        adSize: AdmobBannerSize.BANNER,
        );
  static AdmobInterstitial interstitialAd = AdmobInterstitial(
    adUnitId: 'id',
  );

}