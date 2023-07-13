part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginUser extends LoginEvent {
  final String userName;
  final String password;

  LoginUser(this.userName, this.password);
}

class VerifyUserOtp extends LoginEvent {
  final String otp;

  VerifyUserOtp(this.otp);
}

class RemoveDevice extends LoginEvent {
  final List<String> devices;

  RemoveDevice(this.devices);
}

class InitialLoginEvent extends LoginEvent{}

class LogOutUserEvent extends LoginEvent {}


