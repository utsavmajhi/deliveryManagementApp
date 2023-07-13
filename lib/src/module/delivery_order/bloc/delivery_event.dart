part of 'delivery_bloc.dart';

@immutable
abstract class DeliveryEvent {}

class DeliveryItemInitial extends DeliveryEvent{
  DeliveryItemInitial();
}
class DeliveryItemAdd extends DeliveryEvent{
  final String id;
  final String storeId;
  DeliveryItemAdd(this.id,this.storeId);
}
class DeliveryItemDelete extends DeliveryEvent{
  final CartonModel cartonObj;
  DeliveryItemDelete(this.cartonObj);
}
class DeliveryItemSubmit extends DeliveryEvent{
  final List<CartonModel> validatedCartonsList;
  final String userId;
  final Warehouse warehouse;
  DeliveryItemSubmit(this.validatedCartonsList,this.userId,this.warehouse);
}

class DeliveryItemEnteredId extends DeliveryEvent{
  String bolCartonId;
  DeliveryItemEnteredId(this.bolCartonId);
}
class DeliveryItemResetFailureState extends DeliveryEvent{
  DeliveryItemResetFailureState();
}