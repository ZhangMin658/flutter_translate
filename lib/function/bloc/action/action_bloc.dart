import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ActionBloc {
  static List<FloatingActionButton> _listAction = List<FloatingActionButton>();
  static ActionBloc _actionBloc = ActionBloc();
  static ActionBloc get actionBloc => _actionBloc;
  static List<FloatingActionButton> get listAction => _listAction;

  static final _actionBlocSubject =
      PublishSubject<List<FloatingActionButton>>();
  static Stream<List<FloatingActionButton>> get actionSteam =>
      _actionBlocSubject.stream;

  ///
  final _startGetFaceSubject = PublishSubject<bool>();
  Stream<bool> get gettingFaceStream => _startGetFaceSubject.stream;

  setActions(List<FloatingActionButton> listAction) {
    _listAction = listAction;
    _actionBlocSubject.sink.add(_listAction);
  }

  addAction(FloatingActionButton action) {
    _listAction.add(action);
    _actionBlocSubject.sink.add(_listAction);
  }
}
