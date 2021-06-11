import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:scan_and_translate/common/constant/default_value.dart';
import 'package:scan_and_translate/common/util/screen_size_config.dart';
import 'package:scan_and_translate/function/bloc/camera/camera_bloc.dart';

class CameraScanner extends StatefulWidget {
  final Function(CameraController) onCameraControlerInited;
  final Function(ImageRotation) onImageRotationInited;
  CameraScanner({this.onCameraControlerInited, this.onImageRotationInited});
  @override
  _CameraScannerState createState() {
    return _CameraScannerState(
        onCameraControlerInited: onCameraControlerInited,
        onImageRotationInited: onImageRotationInited);
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraScannerState extends State<CameraScanner>
    with WidgetsBindingObserver {
  List<CameraDescription> _cameras;
  CameraController _cameraController;
  Function(CameraController) onCameraControlerInited;
  Function(ImageRotation) onImageRotationInited;
  CameraBloc _cameraBloc;
  ResolutionPreset _cameraResolution;

  ImageRotation _rotation;

  CameraDescription _description;
  Size _cameraiImageSize;
  _CameraScannerState(
      {this.onCameraControlerInited, this.onImageRotationInited});

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _cameraBloc = CameraBloc();
    if (Platform.isAndroid) {
      _cameraResolution = DefaultValue.CAMERA_RESOLUTION_ANDROID;
    } else {
      _cameraResolution = DefaultValue.CAMERA_RESOLUTION_IOS;
    }
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //_cameraController?.stopImageStream();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_cameraController == null || !_cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (_cameraController != null) {
        _initCamera();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        StreamBuilder(
          stream: _cameraBloc.cameraStream,
          initialData: false,
          builder: (context, snapshoot) {
            if (snapshoot.hasData && snapshoot.data) {
              return _buildCameraPreview(context);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
      ],
    );
  }

  Widget _buildCameraPreview(BuildContext context) {
    return Positioned.fill(
      child: AspectRatio(
        aspectRatio: _cameraController.value.aspectRatio,
        child: CameraPreview(_cameraController),
      ),
    );
  }

  double _getImageZoom(MediaQueryData data) {
    final double logicalWidth = data.size.width;
    final double logicalHeight = ScreenSizeConfig.screenHeight /
        ScreenSizeConfig.screenWidth *
        logicalWidth;

    final EdgeInsets padding = data.padding;
    final double maxLogicalHeight =
        data.size.height - padding.top - padding.bottom;

    return maxLogicalHeight / logicalHeight;
  }

  CameraController getCameraController() => _cameraController;

  _initCamera() async {
    if (_cameras == null) {
      _cameras = await availableCameras();
    }
    _description = await getCamera(CameraLensDirection.back);
    _rotation = rotationIntToImageRotation(
      _description.sensorOrientation,
    );
    if (onImageRotationInited != null) {
      onImageRotationInited(_rotation);
    }
    //

    if (_cameraController != null) {
      await _cameraController.dispose();
    }
    _cameraController =
        CameraController(_description, _cameraResolution, enableAudio: false);

    // If the controller is updated then update the UI.
    _cameraController.addListener(() {
      if (mounted) setState(() {});
      if (_cameraController.value.hasError) {
        print('Camera error ${_cameraController.value.errorDescription}');
      }
    });

    try {
      await _cameraController?.initialize();
    } on CameraException catch (e) {
      //_showCameraException(e);
      print("Camera error: $e");
    }

    if (mounted) {
      _cameraiImageSize = Size(
        _cameraController.value.previewSize.height,
        _cameraController.value.previewSize.width,
      );
      _cameraBloc.setCameraStateInited(true);
      if (_cameraController != null) onCameraControlerInited(_cameraController);
    }
  }

  Future<CameraDescription> getCamera(CameraLensDirection dir) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      return await availableCameras().then(
        (List<CameraDescription> cameras) => cameras.firstWhere(
          (CameraDescription camera) => camera.lensDirection == dir,
        ),
      );
    } on CameraException catch (e) {
      logError(e.code, e.description);
      return null;
    }
  }

  ImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 0:
        return ImageRotation.rotation0;
      case 90:
        return ImageRotation.rotation90;
      case 180:
        return ImageRotation.rotation180;
      default:
        assert(rotation == 270);
        return ImageRotation.rotation270;
    }
  }
}
