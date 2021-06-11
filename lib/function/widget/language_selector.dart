import 'package:flutter/material.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/common/constant/default_value.dart';
import 'package:scan_and_translate/common/prefs/shared_preference.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';
import 'package:scan_and_translate/function/bloc/language/language_bloc.dart';

class LanguageSelector extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LanguageSelectorState();
  }
}

class _LanguageSelectorState extends State<LanguageSelector> {
  @override
  void initState() {
    LanguageBloc.languageBloc
        .setFromLang(Language.getLangByCode(Language.EN.codeForTranslate));

    Prefs.getString(Prefs.SCAN_LANG_PREFS_KEY,
            defalutValue: Language.EN.codeForTranslate)
        .then((code) {
      LanguageBloc.languageBloc.setFromLang(Language.getLangByCode(code));
    });

    //
    LanguageBloc.languageBloc
        .setToLanguage(Language.getLangByCode(Language.EN.codeForTranslate));
    Prefs.getString(Prefs.TRANSLATE_LANG_PREFS_KEY,
            defalutValue: Language.EN.codeForTranslate)
        .then((code) {
      LanguageBloc.languageBloc.setToLanguage(Language.getLangByCode(code));
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: true,
        stream: LanguageBloc.langUIEnableStream,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data) {
            return Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  //From
                  Expanded(
                    child: StreamBuilder(
                      initialData: LanguageBloc.fromLang,
                      stream: LanguageBloc.fromLangSteam,
                      builder: (context, AsyncSnapshot<Lang> snapshot) {
                        if (snapshot.hasData) {
                          return _buildLanguageSelect(
                              _changedFromLang, snapshot.data);
                        } else {
                          return Center();
                        }
                      },
                    ),
                  ),
                  //c
                  Container(
                    margin: EdgeInsets.only(
                      right: ScreenSizeConfig.blockSizeHorizontal * 0,
                      left: ScreenSizeConfig.blockSizeHorizontal * 0,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.navigate_next,
                        color: ColorConstant.BUTTON_MAIN,
                        // size: ScreenSizeConfig.blockSizeVertical * 5,
                      ),
                    ),
                  ),
                  //To
                  Expanded(
                    child: StreamBuilder(
                      initialData: LanguageBloc.toLang,
                      stream: LanguageBloc.toLangStream,
                      builder: (context, AsyncSnapshot<Lang> snapshot) {
                        if (snapshot.hasData) {
                          return _buildLanguageSelect(
                              _changedToLang, snapshot.data);
                        } else {
                          return Center();
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.folder_open,
                    size: 20,
                    color: ColorConstant.FLOATTING_MAIN,
                  ),
                  Container(
                    width: 5,
                  ),
                  Text(
                    "Storage",
                    style: TextStyle(
                      color: ColorConstant.FLOATTING_MAIN,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Container(
                    width: 20,
                  ),
                ],
              ),
            );
          }
        });
  }

  Widget _buildLanguageSelect(Function(Lang) changedItem, Lang valueSelected) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: ColorConstant.BAR_MAIN,
      ),
      child: Container(
        width: ScreenSizeConfig.blockSizeHorizontal * 30,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: ColorConstant.FLOATTING_MAIN,
          ),
          borderRadius:
              BorderRadius.circular(ScreenSizeConfig.safeBlockHorizontal * 10),
        ),
        padding: EdgeInsets.only(
          left: ScreenSizeConfig.safeBlockHorizontal * 3,
          right: ScreenSizeConfig.safeBlockHorizontal * 3,
          top: ScreenSizeConfig.safeBlockHorizontal * 0,
          bottom: ScreenSizeConfig.safeBlockHorizontal * 0,
        ),
        margin: EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        child: DropdownButton(
          value: valueSelected,
          items: _dropDownMenuItems(valueSelected),
          onChanged: changedItem,
          isExpanded: true,
          style: TextStyle(
            color: ColorConstant.FLOATTING_MAIN,
            //fontSize: ScreenSizeConfig.safeBlockHorizontal * 3,
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: ColorConstant.BACKGROUND,
            //size: ScreenSizeConfig.safeBlockHorizontal * 5,
          ),
          elevation: 2,
          underline: Center(),
        ),
      ),
    );
  }

  List<DropdownMenuItem<Lang>> _dropDownMenuItems(Lang valueSelected) {
    List<DropdownMenuItem<Lang>> items = new List<DropdownMenuItem<Lang>>();
    Language.LIST_LANGUAGE.forEach((lang) {
      items.add(
        new DropdownMenuItem(
          value: lang,
          child: Container(
            alignment: Alignment.center,
            //width: ScreenSizeConfig.blockSizeHorizontal * 28,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                lang.name,
                style: TextStyle(
                  color: lang == valueSelected
                      ? ColorConstant.BUTTON_MAIN
                      : ColorConstant.BACKGROUND,
                  //fontSize: ScreenSizeConfig.safeBlockVertical * 2,
                ),
              ),
            ),
          ),
        ),
      );
    });
    return items;
  }

  void _changedFromLang(Lang selectedItem) {
    LanguageBloc().setFromLang(selectedItem);
  }

  void _changedToLang(Lang selectedItem) {
    LanguageBloc().setToLanguage(selectedItem);
  }
}
