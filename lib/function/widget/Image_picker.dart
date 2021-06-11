import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_villains/villain.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:scan_and_translate/common/constant/color_constant.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';
import 'package:scan_and_translate/function/bloc/action/action_bloc.dart';
import 'package:scan_and_translate/function/bloc/bloc.dart';
import 'package:scan_and_translate/function/utils/global_key.dart';
import 'package:scan_and_translate/function/widget/scanner.dart';

class ImagePickerScanner extends StatefulWidget {
  final Function() onBackCallback;
  final File imageFile;
  ImagePickerScanner({this.onBackCallback, this.imageFile});
  @override
  State<StatefulWidget> createState() {
    return _ImagePickerScannerState(
        onBackCallback: onBackCallback, imageFile: imageFile);
  }
}

class _ImagePickerScannerState extends State<ImagePickerScanner> {
  Function() onBackCallback;
  File imageFile;
  _ImagePickerScannerState({this.onBackCallback, this.imageFile});
  PickerScannerBloc _pickerScannerBloc;
  List<FloatingActionButton> _actionButtons;
  FloatingActionButton _cropImageAction;
  FloatingActionButton _scanImageAction;
  FloatingActionButton _removeImageAction;

  @override
  void initState() {
    _pickerScannerBloc = PickerScannerBloc();
    _actionButtons = List<FloatingActionButton>();
    _removeImageAction = FloatingActionButton(
      heroTag: "Remove image",
      backgroundColor: Colors.grey,
      mini: true,
      child: Icon(Icons.delete_sweep),
      onPressed: () {
        print("Remove image click");
        if (onBackCallback != null) {
          onBackCallback();
        }
      },
    );
    _pickerScannerBloc.add(ShowImageSelectedEvent(imageFile));
    super.initState();
  }

  @override
  void dispose() {
    _pickerScannerBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Alert
    _notificationSelectLanguage();
    return Villain(
      villainAnimation: VillainAnimation.scale(
        fromScale: 0.0,
        toScale: 1.0,
        from: Duration(milliseconds: 100),
        to: Duration(milliseconds: 500),
      ),
      animateExit: true,
      secondaryVillainAnimation: VillainAnimation.fade(),
      child: BlocBuilder(
        bloc: _pickerScannerBloc,
        builder: _bodyBlocBuild,
      ),
    );
  }

  Widget _bodyBlocBuild(BuildContext context, PickerScannerState state) {
    if (state is NoImageSelectedState) {
      _actionButtons.clear();
      _actionButtons.add(
        FloatingActionButton(
          heroTag: "Back choose image",
          backgroundColor: Colors.lightBlueAccent[700],
          mini: true,
          child: Icon(Icons.arrow_back_ios),
          onPressed: () {
            onBackCallback();
          },
        ),
      );
      ActionBloc.actionBloc.setActions(_actionButtons);
      return Center(
        child: Icon(
          Icons.broken_image,
          size: ScreenSizeConfig.blockSizeHorizontal * 10,
          color: ColorConstant.INACTIVE_TEXT,
        ),
      );
    }
    if (state is ViewSelectedState) {
      return _buildViewSelectedImage(state.imageScan);
    }
    if (state is CropImageSelectedState) {
      return _buildCropingImage(state.imageScan);
    }
    if (state is TextScanningState) {
      return _buildScanner(state.imageScan);
    }
    return Center();
  }

  _buildViewSelectedImage(File image) {
    _cropImageAction = FloatingActionButton(
      heroTag: "Crop image",
      backgroundColor: Colors.pinkAccent,
      mini: true,
      child: Icon(Icons.crop),
      onPressed: () {
        print("Crop image click");
        _cropImage(image);
        //_pickerScannerBloc?.add(ShowCropImageSelectedEvent(image));
      },
    );
    _scanImageAction = FloatingActionButton(
      heroTag: "Scan text",
      backgroundColor: Colors.green,
      mini: true,
      child: Icon(Icons.scanner),
      onPressed: () {
        print("Scan text click");
        _pickerScannerBloc?.add(ShowScannerEvent(image));
      },
    );

    _actionButtons.clear();
    _actionButtons.add(_removeImageAction);
    _actionButtons.add(_cropImageAction);
    _actionButtons.add(_scanImageAction);

    ActionBloc.actionBloc.setActions(_actionButtons);

    //build UI
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.file(
            image,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  _buildCropingImage(File image) {
    _actionButtons.clear();
    _actionButtons.add(
      FloatingActionButton(
        heroTag: "Cropped",
        backgroundColor: Colors.lightGreen,
        mini: true,
        child: Icon(Icons.check),
        onPressed: () {
          print("Cropped click");
          _cropImage(image);
        },
      ),
    );
    ActionBloc.actionBloc.setActions(_actionButtons);
    return Container(
      alignment: Alignment.center,
      child: Text("For Crop screen render using other libs")
    );
  }

  _buildScanner(File image) {
    return Scanner(
      imageFile: image,
      backCallback: _screenScannerBackCallback,
    );
  }

  _screenScannerBackCallback() {
    if (onBackCallback != null) {
      onBackCallback();
    }
  }

  Future<void> _cropImage(File image) async {

    final file = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        ));

    _pickerScannerBloc.add(ShowImageSelectedEvent(file));
  }

  _notificationSelectLanguage() async {
    await Future.delayed(Duration(milliseconds: 1000), () {});
    showNotification(
        textNoti:
            "For Chinese, Japanese, and Korean text please select language-scan for accurate return results");
  }
}
