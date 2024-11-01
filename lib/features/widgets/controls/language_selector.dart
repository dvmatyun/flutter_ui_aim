// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum Language {
  english('en', 'england', 'English'),
  russian('ru', 'russia', 'Русский');

  final String value;
  final String fileName;
  final String name;
  final String path;
  const Language(this.value, this.fileName, this.name) : path = 'packages/custom_ui/$_svgPath/$fileName.svg';

  static Language fromString(String value) {
    final valueAdjusted = value.length > 2 ? value.substring(0, 2).toLowerCase() : value.toLowerCase();
    switch (valueAdjusted) {
      case 'ru':
        return Language.russian;
      default:
        return Language.english;
    }
  }

  static const _svgPath = 'assets/svg/flags';
}

@immutable
class KeyValueModel<T> {
  final String key;
  final T value;

  const KeyValueModel({required this.key, required this.value});

  @override
  bool operator ==(Object other) {
    return other is KeyValueModel && key == other.key;
  }

  @override
  int get hashCode => key.hashCode;
}

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({required this.chosenLanguage, required this.onChanged, super.key});

  final Language chosenLanguage;
  final ValueChanged<Language> onChanged;

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  KeyValueModel<Language>? chosenValue;
  late final List<KeyValueModel<Language>> dropdownValues;

  @override
  void initState() {
    dropdownValues = Language.values.map((e) => KeyValueModel<Language>(key: e.value, value: e)).toList();
    chosenValue = KeyValueModel<Language>(key: widget.chosenLanguage.value, value: widget.chosenLanguage);
    //Store.I.appBaseService.settingsService.changeLanguage(widget.chosenLanguage);
    super.initState();
    //final store = Store.I.base.changeUserSettings(newSetting);
    // Initial state initialization
  }

  @override
  void didUpdateWidget(LanguageDropdown oldWidget) {
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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
        child: CustomDropdown(
          uniqueStringKey: 'language',
          width: 128,
          icon: const Icon(
            Icons.arrow_drop_down,
            size: 32,
            color: Colors.white,
          ),
          chosenKey: chosenValue,
          keyValueList: dropdownValues,
          onChanged: (keyvalue) {
            if (keyvalue is KeyValueModel<Language>) {
              widget.onChanged(keyvalue.value);
            }

            //Store.I.appBaseService.settingsService.changeLanguage(Language.fromString(keyvalue.key));
          },
          builder: (KeyValueModel? e) {
            final model = e is KeyValueModel<Language>
                ? e
                : KeyValueModel<Language>(key: Language.english.value, value: Language.english);
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(model.value.name),
                const SizedBox(width: 4),
                SizedBox(
                  width: 128,
                  child: SvgPicture.asset(
                    height: 64,
                    Language.fromString(model.key).path,
                  ),
                ),
              ],
            );
          },
        ),
      );
}

@immutable
class CustomDropdown<T> extends StatefulWidget {
  const CustomDropdown({
    required this.uniqueStringKey,
    required this.width,
    required this.keyValueList,
    required this.chosenKey,
    required this.builder,
    required this.onChanged,
    this.isLocked = false,
    this.icon = const Icon(
      Icons.arrow_drop_down,
      size: 16,
      color: Colors.white,
    ),
    Key? key,
  }) : super(key: key);

  final double width;
  final List<KeyValueModel<T>> keyValueList;
  final KeyValueModel<T>? chosenKey;
  final Widget Function(KeyValueModel? model) builder;
  final void Function(KeyValueModel) onChanged;
  final Widget icon;
  final String uniqueStringKey;
  final bool isLocked;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  KeyValueModel<T>? chosenKey;
  OverlayEntry? _overlayEntry;
  late final GlobalKey _key;
  late Offset buttonPosition;
  Size buttonSize = const Size(256, 64);
  bool isMenuOpen = false;
  final offsetToLeft = true;

  @override
  void initState() {
    _key = LabeledGlobalKey('button_icon_${widget.uniqueStringKey}');
    chosenKey = widget.chosenKey;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    closeMenu();
    super.dispose();
  }

  void findButton() {
    final renderObject = _key.currentContext?.findRenderObject();
    if (renderObject != null) {
      final translation = renderObject.getTransformTo(null).getTranslation();
      buttonPosition = Offset(translation.x, translation.y);
      final Rect? bounds = renderObject.paintBounds.shift(buttonPosition);
      buttonSize = bounds?.size ?? const Size(256, 64);
    }
  }

  void closeMenu() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      isMenuOpen = !isMenuOpen;
    }
  }

  void openMenu() {
    findButton();
    _overlayEntry = _overlayEntryBuilder();
    final overlay = Overlay.of(context);
    if (_overlayEntry != null) {
      overlay.insert(_overlayEntry!);
    }
    isMenuOpen = !isMenuOpen;
  }

  OverlayEntry _overlayEntryBuilder() {
    final theme = Theme.of(context);
    //final renderObject = _key.currentContext?.findRenderObject();

    return OverlayEntry(
      builder: (context) => Positioned(
        top: buttonPosition.dy + buttonSize.height,
        left: buttonPosition.dx, //- (widget.width * (offsetToLeft ? 1 : (-1))),
        //???width: widget.width,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  for (var i = 0; i < widget.keyValueList.length; i++)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withOpacity(0.8),
                      ),
                      child: SizedBox(
                        width: buttonSize.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: getDropDownChoice(i),
                        ),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getDropDownChoice(int i) => InkWell(
        onTap: () {
          chooseDropDownValue(widget.keyValueList[i]);
        },
        child: widget.builder(widget.keyValueList[i]),
      );

  void chooseDropDownValue(KeyValueModel<T> keyValueModel) {
    closeMenu();
    setState(() {
      chosenKey = keyValueModel;
    });
    widget.onChanged(keyValueModel);
  }

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints(minWidth: widget.width),
        child: IconButton(
          key: _key,
          onPressed: () {
            if (widget.isLocked) {
              return;
            }
            if (isMenuOpen) {
              closeMenu();
            } else {
              openMenu();
            }
          },
          icon: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: (chosenKey != null) ? widget.builder(chosenKey!) : widget.builder(null),
              ),
              if (widget.isLocked) const SizedBox.shrink() else widget.icon
            ],
          ),
        ),
      );
}
