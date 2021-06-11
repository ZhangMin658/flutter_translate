import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class TakephotoState extends Equatable {}

class InitialTakephotoState extends TakephotoState {
  @override
  List<Object> get props => [];
}

class CameraOverViewState extends TakephotoState {
  @override
  List<Object> get props => null;
}

class ImageTakingState extends TakephotoState {
  @override
  List<Object> get props => null;
}

class ImageTakedState extends TakephotoState {
  final File image;
  ImageTakedState(this.image);

  @override
  List<Object> get props => [image];
}
