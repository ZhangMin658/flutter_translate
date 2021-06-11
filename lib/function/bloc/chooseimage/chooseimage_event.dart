import 'package:equatable/equatable.dart';

abstract class ChooseimageEvent extends Equatable {
  //ChooseimageEvent([List props = const <dynamic>[]]) : super(props);
}

class ShowNoImageChoosedEvent extends ChooseimageEvent {
  @override
  List<Object> get props => null;
}

class ShowImageChoosingEvent extends ChooseimageEvent {
  @override
  List<Object> get props => null;
}
