import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import '../../../function/bloc/language/language_bloc.dart';
import '../../../function/common/model/translate_respose_obj.dart';
import '../../../function/common/server/translate_client_api.dart';
import 'package:rxdart/rxdart.dart';

class LiveDetectionBloc {
  VisionText _visionText;
  TranslationResponse _translationResponse;
  final _translateApi = TranslateApi();

  final _liveDetectionBlocSubject = PublishSubject<VisionText>();
  Stream<VisionText> get liveDetectionStream =>
      _liveDetectionBlocSubject.stream;

  final _liveTranslateBlocSubject = PublishSubject<TranslationResponse>();
  Stream<TranslationResponse> get liveTranslateStream =>
      _liveTranslateBlocSubject.stream;

  VisionText get visionText => _visionText;
  TranslationResponse get translationResponse => _translationResponse;

  updateNewVisionText(VisionText visionText) {
    if (_visionText != null && _visionText.text != visionText.text) {
      _liveDetectionBlocSubject.sink.add(visionText);
      _visionText = visionText;
    }
    if (_visionText == null) {
      _liveDetectionBlocSubject.sink.add(visionText);
      _visionText = visionText;
    }
  }

  updateNewTranslateText(bool isTranslate) async {
    if (isTranslate) {
      TranslationResponse translationResponse =
          await _translateApi.translateText(
              toLang: LanguageBloc.toLang.codeForTranslate,
              text: _visionText.text);
      _translationResponse = translationResponse;
      _liveTranslateBlocSubject.sink.add(translationResponse);
    } else {
      _liveTranslateBlocSubject.sink.add(null);
    }
  }
}
