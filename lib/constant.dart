

import 'package:admob_flutter/admob_flutter.dart';

class constant{
  static var intid="ca-app-pub-3940256099942544/1033173712";
  static var bannerid="ca-app-pub-3940256099942544/6300978111";
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
    adUnitId: 'ca-app-pub-3940256099942544/1033173712',
  );

}