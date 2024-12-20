// rewarded_bonus_aim -> ca-app-pub-1936932210079972/9615379646
class AdUnitConfigAim {
  final String name;
  final String adUnitId;
  final bool isTestAd;

  final int loadAttempts;
  final int loadAttemptIndex;

  final bool emulateUnableToLoad;

  const AdUnitConfigAim({
    required this.name,
    required this.adUnitId,
    this.isTestAd = false,
    this.loadAttemptIndex = 1,
    this.loadAttempts = 5,
    this.emulateUnableToLoad = false,
  });

  AdUnitConfigAim copyWith({
    String? name,
    String? adUnitId,
    bool? isTestAd,
    int? loadAttempts,
    int? loadAttemptIndex,
    bool? emulateUnableToLoad,
  }) {
    return AdUnitConfigAim(
      name: name ?? this.name,
      adUnitId: adUnitId ?? this.adUnitId,
      isTestAd: isTestAd ?? this.isTestAd,
      loadAttempts: loadAttempts ?? this.loadAttempts,
      loadAttemptIndex: loadAttemptIndex ?? this.loadAttemptIndex,
      emulateUnableToLoad: emulateUnableToLoad ?? this.emulateUnableToLoad,
    );
  }
}
