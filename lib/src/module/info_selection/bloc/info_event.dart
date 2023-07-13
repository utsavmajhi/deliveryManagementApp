part of 'info_bloc.dart';

@immutable
abstract class InfoSelectionEvent {}

class FetchAllLocations extends InfoSelectionEvent{
  FetchAllLocations();
}