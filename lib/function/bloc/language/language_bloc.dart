import 'package:flutter_tts/flutter_tts.dart';
import '../../../common/constant/default_value.dart';
import '../../../common/prefs/shared_preference.dart';
import 'package:rxdart/rxdart.dart';

class LanguageBloc {
  static LanguageBloc _languageBloc = LanguageBloc();
  static LanguageBloc get languageBloc => _languageBloc;
  static Lang _toLang = Language.EN;
  static Lang _fromLang = Language.EN;

  static final _fromLangBlocSubject = PublishSubject<Lang>();
  static Stream<Lang> get fromLangSteam => _fromLangBlocSubject.stream;

  ///
  static final _toLangBlocSubject = PublishSubject<Lang>();
  static Stream<Lang> get toLangStream => _toLangBlocSubject.stream;

  //
  static final _langUIEnableBlocSubject = PublishSubject<bool>();
  static Stream<bool> get langUIEnableStream =>
      _langUIEnableBlocSubject.stream;

  static Lang get fromLang => _fromLang;
  static Lang get toLang => _toLang;
  FlutterTts _flutterTts = FlutterTts();

  setToLanguage(Lang lang) {
    _toLang = lang;
    _toLangBlocSubject.sink.add(_toLang);
    Prefs.saveString(Prefs.TRANSLATE_LANG_PREFS_KEY, lang.codeForTranslate);

    _flutterTts.isLanguageAvailable(lang.codeForSpeech).then((isSupportSpeech) {
      if (!isSupportSpeech && _toLang.codeForSpeech != "") {
        _toLang = Lang(_toLang.codeForTranslate, "", _toLang.name);
        _toLangBlocSubject.sink.add(_toLang);
      } else if (isSupportSpeech && _toLang.codeForSpeech == "") {
        _toLang =
            Lang(_toLang.codeForTranslate, lang.codeForTranslate, _toLang.name);
        _toLangBlocSubject.sink.add(_toLang);
      }
    });
  }

  setFromLang(Lang lang) {
    _fromLang = lang;
    _fromLangBlocSubject.sink.add(_fromLang);
    Prefs.saveString(Prefs.SCAN_LANG_PREFS_KEY, lang.codeForTranslate);
    _flutterTts.isLanguageAvailable(lang.codeForSpeech).then((isSupportSpeech) {
      if (!isSupportSpeech && _fromLang.codeForSpeech != "") {
        _fromLang = Lang(_toLang.codeForTranslate, "", _toLang.name);
        _fromLangBlocSubject.sink.add(_fromLang);
      } else if (isSupportSpeech && _fromLang.codeForSpeech == "") {
        _fromLang =
            Lang(_toLang.codeForTranslate, lang.codeForTranslate, _toLang.name);
        _fromLangBlocSubject.sink.add(_fromLang);
      }
    });
  }

  setEnableUI(bool isEnable) {
    _langUIEnableBlocSubject.sink.add(isEnable);
  }
}
