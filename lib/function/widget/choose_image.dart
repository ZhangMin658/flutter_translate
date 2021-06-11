import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';
import 'package:scan_and_translate/function/bloc/action/action_bloc.dart';
import 'package:scan_and_translate/function/bloc/bloc.dart';
import 'package:scan_and_translate/function/bloc/chooseimage/chooseimage_bloc.dart';
import 'Image_picker.dart';

class ChooseImage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChooseImageState();
  }
}

class _ChooseImageState extends State<ChooseImage> {
  ChooseimageBloc _chooseimageBloc;
  List<FloatingActionButton> _actionButtons;
  FloatingActionButton _chooseImageAction;

  @override
  void initState() {
    _chooseimageBloc = ChooseimageBloc();

    _actionButtons = List<FloatingActionButton>();
    _chooseImageAction = FloatingActionButton(
      heroTag: "Choose image",
      backgroundColor: Colors.redAccent,
      mini: true,
      child: Icon(Icons.photo),
      onPressed: () {
        _chooseimageBloc?.add(ShowImageChoosingEvent());
      },
    );

    _chooseimageBloc.add(ShowNoImageChoosedEvent());
    super.initState();
  }

  @override
  void dispose() {
    _chooseimageBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _chooseimageBloc,
      builder: _bodyBlocBuild,
    );
  }

  Widget _bodyBlocBuild(BuildContext context, ChooseimageState state) {
    if (state is InitialChooseimageState || state is NoImageChoosedState) {
      return _buildNoImageSelected();
    }
    if (state is ImageChoosingState) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state is ImageChoosedState) {
      return ImagePickerScanner(
        imageFile: state.image,
        onBackCallback: _onResetChooseImage,
      );
    }
    return Center();
  }

  _buildNoImageSelected() {
    _actionButtons.clear();
    _actionButtons.add(_chooseImageAction);
    ActionBloc.actionBloc.setActions(_actionButtons);
    return Container(
      alignment: Alignment.center,
      child: Card(
        //color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.photo_size_select_large,
                  size: ScreenSizeConfig.blockSizeHorizontal * 10,
                  color: ColorConstant.BUTTON_MAIN,
                ),
                Container(
                  margin:
                      EdgeInsets.all(ScreenSizeConfig.blockSizeHorizontal * 5),
                  child: Text(
                    "Select image to scan",
                    style: TextStyle(
                      color: ColorConstant.BUTTON_MAIN,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              _chooseimageBloc?.add(ShowImageChoosingEvent());
            },
          ),
        ),
      ),
    );
  }

  _onResetChooseImage() {
    _chooseimageBloc.add(ShowNoImageChoosedEvent());
  }
}
