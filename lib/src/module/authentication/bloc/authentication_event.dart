part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {}

class InitialAuthEvent extends AuthenticationEvent {}

class AuthenticationUserChanged extends AuthenticationEvent {
  final CognitoUser user;

  AuthenticationUserChanged(this.user);
}

class VerifyUserOtpStep extends AuthenticationEvent{
  final Map<String, dynamic> parameterMap;

  VerifyUserOtpStep(this.parameterMap);
}

class VerifyUserDeviceStep extends AuthenticationEvent {
  final Map<String, dynamic> parameterMap;

  VerifyUserDeviceStep(this.parameterMap);
}

class LogOutUserEvent extends AuthenticationEvent{}

class WarehouseLoginEvent extends AuthenticationEvent{
  final String? warehouseId;

  WarehouseLoginEvent(this.warehouseId);
}
class WarehouseSelectEvent extends AuthenticationEvent{
  final String? warehouseId;
  final String? warehouseDesc;
  WarehouseSelectEvent(this.warehouseId,this.warehouseDesc);
}