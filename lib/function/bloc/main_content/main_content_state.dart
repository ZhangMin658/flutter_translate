import 'package:equatable/equatable.dart';

abstract class MainContentState extends Equatable {
  const MainContentState();
}

class InitialMainContentState extends MainContentState {
  @override
  List<Object> get props => [];
}

class LiveScanInited extends MainContentState {
  @override
  List<Object> get props => null;
}

class CameraScanInited extends MainContentState {
  @override
  List<Object> get props => null;
}

class ImageScanInited extends MainContentState {
  @override
  List<Object> get props => null;
}

class HistoryScanInited extends MainContentState {
  @override
  List<Object> get props => null;
}
