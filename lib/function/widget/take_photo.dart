import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/function/bloc/action/action_bloc.dart';
import 'package:scan_and_translate/function/bloc/bloc.dart';
import 'package:scan_and_translate/function/widget/Image_picker.dart';
import 'package:scan_and_translate/function/widget/camera.dart';

//import 'package:image/image.dart' as imglib;

class TakePhoto extends StatefulWidget {
  @override
  _TakePhotoState createState() {
    return _TakePhotoState();
  }
}

class _TakePhotoState extends State<TakePhoto> {
  TakephotoBloc _takephotoBloc;
  List<FloatingActionButton> _actionButtons;
  FloatingActionButton _actionTakePhoto;
  CameraController _cameraController;
  //imglib.Image _image;
  //bool _isTakePhoto = false;
  CameraScanner _cameraScanner;

  @override
  void initState() {
    _takephotoBloc = TakephotoBloc();
    _takephotoBloc.add(ShowCameraOverViewEvent());

    _actionButtons = List<FloatingActionButton>();
    _actionButtons.clear();
    _actionTakePhoto = FloatingActionButton(
      heroTag: "Take photo",
      backgroundColor: ColorConstant.FLOATTING_MAIN,
      mini: true,
      child: Icon(Icons.camera_enhance),
      onPressed: () {
        _takePhotoFromCamera();
      },
    );
    _actionButtons.add(_actionTakePhoto);
    _cameraScanner = CameraScanner(
      onCameraControlerInited: _onCameraInitedCallBack,
    );
    super.initState();
  }

  @override
  void dispose() {
    _takephotoBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ActionBloc.actionBloc.setActions(_actionButtons);
    return BlocBuilder(
      bloc: _takephotoBloc,
      builder: _bodyBlocBuild,
    );
  }

  Widget _bodyBlocBuild(BuildContext context, TakephotoState state) {
    if (state is InitialTakephotoState ||
        state is CameraOverViewState ||
        state is ImageTakingState) {
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _cameraScanner,
          (state is ImageTakingState)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(),
        ],
      );
    }

    if (state is ImageTakedState) {
      return ImagePickerScanner(
        imageFile: state.image,
        onBackCallback: _onResetTakePhoto,
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  _onResetTakePhoto() {
    _takephotoBloc.add(ShowCameraOverViewEvent());
    _actionButtons.clear();
    _actionButtons.add(_actionTakePhoto);
    ActionBloc.actionBloc.setActions(_actionButtons);
  }

  _onCameraInitedCallBack(CameraController cameraController) {
    _cameraController = cameraController;
    //_setStreamCamera();
  }

  _takePhotoFromCamera() async {
    _takephotoBloc.add(ShowImageTakedEvent(_cameraController));
  }
}
