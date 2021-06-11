import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import '../bloc.dart';

class PickerScannerBloc extends Bloc<PickerScannerEvent, PickerScannerState> {
  @override
  PickerScannerState get initialState => NoImageSelectedState();

  @override
  Stream<PickerScannerState> mapEventToState(
    PickerScannerEvent event,
  ) async* {
    if (event is ShowImageSelectedEvent) {
      File imageScan = event.imageScan;
      if (imageScan == null) {
        yield NoImageSelectedState();
      } else {
        yield ViewSelectedState(imageScan);
      }
    }
    if (event is ShowCropImageSelectedEvent) {
      File imageScan = event.imageScan;
      yield CropImageSelectedState(imageScan);
    }

    if (event is ShowScannerEvent) {
      File imageScan = event.imageScan;
      yield TextScanningState(imageScan);
    }
  }
}
