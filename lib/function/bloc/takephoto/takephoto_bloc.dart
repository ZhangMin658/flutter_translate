import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import '../bloc.dart';

class TakephotoBloc extends Bloc<TakephotoEvent, TakephotoState> {
  @override
  TakephotoState get initialState => InitialTakephotoState();

  @override
  Stream<TakephotoState> mapEventToState(
    TakephotoEvent event,
  ) async* {
    if (event is ShowCameraOverViewEvent) {
      yield CameraOverViewState();
    }
    if (event is ShowImageTakedEvent) {
      yield ImageTakingState();

      final imagePath =
          (await getTemporaryDirectory()).path + '${DateTime.now()}.png';
      final CameraController cameraController = event.cameraController;

      await cameraController.takePicture(imagePath);
      final File image = File(imagePath);
      final File imageRotated = await rotateAndCompressAndSaveImage(image);
      if (imageRotated != null) {
        yield ImageTakedState(imageRotated);
      } else {
        yield CameraOverViewState();
      }
    }
  }

  Future<File> rotateAndCompressAndSaveImage(File image) async {
    int rotate = 0;
    List<int> imageBytes = await image.readAsBytes();
    //Map<String, IfdTag> exifData = await readExifFromBytes(imageBytes);

    // if (exifData != null &&
    //     exifData.isNotEmpty &&
    //     exifData.containsKey("Image Orientation")) {
    //   IfdTag orientation = exifData["Image Orientation"];
    //   int orientationValue = orientation.values[0];

    //   if (orientationValue == 3) {
    //     rotate = 180;
    //   }

    //   if (orientationValue == 6) {
    //     rotate = -90;
    //   }

    //   if (orientationValue == 8) {
    //     rotate = 90;
    //   }
    // }
    if (Platform.isIOS) {
      rotate = 0;
    }

    List<int> result = await FlutterImageCompress.compressWithList(imageBytes,
        quality: 100, rotate: rotate);

    await image.writeAsBytes(result);

    return image;
  }
}
