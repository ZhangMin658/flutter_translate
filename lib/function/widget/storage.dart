import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_villains/villain.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/common/constant/default_value.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';
import 'package:scan_and_translate/function/bloc/action/action_bloc.dart';
import 'package:scan_and_translate/function/bloc/bloc.dart';
import 'package:scan_and_translate/function/common/database/translate_history.dart';
import 'package:scan_and_translate/function/common/model/history_obj.dart';
import 'package:scan_and_translate/function/utils/global_key.dart';
import 'package:scan_and_translate/function/utils/send_mail.dart';
import 'package:scan_and_translate/function/widget/animation.dart';

class StorageHistory extends StatefulWidget {
  @override
  _StorageHistoryState createState() {
    return _StorageHistoryState();
  }
}

class _StorageHistoryState extends State<StorageHistory> {
  HistoryBloc _historyBloc;
  List<FloatingActionButton> _actionHistoryButtons;
  @override
  void initState() {
    _historyBloc = HistoryBloc();
    _historyBloc.add(ShowStogareHistoryEvent());
    _actionHistoryButtons = List<FloatingActionButton>();
    super.initState();
  }

  @override
  void dispose() {
    _historyBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _actionHistoryButtons.clear();
    ActionBloc.actionBloc.setActions(_actionHistoryButtons);
    return Villain(
      villainAnimation: VillainAnimation.scale(
        fromScale: 0.0,
        toScale: 1.0,
        from: Duration(milliseconds: 100),
        to: Duration(milliseconds: 500),
      ),
      animateExit: true,
      secondaryVillainAnimation: VillainAnimation.fade(),
      child: Container(
        margin: EdgeInsets.all(ScreenSizeConfig.blockSizeHorizontal),
        child: BlocBuilder(
          bloc: _historyBloc,
          builder: _bodyBlocBuild,
        ),
      ),
    );
  }

  Widget _bodyBlocBuild(BuildContext context, HistoryState state) {
    if (state is InitialHistoryState || state is LoadingHistoryState) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state is EmptyHistoryState) {
      return _buildHistoryEmpty();
    }
    if (state is LoadedHistoryState) {
      return _buildListHistoryItems(context, state.listHistory);
    }
    if (state is DetailHistoryState) {
      return _buildDetailHistory(state.historyObj);
    }
    return Center();
  }

  _buildHistoryEmpty() {
    _actionHistoryButtons.clear();
    // if (!_actionButtons.contains(_pickImageAction)) {
    //   _actionButtons.add();
    // }
    ActionBloc.actionBloc.setActions(_actionHistoryButtons);
    return Container(
      alignment: Alignment.center,
      child: Card(
        //color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.import_contacts,
              size: ScreenSizeConfig.blockSizeHorizontal * 10,
              color: ColorConstant.BUTTON_MAIN,
            ),
            Container(
              margin: EdgeInsets.all(ScreenSizeConfig.blockSizeHorizontal * 5),
              child: Text(
                "Stogare is empty",
                style: TextStyle(
                  color: ColorConstant.BUTTON_MAIN,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildListHistoryItems(BuildContext context, List<HistoryObj> listHistory) {
    _actionHistoryButtons.clear();
    _actionHistoryButtons.add(
      FloatingActionButton(
        heroTag: "Remove all history",
        backgroundColor: Colors.lightBlueAccent[700],
        mini: true,
        child: Icon(Icons.delete_forever),
        onPressed: () {
          _showBottomSheetComfimRemoveAll(context);
        },
      ),
    );
    _actionHistoryButtons.add(
      FloatingActionButton(
        heroTag: "Share history action",
        backgroundColor: Colors.purpleAccent,
        mini: true,
        child: Icon(Icons.save_alt),
        onPressed: () {
          //_callTranslateText(_txtScannedController.text.trim());
          //SendMail.sendMailToMySelf("bodyStr", "date");
          SendMail.showBottomSheetInputMail(
              context: context,
              bodyStr: SendMail.buildBodyEmailByList(listHistory));
        },
      ),
    );

    ActionBloc.actionBloc.setActions(_actionHistoryButtons);

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          _buildHistoryItem(listHistory.elementAt(index), index),
      itemCount: listHistory.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
    );
  }

  _buildHistoryItem(HistoryObj historyObj, int position) {
    DateTime dateTime = DateTime.parse(historyObj.dateTime);
    String timeStr =
        "${dateTime.hour}:${dateTime.second} ${dateTime.day}/${dateTime.month}/${dateTime.year}";
    return FadeIn(
      delay: 0.6 * position,
      translateXBegin: 20.0,
      translateXEnd: 0,
      child: Dismissible(
        // Specify the direction to swipe and delete
        direction: DismissDirection.endToStart,
        key: Key(historyObj.id),
        onDismissed: (direction) {
          // Removes that item the list on swipwe
          TranslateHistoryDB.translateHistoryDB.delete(historyObj.id, "id");
        },
        background: Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(right: 10),
          child: Icon(
            Icons.delete_sweep,
            color: Colors.red,
          ),
        ),
        child: Container(
          margin:
              EdgeInsets.only(bottom: ScreenSizeConfig.blockSizeVertical * 1),
          height: ScreenSizeConfig.blockSizeVertical * 18,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: ColorConstant.BAR_MAIN,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(
                              ScreenSizeConfig.blockSizeVertical),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  historyObj.scanText,
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  style: TextStyle(
                                    color: ColorConstant.ACTIVE_TEXT,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(5),
                                width: 1,
                                color: ColorConstant.INACTIVE_TEXT,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  historyObj.translateText,
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 4,
                                  style: TextStyle(
                                    color: ColorConstant.ACTIVE_TEXT,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 30,
                        margin: EdgeInsets.only(
                          left: ScreenSizeConfig.blockSizeVertical * 0.5,
                          right: ScreenSizeConfig.blockSizeVertical * 0.5,
                          bottom: ScreenSizeConfig.blockSizeVertical * 0.5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            //language
                            Container(
                              padding: EdgeInsets.only(
                                left: ScreenSizeConfig.safeBlockVertical * 0.5,
                                right: ScreenSizeConfig.safeBlockVertical * 0.5,
                                top: 0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: ColorConstant.INACTIVE_TEXT,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.flag,
                                    color: ColorConstant.INACTIVE_TEXT,
                                    size: 20,
                                  ),
                                  Container(
                                    width: ScreenSizeConfig.safeBlockHorizontal,
                                  ),
                                  Text(
                                    "${historyObj.scanLangCode}",
                                    style: TextStyle(
                                      color: ColorConstant.INACTIVE_TEXT,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //>
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: ColorConstant.INACTIVE_TEXT,
                            ),
                            //lang
                            Container(
                              padding: EdgeInsets.only(
                                left: ScreenSizeConfig.safeBlockVertical * 0.5,
                                right: ScreenSizeConfig.safeBlockVertical * 0.5,
                                top: 0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: ColorConstant.INACTIVE_TEXT,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.flag,
                                    color: ColorConstant.INACTIVE_TEXT,
                                    size: 20,
                                  ),
                                  Container(
                                    width: ScreenSizeConfig.safeBlockHorizontal,
                                  ),
                                  Text(
                                    "${historyObj.translateLangCode}",
                                    style: TextStyle(
                                      color: ColorConstant.INACTIVE_TEXT,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //space
                            Expanded(
                              child: Center(),
                            ),
                            //date
                            Container(
                              padding: EdgeInsets.only(
                                left: ScreenSizeConfig.safeBlockVertical * 0.5,
                                right: ScreenSizeConfig.safeBlockVertical * 0.5,
                                top: 0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: ColorConstant.INACTIVE_TEXT,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    color: ColorConstant.INACTIVE_TEXT,
                                    size: 20,
                                  ),
                                  Container(
                                    width: ScreenSizeConfig.safeBlockHorizontal,
                                  ),
                                  Text(
                                    "$timeStr",
                                    style: TextStyle(
                                      color: ColorConstant.INACTIVE_TEXT,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        //Tap item
                        _historyBloc.add(ShowDetailHistoryEvent(historyObj));
                      },
                      child: Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildDetailHistory(HistoryObj historyObj) {
    DateTime dateTime = DateTime.parse(historyObj.dateTime);
    String timeStr =
        "${dateTime.hour}:${dateTime.second} ${dateTime.day}/${dateTime.month}/${dateTime.year}";

    _actionHistoryButtons.clear();
    _actionHistoryButtons.add(
      FloatingActionButton(
        heroTag: "Back history",
        backgroundColor: Colors.lightBlueAccent[700],
        mini: true,
        child: Icon(Icons.arrow_back),
        onPressed: () {
          _historyBloc.add(ShowStogareHistoryEvent());
        },
      ),
    );
    //ActionBloc.actionBloc.setActions(_actionHistoryButtons);

    _actionHistoryButtons.add(
      FloatingActionButton(
        heroTag: "Share history item",
        backgroundColor: Colors.purple,
        mini: true,
        child: Icon(Icons.save_alt),
        onPressed: () {
          SendMail.showBottomSheetInputMail(
              context: context,
              bodyStr: SendMail.buildBodyEmailByTranslate(
                formLang: Language.getLangByCode(historyObj.scanLangCode).name,
                toLang:
                    Language.getLangByCode(historyObj.translateLangCode).name,
                txtFrom: historyObj.scanText,
                txtTranslate: historyObj.translateText,
              ));
        },
      ),
    );

    ActionBloc.actionBloc.setActions(_actionHistoryButtons);

    return FadeIn(
      delay: 0.6,
      translateXBegin: 20.0,
      translateXEnd: 0,
      child: Container(
        margin: EdgeInsets.only(bottom: ScreenSizeConfig.blockSizeVertical * 2),
        //height: ScreenSizeConfig.blockSizeVertical * 15,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          color: ColorConstant.BAR_MAIN,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  height: 30,
                  margin: EdgeInsets.only(
                    left: ScreenSizeConfig.blockSizeVertical * 0.5,
                    right: ScreenSizeConfig.blockSizeVertical * 0.5,
                    top: ScreenSizeConfig.blockSizeVertical * 0.5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //language
                      Container(
                        padding: EdgeInsets.only(
                          left: ScreenSizeConfig.safeBlockVertical * 0.5,
                          right: ScreenSizeConfig.safeBlockVertical * 0.5,
                          top: 0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: ColorConstant.BUTTON_MAIN,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.flag,
                              color: ColorConstant.BUTTON_MAIN,
                              size: 20,
                            ),
                            Container(
                              width: ScreenSizeConfig.safeBlockHorizontal,
                            ),
                            Text(
                              "${historyObj.scanLangCode}",
                              style: TextStyle(
                                color: ColorConstant.BUTTON_MAIN,
                              ),
                            ),
                          ],
                        ),
                      ),

                      //>
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: ColorConstant.BUTTON_MAIN,
                      ),
                      //lang
                      Container(
                        padding: EdgeInsets.only(
                          left: ScreenSizeConfig.safeBlockVertical * 0.5,
                          right: ScreenSizeConfig.safeBlockVertical * 0.5,
                          top: 0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: ColorConstant.BUTTON_MAIN,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.flag,
                              color: ColorConstant.BUTTON_MAIN,
                              size: 20,
                            ),
                            Container(
                              width: ScreenSizeConfig.safeBlockHorizontal,
                            ),
                            Text(
                              "${historyObj.translateLangCode}",
                              style: TextStyle(
                                color: ColorConstant.BUTTON_MAIN,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //space
                      Expanded(
                        child: Center(),
                      ),
                      //date
                      Container(
                        padding: EdgeInsets.only(
                          left: ScreenSizeConfig.safeBlockVertical * 0.5,
                          right: ScreenSizeConfig.safeBlockVertical * 0.5,
                          top: 0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: ColorConstant.BUTTON_MAIN,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              color: ColorConstant.BUTTON_MAIN,
                              size: 20,
                            ),
                            Container(
                              width: ScreenSizeConfig.safeBlockHorizontal,
                            ),
                            Text(
                              "$timeStr",
                              style: TextStyle(
                                color: ColorConstant.BUTTON_MAIN,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //
                Divider(
                  color: ColorConstant.INACTIVE_TEXT,
                ),
                //Text content
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(ScreenSizeConfig.blockSizeVertical),
                    alignment: Alignment.topCenter,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: SingleChildScrollView(
                            child: Text(
                              historyObj.scanText,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: ColorConstant.ACTIVE_TEXT,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          width: 1,
                          color: ColorConstant.INACTIVE_TEXT,
                        ),
                        Expanded(
                          flex: 1,
                          child: SingleChildScrollView(
                            child: Text(
                              historyObj.translateText,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: ColorConstant.ACTIVE_TEXT,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Confirm info 0000000

  _showBottomSheetComfimRemoveAll(BuildContext context) {
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
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
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
                        height: 8,
                      ),
                      Text(
                        "Do you want remove all history?",
                        style: TextStyle(color: ColorConstant.ACTIVE_TEXT),
                      ),
                      Container(
                        height: 5,
                      ),
                      SizedBox(
                        height: ScreenSizeConfig.blockSizeHorizontal * 8,
                        child: FlatButton(
                          child: Text(
                            "Yes",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorConstant.BUTTON_MAIN,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(bc);
                            TranslateHistoryDB.translateHistoryDB
                                .deleteAll()
                                .then((onValue) {
                              _historyBloc.add(ShowStogareHistoryEvent());
                              showNotification(textNoti: "Removed all history");
                            });
                          },
                        ),
                      ),
                      Container(
                        height: 8,
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
}
