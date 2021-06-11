import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/common/constant/default_value.dart';
import 'package:scan_and_translate/common/util/app_orientation.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';
import 'package:scan_and_translate/function/common/model/history_obj.dart';

import 'global_key.dart';

class SendMail {
  static void sendMailTo({String emailTo, String bodyStr}) async {
    final Email email = Email(
      body: bodyStr,
      subject: 'Scan Everything ${DateTime.now()}',
      recipients: [emailTo],
      //cc: ['cc@example.com'],
      //bcc: ['bcc@example.com'],
      //attachmentPath: '/path/to/attachment.zip',
    );

    await FlutterEmailSender.send(email);
    showNotification(textNoti: "Sent");
  }

  static void showBottomSheetInputMail({BuildContext context, String bodyStr}) {
    TextEditingController txtEmailController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: ColorConstant.BAR_MAIN,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(bc).viewInsets.bottom),
            child: Wrap(
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 5,
                      ),
                      SizedBox(
                        height: ScreenSizeConfig.blockSizeVertical * 5,
                        width: ScreenSizeConfig.blockSizeHorizontal * 80,
                        child: TextFormField(
                          controller: txtEmailController,
                          maxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.start,
                          autofocus: true,
                          style: TextStyle(
                            color: ColorConstant.FLOATTING_MAIN,
                          ),
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              labelText: "Input email send to",
                              labelStyle: TextStyle(
                                color: ColorConstant.INACTIVE_TEXT,
                              ),
                              prefixIcon: Icon(
                                Icons.email,
                                color: ColorConstant.BUTTON_MAIN,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: txtEmailController.text != ""
                                        ? Colors.white
                                        : Colors.white),
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                borderSide: BorderSide(
                                    width: 1,
                                    color: txtEmailController.text != ""
                                        ? Colors.red
                                        : ColorConstant.BUTTON_MAIN),
                              ),
                              contentPadding: EdgeInsets.all(5)),
                        ),
                      ),
                      SizedBox(
                        height: ScreenSizeConfig.blockSizeHorizontal * 8,
                        child: FlatButton(
                          child: Text(
                            "Send this email",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorConstant.BUTTON_MAIN,
                            ),
                          ),
                          onPressed: () {
                            //send main
                            Navigator.pop(bc);
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            AppOrientation.setFullScreenApp();
                            sendMailTo(
                                bodyStr: bodyStr,
                                emailTo: txtEmailController.text.trim());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String buildBodyEmailByList(List<HistoryObj> listHistory) {
    String mixStr = "";
    int idx = 1;
    listHistory.forEach((historyObj) {
      String scanLangName =
          Language.getLangByCode(historyObj.scanLangCode).name;
      String translateLangName =
          Language.getLangByCode(historyObj.translateLangCode).name;

      String colStr = row.replaceAll("%sLANGFROM", scanLangName);
      colStr = colStr.replaceAll("%sLANGTRANSLATE", translateLangName);
      colStr = colStr.replaceAll("%sTEXTFROM", historyObj.scanText);
      colStr = colStr.replaceAll("%sTEXTTRANSLATE", historyObj.translateText);
      colStr = colStr.replaceAll("%sNUMBER", idx.toString());
      mixStr += colStr;
      idx++;
    });
    return header + mixStr + footer;
  }

  static String buildBodyEmailByTranslate(
      {String formLang, String toLang, String txtFrom, String txtTranslate}) {
    String mixStr = row.replaceAll("%sLANGFROM", formLang);
    mixStr = mixStr.replaceAll("%sLANGTRANSLATE", toLang);
    mixStr = mixStr.replaceAll("%sTEXTFROM", txtFrom);
    mixStr = mixStr.replaceAll("%sTEXTTRANSLATE", txtTranslate);
    mixStr = mixStr.replaceAll("%sNUMBER", "01");
    return header + mixStr + footer;
  }

  static String header =
      "\n#=============================================#\n#-| RESURT SENT BY ABC MOBILE APP |-#\n#=============================================#\n\n\n";
  static String row =
      "\n\n#=|  %sNUMBER  |=============\n\n|---[ %sLANGFROM ]\n\n%sTEXTFROM\n\n|----[ %sLANGTRANSLATE ]\n\n%sTEXTTRANSLATE\n\n|===============\n";
  static String footer =
      "\n\n\n\n#============\n#--[ By the way, we are here ]\n#--[ @Dev. inc ]\n#--[ https://www.abc.com ]\n#============\n";
}
