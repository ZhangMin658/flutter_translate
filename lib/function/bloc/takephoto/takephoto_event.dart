import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

abstract class TakephotoEvent extends Equatable {}

class ShowCameraOverViewEvent extends TakephotoEvent {
  @override
  List<Object> get props => null;
}

class ShowImageTakedEvent extends TakephotoEvent {
  final CameraController cameraController;
  ShowImageTakedEvent(this.cameraController);

  @override
  List<Object> get props => [cameraController];
}
