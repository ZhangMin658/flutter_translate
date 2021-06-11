import 'package:equatable/equatable.dart';
import '../../../function/common/model/history_obj.dart';

abstract class HistoryState extends Equatable {}

class InitialHistoryState extends HistoryState {
  @override
  List<Object> get props => [];
}

class EmptyHistoryState extends HistoryState {
  @override
  List<Object> get props => null;
}

class LoadingHistoryState extends HistoryState {
  @override
  List<Object> get props => null;
}

class LoadedHistoryState extends HistoryState {
  final List<HistoryObj> listHistory;
  LoadedHistoryState(this.listHistory);

  @override
  List<Object> get props => [listHistory];
}

class DetailHistoryState extends HistoryState {
  final HistoryObj historyObj;
  DetailHistoryState(this.historyObj);

  @override
  List<Object> get props => [historyObj];
}
