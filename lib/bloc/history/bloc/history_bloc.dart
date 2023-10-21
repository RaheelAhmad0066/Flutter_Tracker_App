import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/model/PositionHistory.dart';
import 'package:maktrogps/data/model/history.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {

    on<HistoryInitialFetchEvent>(historyInitialFetchEvent);
    // on<HistoryEvent>((event, emit) {
    //
    //   // TODO: implement event handler
    // });
  }
  FutureOr<void> historyInitialFetchEvent(HistoryInitialFetchEvent event, Emitter<HistoryState> emit) async{

    emit(HistoryFetchingLoadingState());


    List<TripsItems> list = [];
    final Uri apiUrl = Uri.parse(StaticVarMethod.baseurlall+"/api/get_history?lang=en&user_api_hash=${StaticVarMethod.user_api_hash}&from_date="+StaticVarMethod.fromdate+"&from_time="+StaticVarMethod.fromtime+"&to_date="+StaticVarMethod.todate+"&to_time="+StaticVarMethod.totime+"&device_id="+StaticVarMethod.deviceId+"");
    final response = await http.get(apiUrl).timeout(const Duration(minutes: 5));
    print(response.request);
    if (response.statusCode == 200) {

     //var data= response.body;
    // var data1= response.body.toString();
      var jsonData = json.decode(response.body.toString());
      var history = History.fromJson(jsonData);
      for (var i = 0; i < history.items!.length; i++) {
        list.add(history.items![i]);
      }
      emit(HistoryFetchingSuccessfulState(list: list));
     // return list;
     // var value= PositionHistory.fromJson(json.decode(response.body));


    } else {
      print(response.statusCode);
      emit(HistoryFetchingErrorState());
    }
    // final response = await http.get(Uri.parse(StaticVarMethod.baseurlall+"/api/get_history?lang=en&user_api_hash=${StaticVarMethod.user_api_hash}&from_date="+StaticVarMethod.fromdate+"&from_time="+StaticVarMethod.fromtime+"&to_date="+StaticVarMethod.todate+"&to_time="+StaticVarMethod.totime+"&device_id="+StaticVarMethod.deviceId+""));
    // print(response.request);
    // if (response.statusCode == 200) {
    //   var value= PositionHistory.fromJson(json.decode(response.body));
    //   emit(HistoryFetchingSuccessfulState(hisory: value));
    //
    // } else {
    //   print(response.statusCode);
    //   return null;
    // }
  }
}
