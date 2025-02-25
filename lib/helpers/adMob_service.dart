import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class adMobService {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else {
      return null;
    }
  }

  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else {
      return null;
    }
  }

  static String? get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else {
      return null;
    }
  }

  static final BannerAdListener bannerListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint("Ad Loaded"),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint("Ad Loaded");
    },
    onAdOpened: (ad) => debugPrint("Ad Opened"),
    onAdClosed: (ad) => debugPrint("Ad Closed"),
  );
}
