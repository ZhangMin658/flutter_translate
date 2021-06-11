import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc.dart';

class ChooseimageBloc extends Bloc<ChooseimageEvent, ChooseimageState> {
  @override
  ChooseimageState get initialState => InitialChooseimageState();

  @override
  Stream<ChooseimageState> mapEventToState(
    ChooseimageEvent event,
  ) async* {
    if (event is ShowNoImageChoosedEvent) {
      yield NoImageChoosedState();
    }

    if (event is ShowImageChoosingEvent) {
      yield ImageChoosingState();

      final File image =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        yield ImageChoosedState(image);
      } else {
        yield NoImageChoosedState();
      }
    }
  }
}
