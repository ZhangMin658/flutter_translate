import 'package:equatable/equatable.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

abstract class ScannerState extends Equatable {}

class InitialScannerState extends ScannerState {
  @override
  List<Object> get props => [];
}

class ScanningState extends ScannerState {
  @override
  List<Object> get props => null;
}

class ScannedState extends ScannerState {
  final VisionText visionTextScanned;
  ScannedState(this.visionTextScanned);

  @override
  List<Object> get props => [visionTextScanned];
}

class TranslatingStateState extends ScannerState {
  final String textScanned;
  TranslatingStateState(this.textScanned);

  @override
  List<Object> get props => [textScanned];
}

class TranslatedStateState extends ScannerState {
  final String textTranslated;
  final String textScanned;
  TranslatedStateState({this.textScanned, this.textTranslated});

  @override
  List<Object> get props => [textScanned, textTranslated];
}

class NeedUpdatePremiumState extends ScannerState {
  @override
  List<Object> get props => [];
}
