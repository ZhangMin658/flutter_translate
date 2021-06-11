import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;

class ImageConvert {
  static Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static imglib.Image convertCameraImageToImageColor(CameraImage image) {
    if (image.format.group == ImageFormatGroup.bgra8888) {
      return convertBGRA8888toImageColor(image);
    } else if (image.format.group == ImageFormatGroup.yuv420) {
      return convertYUV420toImageColor(image);
    } else {
      throw Exception("unkown format group");
    }
  }

  static Future<String> convertYUV420toBase64(CameraImage image,
      {Rect cropRect: const Rect.fromLTRB(0, 0, 0, 0)}) async {
    try {
      final width = image.width;
      final height = image.height;
      final uvRowStride = image.planes[1].bytesPerRow;
      // MEMO: null(iPhone XS Plus)
      final uvPixelStride = image.planes[1].bytesPerPixel ?? 1;

      print('uvRowStride: $uvRowStride');
      print('uvPixelStride: $uvPixelStride');

      // imgLib -> Image package from https://pub.dartlang.org/packages/image
      final img = imglib.Image(width, height); // Create Image buffer

      // Fill image buffer with plane[0] from YUV420_888
      for (var x = 0; x < width; x++) {
        for (var y = 0; y < height; y++) {
          final uvIndex =
              uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
          final index = y * width + x;

          final yp = image.planes[0].bytes[index];
          final up = image.planes[1].bytes[uvIndex];
          // MEMO: image.planes' length is 2(iPhone XS Plus)
          final vp =
              image.planes.length > 2 ? image.planes[2].bytes[uvIndex] : 0;
          // Calculate pixel color
          final r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255).toInt();
          final g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
              .round()
              .clamp(0, 255)
              .toInt();
          final b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255).toInt();
          // color: 0x FF  FF  FF  FF
          //           A   B   G   R
          img.data[index] = (0xFF << 24) | (b << 16) | (g << 8) | r;
        }
      }
      var imgCroped = img;
      if (cropRect.left.floor() < cropRect.right.floor()) {
        imgCroped = imglib.copyCrop(
          img,
          cropRect.left.floor(),
          cropRect.top.floor(),
          cropRect.bottom.floor() - cropRect.top.floor(),
          cropRect.right.floor() - cropRect.left.floor(),
        );
      }
      imglib.PngEncoder pngEncoder = new imglib.PngEncoder(level: 0, filter: 0);
      List<int> png = pngEncoder.encodeImage(imgCroped);
      return base64Encode(png);
    } catch (e) {
      print(">>>>>>>>>>>> ERROR:" + e.toString());
    }
    return null;
  }

  static imglib.Image convertYUV420toImageColor(CameraImage image) {
    final int width = image.width;
    final int height = image.height;
    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel;

    const alpha255 = (0xFF << 24);

    // imgLib -> Image package from https://pub.dartlang.org/packages/image
    final img = imglib.Image(width, height); // Create Image buffer

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex =
            uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
        final int index = y * width + x;

        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        img.data[index] = alpha255 | (b << 16) | (g << 8) | r;
      }
    }
    return img;
  }

  static imglib.Image convertBGRA8888toImageColor(CameraImage image) {
    final result = imglib.Image.fromBytes(
      image.width,
      image.height,
      image.planes[0].bytes,
      format: imglib.Format.bgra,
    );
    return result;
  }
}
