import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class ChooseimageState extends Equatable {}

class InitialChooseimageState extends ChooseimageState {
  @override
  List<Object> get props => [];
}

class NoImageChoosedState extends ChooseimageState {
  @override
  List<Object> get props => null;
}

class ImageChoosingState extends ChooseimageState {
  @override
  List<Object> get props => null;
}

class ImageChoosedState extends ChooseimageState {
  final File image;
  ImageChoosedState(this.image);

  @override
  List<Object> get props => [image];
}
