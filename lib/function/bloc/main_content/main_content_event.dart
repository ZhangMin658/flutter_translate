import 'package:equatable/equatable.dart';

abstract class MainContentEvent extends Equatable {
  const MainContentEvent();
}

class OpenLiveScanEvent extends MainContentEvent {
  @override
  List<Object> get props => null;
}

class OpenCameraScanEvent extends MainContentEvent {
  @override
  List<Object> get props => null;
}

class OpenImageScanEvent extends MainContentEvent {
  @override
  List<Object> get props => null;
}

class OpenHistoryScanEvent extends MainContentEvent {
  @override
  List<Object> get props => null;
}
