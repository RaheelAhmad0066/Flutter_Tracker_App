import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:maktrogps/config/static.dart';
import 'package:maktrogps/data/model/PositionHistory.dart';
import 'package:maktrogps/data/model/history.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'kmandfuelhistory_event.dart';
part 'kmandfuelhistory_state.dart';

class KmandfuelHistoryBloc extends Bloc<KmandfuelHistoryEvent, KmandfuelHistoryState> {
  KmandfuelHistoryBloc() : super(KmandfuelHistoryInitial()) {

    on<KmandfuelHistoryInitialFetchEvent>(historyInitialFetchEvent);
    // on<HistoryEvent>((event, emit) {
    //
    //   // TODO: implement event handler
    // });
  }
  FutureOr<void> historyInitialFetchEvent(KmandfuelHistoryInitialFetchEvent event, Emitter<KmandfuelHistoryState> emit) async{

    emit(KmandfuelHistoryFetchingLoadingState());


    final Uri apiUrl = Uri.parse(StaticVarMethod.baseurlall+"/api/get_history?lang=en&user_api_hash=${StaticVarMethod.user_api_hash}&from_date="+StaticVarMethod.fromdate+"&from_time="+StaticVarMethod.fromtime+"&to_date="+StaticVarMethod.todate+"&to_time="+StaticVarMethod.totime+"&device_id="+StaticVarMethod.deviceId+"");
    final response = await http.get(apiUrl).timeout(const Duration(minutes: 5));
    print(response.request);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body.toString());
      var history = History.fromJson(jsonData);

      emit(KmandfuelHistoryFetchingSuccessfulState(history: history));

    } else {
      print(response.statusCode);
      emit(KmandfuelHistoryFetchingErrorState());
    }

  }
}
