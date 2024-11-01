import 'dart:async';

import 'package:custom_data/custom_data.dart';
import 'package:custom_ui/features/ads/data/ad_config_aim.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class IAdServiceAim {
  Future<bool> preloadAd(AdUnitConfigAim config);
  Future<bool> showAd(AdUnitConfigAim config);
}

class AdServiceAim implements IAdServiceAim {
  AdServiceAim({
    required this.platform,
    required this.connectivity,
    required this.logger,
  });

  // This is same for everyone: https://developers.google.com/admob/android/test-ads
  static const String defaultTestRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  final IPlatformInfo platform;
  final IConnectivityAim connectivity;
  final ILoggerImportantAim? logger;

  final _loadedAds = <String, RewardedAd>{};

  @override
  Future<bool> preloadAd(AdUnitConfigAim config) async {
    if (!platform.platformType.isMobile) {
      return false;
    }
    try {
      final ad = await _loadAdInternal(config);
      return ad != null;
    } on Object catch (e) {
      logger?.logError('preload_ad_error', e.toString());
      return false;
    }
  }

  Future<RewardedAd?> _loadAdInternal(AdUnitConfigAim config) async {
    final adPreloaded = _loadedAds[config.adUnitId];
    if (adPreloaded != null) {
      return adPreloaded;
    }
    await connectivity.waitInternetConnection();
    final completer = Completer<RewardedAd?>();
    debugPrint(' > preloading #ad : isTest=${config.isTestAd}');
    await RewardedAd.load(
      adUnitId: config.isTestAd ? defaultTestRewardedAdUnitId : config.adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint(
              ' > loaded #ad : isTest=${config.isTestAd} (adUnitId isTest=${ad.adUnitId == defaultTestRewardedAdUnitId})');
          _loadedAds[config.adUnitId] = ad;
          completer.complete(ad);
          logger?.logImportantMultiple(
            'preload_ad_success_to_load',
            'loaded',
            step: 'attempt ${config.loadAttemptIndex} / ${config.loadAttempts}',
          );
        },
        onAdFailedToLoad: (e) {
          completer.complete(null);
          logger?.logImportantMultiple(
            'preload_ad_failed_to_load',
            e.message,
            step: 'attempt ${config.loadAttemptIndex} / ${config.loadAttempts}',
          );
        },
      ),
    );
    /*
    
    */
    final result = await completer.future;
    if (result != null) {
      return result;
    }
    if (config.loadAttemptIndex < config.loadAttempts) {
      await Future<void>.delayed(const Duration(seconds: 2));
      return _loadAdInternal(config.copyWith(loadAttemptIndex: config.loadAttemptIndex + 1));
    }
    return null;
  }

  @override
  Future<bool> showAd(AdUnitConfigAim config) async {
    if (!platform.platformType.isMobile) {
      return false;
    }
    try {
      logger?.logImportant('show_ad_started', config.name);
      final ad = await _loadAdInternal(config);
      _loadedAds.remove(config.adUnitId);
      if (ad == null) {
        logger?.logImportant('show_ad_failed_load', config.name);
        return false;
      }
      await connectivity.waitInternetConnection();
      final completer = Completer<bool>();
      await ad.show(onUserEarnedReward: (e, r) {
        completer.complete(true);
        logger?.logImportant('show_ad_success', config.name);
      });

      return completer.future.timeout(const Duration(seconds: 60), onTimeout: () {
        logger?.logError('show_ad_timeout', 'Ad show timeout');
        return false;
      });
    } on Object catch (e) {
      logger?.logError('show_ad_error', e.toString());
      return false;
    }
  }
}
