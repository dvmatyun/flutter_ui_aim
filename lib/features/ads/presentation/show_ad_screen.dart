import 'package:custom_data/custom_data.dart';
import 'package:custom_ui/custom_ui.dart';
import 'package:custom_ui/features/ads/data/ad_config_aim.dart';
import 'package:custom_ui/features/ads/data/ad_service_aim.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// {@template show_ad_screen}
/// ShowAdScreen widget
/// {@endtemplate}
class ShowAdScreen extends StatefulWidget {
  /// {@macro show_ad_screen}
  const ShowAdScreen({required this.config, required this.adService, this.cheat = false, super.key});

  final bool cheat;
  final AdUnitConfigAim config;
  final IAdServiceAim adService;

  static Future<bool> showAd(
    BuildContext context, {
    required AdUnitConfigAim config,
    required IPlatformInfo platform,
    required IAdServiceAim adService,
    bool cheat = false,
  }) async {
    final navigator = Navigator.of(context);
    final localization = CustomUiScope.of(context);
    if (!cheat && !platform.platformType.isMobile) {
      // Can not show ads on non-mobile platforms:
      await ErrorModal.onShowModal(
        context,
        localization.ads_are_not_supported_on_this_platform,
      );
      return false;
    }

    debugPrint(' > pushing #ad screen (isTest=${config.isTestAd})');
    final result = await navigator.push(
      CupertinoPageRoute(
        builder: (_) => ShowAdScreen(cheat: cheat, config: config, adService: adService),
      ),
    );
    if (result is bool && result) {
      return result;
    }
    return false;
  }

  @override
  State<ShowAdScreen> createState() => _ShowAdScreenState();
}

/// State for widget ShowAdScreen
class _ShowAdScreenState extends State<ShowAdScreen> {
  late final AdUnitConfigAim config = widget.config;
  bool _adLoaded = false;
  bool _adShown = false;

  /* #region Lifecycle */
  @override
  void initState() {
    super.initState();
    // Initial state initialization
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await _adFlow();
      } finally {
        await Future<void>.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    });
  }

  Future<void> _adFlow() async {
    final navigator = Navigator.of(context);
    await _loadAd();
    if (!mounted) {
      return;
    }
    if (!_adLoaded) {
      navigator.pop(false);
      return;
    }
    await _showAd();
    if (mounted) {
      navigator.pop(_adShown);
    }
  }

  Future<void> _loadAd() async {
    if (widget.cheat) {
      await Future<void>.delayed(const Duration(seconds: 1));
      _adLoaded = true;
    } else {
      if (widget.config.emulateUnableToLoad) {
        await Future<void>.delayed(const Duration(seconds: 10));
        _adLoaded = false;
      } else {
        _adLoaded = await widget.adService.preloadAd(config);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _showAd() async {
    if (widget.cheat) {
      await Future<void>.delayed(const Duration(seconds: 1));
      _adShown = true;
    } else {
      _adShown = await widget.adService.showAd(config);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(ShowAdScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Widget configuration changed
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The configuration of InheritedWidgets has changed
    // Also called after initState but before build
  }

  @override
  void dispose() {
    // Permanent removal of a tree stent
    super.dispose();
  }
  /* #endregion */

  @override
  Widget build(BuildContext context) {
    final localization = CustomUiScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.rewardedAdTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator.adaptive(),
          if (!_adLoaded) Text(localization.tryingToLoadAdMessage),
          if (_adShown) Text(localization.adIsShownMessage),
        ],
      ),
    );
  }
}
