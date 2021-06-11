import 'dart:io';
import 'dart:typed_data';

import '../util/image_convert.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;
import 'package:image/image.dart';

class PreProcessedImageData {
  final Size originalSize;
  final Uint8List preProccessedImageBytes;

  PreProcessedImageData._(this.originalSize, this.preProccessedImageBytes);

  factory PreProcessedImageData(CameraImage camImg) {
    final rawRgbImage = ImageConvert.convertCameraImageToImageColor(camImg);
    final rgbImage = // camera plugin on Android sucks
        Platform.isAndroid
            ? imglib.copyRotate(
                rawRgbImage,
                90,
              )
            : rawRgbImage;
    return PreProcessedImageData._(
      Size(rgbImage.width.toDouble(), rgbImage.height.toDouble()),
      rgbImage.getBytes(format: Format.rgb),
    );
  }
}
