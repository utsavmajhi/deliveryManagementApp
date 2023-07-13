part of 'picking_bloc.dart';

@immutable
abstract class PickingEvent {}

class PickingItemInitial extends PickingEvent{
  PickingItemInitial();
}
class PickingItemAdd extends PickingEvent{
  final String id;
  PickingItemAdd(this.id);
}
class PickingItemDelete extends PickingEvent{
  final CartonModel cartonObj;
  PickingItemDelete(this.cartonObj);
}
class PickingItemSubmit extends PickingEvent{
  final List<CartonModel> validatedCartonsList;
  final String userId;
  final VehicleModel vehicle;
  final String pickLoc;
  PickingItemSubmit(this.validatedCartonsList,this.userId,this.vehicle,this.pickLoc);
}

class PickingItemEnteredId extends PickingEvent{
  String bolCartonId;
  PickingItemEnteredId(this.bolCartonId);
}
class PickingItemResetFailureState extends PickingEvent{
  PickingItemResetFailureState();
}
class PickingItemResetAllState extends PickingEvent{
  PickingItemResetAllState();
}