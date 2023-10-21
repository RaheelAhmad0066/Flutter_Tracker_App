part of 'kmandfuelhistory_bloc.dart';

@immutable
abstract class KmandfuelHistoryState {}

class KmandfuelHistoryActionState extends KmandfuelHistoryState {}
class KmandfuelHistoryInitial extends KmandfuelHistoryState {}

class KmandfuelHistoryFetchingLoadingState extends KmandfuelHistoryState {}

class KmandfuelHistoryFetchingErrorState extends KmandfuelHistoryState {}
class KmandfuelHistoryFetchingSuccessfulState extends KmandfuelHistoryState{


  History history;

  KmandfuelHistoryFetchingSuccessfulState({
    required this.history,
   });
   // final PositionHistory hisory;
   //
   // HistoryFetchingSuccessfulState({
   //   required this.hisory,
   //  });

}