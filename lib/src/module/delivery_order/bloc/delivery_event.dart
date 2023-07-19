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

class DeliveryItemsFetchByVehicleId extends DeliveryEvent{
  final String vehicleId;
  DeliveryItemsFetchByVehicleId(this.vehicleId);
}
class DeliveryItemDelete extends DeliveryEvent{
  final CartonModel cartonObj;
  DeliveryItemDelete(this.cartonObj);
}
class DeliveryItemSubmit extends DeliveryEvent{
  final List<CartonModel> validatedCartonsList;
  final String userId;
  final String receivedBy;
  final String locId;
  DeliveryItemSubmit(this.validatedCartonsList,this.userId,this.receivedBy,this.locId);
}

class DeliveryItemReceiverEnteredId extends DeliveryEvent{
  String receiversid;
  DeliveryItemReceiverEnteredId(this.receiversid);
}
class DeliveryItemEnterCartonId extends DeliveryEvent{
  String enteredCartonId;
  DeliveryItemEnterCartonId(this.enteredCartonId);
}
class DeliveryItemValidateCartonId extends DeliveryEvent{
  String enteredCartonId;
  DeliveryItemValidateCartonId(this.enteredCartonId);
}
class DeliveryItemResetFailureState extends DeliveryEvent{
  DeliveryItemResetFailureState();
}