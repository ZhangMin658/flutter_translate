import 'package:flutter/material.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(50),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                //color: ColorConstant.BUTTON_MAIN,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  ),
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: ()  {
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Package",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorConstant.ACTIVE_BTNTEXT,
                            ),
                          ),
                          Text(
                            "GO",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorConstant.ACTIVE_BTNTEXT,
                            ),
                          ),],
                      )
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                //color: ColorConstant.BUTTON_MAIN,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  ),
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: ()  {
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Restore",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorConstant.ACTIVE_BTNTEXT,
                            ),
                          ),
                          Text(
                            "GO",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorConstant.ACTIVE_BTNTEXT,
                            ),
                          ),],
                      )
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                //color: ColorConstant.BUTTON_MAIN,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  ),
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: ()  {
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Website",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorConstant.ACTIVE_BTNTEXT,
                            ),
                          ),
                          Text(
                            "GO",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorConstant.ACTIVE_BTNTEXT,
                            ),
                          ),],
                      )
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                //color: ColorConstant.BUTTON_MAIN,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  ),
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: ()  {
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Privacy",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorConstant.ACTIVE_BTNTEXT,
                            ),
                          ),
                          Text(
                            "GO",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorConstant.ACTIVE_BTNTEXT,
                            ),
                          ),],
                      )
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                //color: ColorConstant.BUTTON_MAIN,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  ),
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: ()  {
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Terms&Conditions",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorConstant.ACTIVE_BTNTEXT,
                            ),
                          ),
                          Text(
                            "GO",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorConstant.ACTIVE_BTNTEXT,
                            ),
                          ),],
                      )
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                //color: ColorConstant.BUTTON_MAIN,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  ),
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: SizedBox(
                  height: 30,
                  width: double.infinity,
                  child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: ()  {
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Support",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorConstant.ACTIVE_BTNTEXT,
                            ),
                          ),
                          Text(
                            "GO",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorConstant.ACTIVE_BTNTEXT,
                            ),
                          ),],
                      )
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
