import 'package:scan_and_translate/common/model/base_model.dart';

class HistoryObj extends BaseModel {
  String id;
  String scanLangCode;
  String scanText;
  String translateLangCode;
  String translateText;
  String dateTime;

  static String generateId() =>
      new DateTime.now().millisecondsSinceEpoch.toString();

  HistoryObj(
      {this.scanLangCode,
      this.scanText,
      this.translateLangCode,
      this.translateText,
      this.dateTime}) {
    this.id = generateId();
  }
  HistoryObj.fromId(
      {this.id,
      this.scanLangCode,
      this.scanText,
      this.translateLangCode,
      this.translateText,
      this.dateTime});

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "scan_lang_code": this.scanLangCode,
      "scan_text": this.scanText,
      "translate_lang_code": this.translateLangCode,
      "translate_text": this.translateText,
      "date_time": this.dateTime
    };
  }

  factory HistoryObj.fromJson(Map<String, dynamic> mapJson) =>
      HistoryObj.fromId(
        id: mapJson["id"],
        scanLangCode: mapJson["scan_lang_code"],
        scanText: mapJson["scan_text"],
        translateLangCode: mapJson["translate_lang_code"],
        translateText: mapJson["translate_text"],
        dateTime: mapJson["date_time"],
      );
}
