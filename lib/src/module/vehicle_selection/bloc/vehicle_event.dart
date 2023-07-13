part of 'vehicle_bloc.dart';

@immutable
abstract class FetchVehicleEvent {}

class FetchVehicleIdList extends FetchVehicleEvent{
  FetchVehicleIdList();
}