import 'dart:io';

String getNativeAdUnitId(){
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2247696110';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-6030254742002833/8488479168';
//    return 'ca-app-pub-3940256099942544/2247696110';
  }
  throw UnsupportedError("Unsupported platform");
}

String getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/1033173712';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-6030254742002833/5230642157';
//    return 'ca-app-pub-3940256099942544/1033173712';
  }
  throw UnsupportedError("Unsupported platform");
}

String getBannerAdUnitId() {
 if (Platform.isIOS) {
   return 'ca-app-pub-3940256099942544/6300978111';
 } else if (Platform.isAndroid) {
   return 'ca-app-pub-6030254742002833/5655158227';
   // return 'ca-app-pub-3940256099942544/6300978111';
 }
 throw UnsupportedError("Unsupported platform");
}

//String getRewardBasedVideoAdUnitId() {
//  if (Platform.isIOS) {
//    return 'ca-app-pub-3940256099942544/1712485313';
//  } else if (Platform.isAndroid) {
//    return 'ca-app-pub-3940256099942544/5224354917';
//  }
//  throw UnsupportedError("Unsupported platform");
//}