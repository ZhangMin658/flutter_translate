import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../function/common/database/translate_history.dart';
import '../../../function/common/model/history_obj.dart';
import '../bloc.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  @override
  HistoryState get initialState => InitialHistoryState();

  @override
  Stream<HistoryState> mapEventToState(
    HistoryEvent event,
  ) async* {
    if (event is ShowStogareHistoryEvent) {
      yield LoadingHistoryState();
      List<HistoryObj> listHistory =
          await TranslateHistoryDB.translateHistoryDB.getAllItem();
      if (listHistory == null || listHistory.length == 0) {
        yield EmptyHistoryState();
      } else {
        yield LoadedHistoryState(listHistory);
      }
    }
    if (event is ShowDetailHistoryEvent) {
      yield DetailHistoryState(event.historyObj);
    }
  }
}
