part of 'devices_bloc.dart';

@immutable
abstract class DevicesState {}

class DevicesInitial extends DevicesState {}

class DevicesLoadingState extends DevicesState {}

class DevicesSuccessState extends DevicesState {}

class DevicesErrorState extends DevicesState {}