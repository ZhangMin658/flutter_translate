import 'dart:convert';

import 'package:scan_and_translate/common/constant/server_constant.dart';
import 'package:scan_and_translate/common/server/base_api_client.dart';
import 'package:scan_and_translate/function/common/model/translate_respose_obj.dart';

class TranslateApi extends BaseApiClient {
  //for only instance _client inititial
  static final _client = TranslateApi._();
  //constructer private
  TranslateApi._();
  //return just only a instance
  factory TranslateApi() => _client;

  Future<TranslationResponse> translateText(
      {String toLang, String text}) async {
    var url = Uri.https(
        ServerConstant.URL_TRANSLATE,
        ServerConstant.TRANSLATE_PATH,
        {'target': toLang, 'key': ServerConstant.API_KEY, 'q': text});
    TranslationResponse translationResponse;
    await super.getResponse(url).then((response) {
      if (response.statusCode >= 200 && response.statusCode <= 300) {
        var result = json.decode(response.body);
        var data = result["data"];
        List<dynamic> translations = data["translations"];
        if (translations != null && translations.length > 0) {
          translationResponse = TranslationResponse.fromJson(translations[0]);
        }
      }
    });
    return translationResponse;
  }
}
