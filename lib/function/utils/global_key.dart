import 'package:flutter/material.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';

//
GlobalKey<ScaffoldState> mainScaffoldKey = GlobalKey<ScaffoldState>();
showNotification({String textNoti}) {
  mainScaffoldKey.currentState.showSnackBar(
    new SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: ColorConstant.INACTIVE_TEXT,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      content: InkWell(
        child: Row(
          children: <Widget>[
            Icon(Icons.info_outline),
            Expanded(
              child: Text(
                textNoti,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 1,
              width: 10,
            ),
          ],
        ),
        onTap: () {
          mainScaffoldKey.currentState.removeCurrentSnackBar();
        },
      ),
    ),
  );
}
