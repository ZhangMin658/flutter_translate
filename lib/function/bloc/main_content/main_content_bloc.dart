import 'dart:async';
import 'package:bloc/bloc.dart';
import '../bloc.dart';

class MainContentBloc extends Bloc<MainContentEvent, MainContentState> {
  @override
  MainContentState get initialState => InitialMainContentState();

  @override
  Stream<MainContentState> mapEventToState(
    MainContentEvent event,
  ) async* {
    if (event is OpenLiveScanEvent) {
      yield LiveScanInited();
    }
    if (event is OpenCameraScanEvent) {
      yield CameraScanInited();
    }
    if (event is OpenImageScanEvent) {
      yield ImageScanInited();
    }
    if (event is OpenHistoryScanEvent) {
      yield HistoryScanInited();
    }
  }
}
