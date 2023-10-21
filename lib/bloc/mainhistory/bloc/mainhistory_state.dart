part of 'mainhistory_bloc.dart';


@immutable
abstract class MainHistoryState {}

class MainHistoryActionState extends MainHistoryState {}
class MainHistoryInitial extends MainHistoryState {}

class MainHistoryFetchingLoadingState extends MainHistoryState {}

class MainHistoryFetchingErrorState extends MainHistoryState {}
class MainHistoryFetchingSuccessfulState extends MainHistoryState{



   final PositionHistory hisory;

   MainHistoryFetchingSuccessfulState({
     required this.hisory,
    });

}