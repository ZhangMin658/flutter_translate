import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class PickerScannerState extends Equatable {}

class NoImageSelectedState extends PickerScannerState {
  @override
  List<Object> get props => null;
}

class ViewSelectedState extends PickerScannerState {
  final File imageScan;
  ViewSelectedState(this.imageScan);

  @override
  List<Object> get props => [imageScan];
}

class CropImageSelectedState extends PickerScannerState {
  final File imageScan;
  CropImageSelectedState(this.imageScan);

  @override
  List<Object> get props => [imageScan];
}

class TextScanningState extends PickerScannerState {
  final File imageScan;
  TextScanningState(this.imageScan);

  @override
  List<Object> get props => [imageScan];
}
