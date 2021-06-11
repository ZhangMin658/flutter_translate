import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class PickerScannerEvent extends Equatable {}

//class ShowNoImageSelectedEvent extends PickerScannerEvent {}

class ShowImageSelectedEvent extends PickerScannerEvent {
  final File imageScan;
  ShowImageSelectedEvent(this.imageScan);

  @override
  List<Object> get props => [imageScan];
}

class ShowCropImageSelectedEvent extends PickerScannerEvent {
  final File imageScan;
  ShowCropImageSelectedEvent(this.imageScan);

  @override
  List<Object> get props => [imageScan];
}

class ShowScannerEvent extends PickerScannerEvent {
  final File imageScan;
  ShowScannerEvent(this.imageScan);

  @override
  List<Object> get props => [imageScan];
}
