import 'package:scan_and_translate/common/model/base_model.dart';

class TranslationResponse extends BaseModel {
  String translatedText;
  String detectedSourceLanguage;
  TranslationResponse({this.translatedText, this.detectedSourceLanguage});
  @override
  Map<String, dynamic> toJson() {
    return {
      "translatedText": translatedText,
      "detectedSourceLanguage": detectedSourceLanguage
    };
  }

  factory TranslationResponse.fromJson(Map<String, dynamic> json) =>
      TranslationResponse(
        translatedText: json["translatedText"],
        detectedSourceLanguage: json["detectedSourceLanguage"],
      );
}
