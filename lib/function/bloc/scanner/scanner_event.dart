import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ScannerEvent extends Equatable {}

class ScanTextEvent extends ScannerEvent {
  final File imageScan;
  ScanTextEvent(this.imageScan);

  @override
  List<Object> get props => [imageScan];
}

class TranslateTextEvent extends ScannerEvent {
  final String textScanned;
  TranslateTextEvent(this.textScanned);

  @override
  List<Object> get props => [textScanned];
}
