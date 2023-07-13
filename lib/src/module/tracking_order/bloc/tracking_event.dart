part of 'tracking_bloc.dart';

@immutable
abstract class TrackingEvent {}

class TrackingItemInitial extends TrackingEvent{
  TrackingItemInitial();
}
class TrackingItemSearch extends TrackingEvent{
  final String id;
  TrackingItemSearch(this.id);
}
class TrackingItemDelete extends TrackingEvent{
  final CartonModel cartonObj;
  TrackingItemDelete(this.cartonObj);
}
class TrackingItemSubmit extends TrackingEvent{
  final List<CartonModel> validatedCartonsList;
  final String userId;
  final Warehouse warehouse;
  TrackingItemSubmit(this.validatedCartonsList,this.userId,this.warehouse);
}

class TrackingItemEnteredId extends TrackingEvent{
  String bolCartonId;
  TrackingItemEnteredId(this.bolCartonId);
}
class TrackingItemResetFailureState extends TrackingEvent{
  TrackingItemResetFailureState();
}