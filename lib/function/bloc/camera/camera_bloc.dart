import 'package:rxdart/rxdart.dart';

class CameraBloc {
  final _cameraBlocSubject = PublishSubject<bool>();
  Stream<bool> get cameraStream => _cameraBlocSubject.stream;

  setCameraStateInited(bool isEnable) {
    _cameraBlocSubject.sink.add(isEnable);
  }
}
