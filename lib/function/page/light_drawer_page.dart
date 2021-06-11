import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animation_set/animation_set.dart';
import 'package:flutter_animation_set/animator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_villains/villain.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';
import 'package:scan_and_translate/function/bloc/action/action_bloc.dart';
import 'package:scan_and_translate/function/bloc/bloc.dart';
import 'package:scan_and_translate/function/bloc/language/language_bloc.dart';
import 'package:scan_and_translate/function/utils/global_key.dart';
import 'package:scan_and_translate/function/widget/choose_image.dart';
import 'package:scan_and_translate/function/widget/drawer_info.dart';
import 'package:scan_and_translate/function/widget/fancy_bottom_navigation.dart';
import 'package:scan_and_translate/function/widget/float_menu.dart';
import 'package:scan_and_translate/function/widget/language_selector.dart';
import 'package:scan_and_translate/function/widget/live_scan.dart';
import 'package:scan_and_translate/function/widget/storage.dart';
import 'package:scan_and_translate/function/widget/take_photo.dart';

class LightDrawerPage extends StatefulWidget {
  @override
  _LightDrawerPageState createState() {
    return _LightDrawerPageState();
  }
}

class _LightDrawerPageState extends State<LightDrawerPage> {
  MainContentBloc _mainContentBloc;

  @override
  void initState() {
    _mainContentBloc = MainContentBloc();
    _mainContentBloc.add(OpenCameraScanEvent());
    //_mainContentBloc.add(OpenHistoryScanEvent());

    super.initState(); 
  }

  @override
  void dispose() {
    _mainContentBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int idx = 1;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Villain(
        villainAnimation: VillainAnimation.scale(
          fromScale: 0.0,
          toScale: 1.0,
          from: Duration(milliseconds: 100),
          to: Duration(milliseconds: 500),
        ),
        animateExit: true,
        secondaryVillainAnimation: VillainAnimation.fade(),
        child:
            //App Content
            Column(
          children: <Widget>[
            Expanded(
              child: Scaffold(
                key: mainScaffoldKey,
                //extendBody: true,
                /// main app bar
                appBar: AppBar(
                  //title: Text('Ligh Drawer Navigation')
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: _buildCenterTitle(),
                ),
                //Drawer app info

                ///Body pages
                body: BlocBuilder(
                  bloc: _mainContentBloc,
                  builder: _bodyBlocBuild,
                ),

                ///Floating actions
                ///
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endDocked,
                floatingActionButton: _buildNewFloatingActionButton(),
                bottomNavigationBar: BottomAppBar(
                  clipBehavior: Clip.none,

                  //elevation: 9.0,
                  notchMargin: 2.0,
                  elevation: 4.0,
                  color: Colors.lightBlueAccent[700],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 40,
                        margin: EdgeInsets.only(bottom: 35),
                        child: _buildBottomNavigation(idx),
                      )
                    ],
                  ),
                ),
                //
              ),
            ),
            Container(
              height: 1,
              color: Colors.lightBlueAccent[700],
            ),
          ],
        ),
      ),
    );
  }

  ///Floating action menu
  ///
  _buildNewFloatingActionButton() {
    return StreamBuilder(
      initialData: ActionBloc.listAction,
      stream: ActionBloc.actionSteam,
      builder: (context, AsyncSnapshot<List<FloatingActionButton>> snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          if (snapshot.data.length == 1) {
            return Villain(
                villainAnimation: VillainAnimation.scale(
                  fromScale: 0.0,
                  toScale: 1.0,
                  from: Duration(milliseconds: 100),
                  to: Duration(milliseconds: 500),
                ),
                animateExit: true,
                secondaryVillainAnimation: VillainAnimation.fade(),
                child: snapshot.data[0]);
          } else {
            return FloatMenu(
              listFloatingAction: snapshot.data,
            );
          }
        } else {
          return Container(
            width: 0.001,
            height: 0.001,
          );
        }
      },
    );
  }

  Widget _buildBottomNavigation(int idx) {
    return FancyBottomNavigation(
      currentIndex: idx,
      backgroundColor: Colors.lightBlueAccent[700],
      activeColor: ColorConstant.BUTTON_MAIN,
      inactiveColor: Colors.white,
      items: <FancyBottomNavigationItem>[
        FancyBottomNavigationItem(
            icon: Icon(Icons.camera_enhance),
            title: Text(
              'Live scan',
              textAlign: TextAlign.center,
            )),
        FancyBottomNavigationItem(
            icon: Icon(Icons.center_focus_strong),
            title: Text(
              'Camera scan',
              textAlign: TextAlign.center,
            )),
        FancyBottomNavigationItem(
            icon: Icon(Icons.wallpaper),
            title: Text(
              'Image picker',
              textAlign: TextAlign.center,
            )),
        // FancyBottomNavigationItem(
        //     icon: Icon(Icons.history),
        //     title: Text(
        //       'History',
        //       textAlign: TextAlign.center,
        //     )),
      ],
      onItemSelected: _onTabSelected,
    );
  }

  Widget _buildCenterTitle() {
    return Container(
      alignment: Alignment.center,
      child: LanguageSelector(),
    );
  }

  _buildDrawer() {
    //final String image = images[0];
    return DrawerInfo();
  }

  Widget _bodyBlocBuild(BuildContext context, MainContentState state) {
    if (state is InitialMainContentState || state is CameraScanInited) {
      LanguageBloc.languageBloc.setEnableUI(true);

      return TakePhoto();
    }
    if (state is LiveScanInited) {
      LanguageBloc.languageBloc.setEnableUI(true);
      return LiveScan();
    }
    if (state is ImageScanInited) {
      LanguageBloc.languageBloc.setEnableUI(true);
      return ChooseImage();
    }
    if (state is HistoryScanInited) {
      LanguageBloc.languageBloc.setEnableUI(false);
      return StorageHistory();
    }

    return Center();
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit an App'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  _onTabSelected(indexTab) {
    switch (indexTab) {
      case 0:
        _mainContentBloc?.add(OpenLiveScanEvent());
        break;
      case 1:
        _mainContentBloc?.add(OpenCameraScanEvent());
        break;

      case 2:
        _mainContentBloc?.add(OpenImageScanEvent());
        break;
      case 3:
        _mainContentBloc?.add(OpenHistoryScanEvent());
        break;
      default:
        _mainContentBloc?.add(OpenCameraScanEvent());
    }
  }
}
