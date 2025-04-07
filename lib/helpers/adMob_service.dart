import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class adMobService {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
    } else {
      return null;
    }
  }

  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
    } else {
      return null;
    }
  }

  static String? get rewardedAdUnitId {
    if (Platform.isAndroid) {
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
