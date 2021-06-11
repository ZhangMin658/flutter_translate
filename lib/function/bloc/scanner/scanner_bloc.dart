import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import '../../../common/constant/default_value.dart';
import '../../../common/prefs/shared_preference.dart';
import '../../../function/bloc/language/language_bloc.dart';
import '../../../function/common/model/translate_respose_obj.dart';
import '../../../function/common/server/translate_client_api.dart';
import '../../../function/utils/firebase_vision.dart';
import '../../../function/utils/my_iap.dart';
import '../bloc.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  MyFirebaseVision _myFirebaseVision = MyFirebaseVision();
  final _translateApi = TranslateApi();
  int _numScanned = 0;

  @override
  ScannerState get initialState => InitialScannerState();

  @override
  Stream<ScannerState> mapEventToState(
    ScannerEvent event,
  ) async* {
    if (event is ScanTextEvent) {
      yield ScanningState();
      _numScanned =
          await Prefs.getInt(Prefs.NUM_SCAN_PREFS_KEY, defaultValue: 0);
      if (_numScanned >= DefaultValue.NUM_SCAN_FREE &&
          !MyIAP.iap.isPremiumUserAvalible) {
        yield NeedUpdatePremiumState();
      } else {
        //call scantext
        VisionText visionText = await _myFirebaseVision.scanImageByFile(
            event.imageScan, LanguageBloc.fromLang);
        //String textScanned = visionText.text;
        //await Future.delayed(Duration(milliseconds: 3000), () {});

        yield ScannedState(visionText);
      }
    }

    if (event is TranslateTextEvent) {
      yield TranslatingStateState(event.textScanned);
      //call translate text
      //await Future.delayed(Duration(milliseconds: 5000), () {});

      TranslationResponse translationResponse =
          await _translateApi.translateText(
              toLang: LanguageBloc.toLang.codeForTranslate,
              text: event.textScanned);
      String textTranslated =
          translationResponse.translatedText.replaceAll(". ", ".\n");
      textTranslated = textTranslated.replaceAll(": ", ":\n");
      _numScanned++;
      await Prefs.saveInt(Prefs.NUM_SCAN_PREFS_KEY, _numScanned);
      yield TranslatedStateState(
        textScanned: event.textScanned,
        textTranslated: textTranslated,
      );
    }
  }

  void dispose() {
    _myFirebaseVision.dispose();
    super.close();
  }
}
