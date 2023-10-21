import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/model/PositionHistory.dart';
import 'package:maktrogps/data/model/history.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'mainhistory_event.dart';
part 'mainhistory_state.dart';

class MainHistoryBloc extends Bloc<MainHistoryEvent, MainHistoryState> {
  MainHistoryBloc() : super(MainHistoryInitial()) {

    on<MainHistoryInitialFetchEvent>(historyInitialFetchEvent);
    // on<HistoryEvent>((event, emit) {
    //
    //   // TODO: implement event handler
    // });
  }
  FutureOr<void> historyInitialFetchEvent(MainHistoryInitialFetchEvent event, Emitter<MainHistoryState> emit) async {
    emit(MainHistoryFetchingLoadingState());


    List<TripsItems> list = [];
    final response = await http.get(Uri.parse(StaticVarMethod.baseurlall +
        "/api/get_history?lang=en&user_api_hash=${StaticVarMethod
            .user_api_hash}&from_date=" + StaticVarMethod.fromdate +
        "&from_time=" + StaticVarMethod.fromtime + "&to_date=" +
        StaticVarMethod.todate + "&to_time=" + StaticVarMethod.totime +
        "&device_id=" + StaticVarMethod.deviceId + ""));
    print(response.request);
    if (response.statusCode == 200) {
      //var data= response.body;
      // var data1= response.body.toString();

      final response = await http.get(Uri.parse(StaticVarMethod.baseurlall +
          "/api/get_history?lang=en&user_api_hash=${StaticVarMethod
              .user_api_hash}&from_date=" + StaticVarMethod.fromdate +
          "&from_time=" + StaticVarMethod.fromtime + "&to_date=" +
          StaticVarMethod.todate + "&to_time=" + StaticVarMethod.totime +
          "&device_id=" + StaticVarMethod.deviceId + ""));
      print(response.request);
      if (response.statusCode == 200) {
        var value = PositionHistory.fromJson(json.decode(response.body));
        emit(MainHistoryFetchingSuccessfulState(hisory: value));
      } else {
        print(response.statusCode);
        return null;
      }
    }
  }
}
