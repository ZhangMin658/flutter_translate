import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scan_and_translate/common/constant/default_value.dart';

class MyFirebaseVision {
  TextRecognizer _recognizer;
  TextRecognizer _recognizerCloud;
  MyFirebaseVision() {
    _recognizer = FirebaseVision.instance.textRecognizer();
    _recognizerCloud = FirebaseVision.instance.cloudTextRecognizer();
  }
  Future<dynamic> getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;

    return imageSize;
  }

  Future<VisionText> scanImageByFile(File imageFile, Lang lang) async {
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);
    VisionText results;
    //For Chinese, Japanese, and Korean text (only supported by the cloud-based APIs)
    if (lang == Language.JA ||
        lang == Language.ZH_CN ||
        lang == Language.ZH_TW ||
        lang == Language.KO) {
      results = await _recognizerCloud.processImage(visionImage);
    } else {
      results = await _recognizer.processImage(visionImage);
    }
    return results;
  }

  Future<VisionText> scanImageByImg(
      CameraImage image, ImageRotation rotation, Lang lang) async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromBytes(
      concatenatePlanes(image.planes),
      buildMetaData(image, rotation),
    );
    VisionText results;
    //For Chinese, Japanese, and Korean text (only supported by the cloud-based APIs)
    if (lang == Language.JA ||
        lang == Language.ZH_CN ||
        lang == Language.ZH_TW ||
        lang == Language.KO) {
      results = await _recognizerCloud.processImage(visionImage);
    } else {
      results = await _recognizer.processImage(visionImage);
    }
    return results;
  }

  Uint8List concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    planes.forEach((Plane plane) => allBytes.putUint8List(plane.bytes));
    return allBytes.done().buffer.asUint8List();
  }

  FirebaseVisionImageMetadata buildMetaData(
    CameraImage image,
    ImageRotation rotation,
  ) {
    return FirebaseVisionImageMetadata(
      rawFormat: image.format.raw,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      planeData: image.planes.map(
        (Plane plane) {
          return FirebaseVisionImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );
  }

  void dispose() {
    _recognizer.close();
  }
}
