part of 'history_bloc.dart';

@immutable
abstract class HistoryState {}

class HistoryActionState extends HistoryState {}
class HistoryInitial extends HistoryState {}

class HistoryFetchingLoadingState extends HistoryState {}

class HistoryFetchingErrorState extends HistoryState {}
class HistoryFetchingSuccessfulState extends HistoryState{


  List<TripsItems> list;

  HistoryFetchingSuccessfulState({
    required this.list,
   });
   // final PositionHistory hisory;
   //
   // HistoryFetchingSuccessfulState({
   //   required this.hisory,
   //  });

}