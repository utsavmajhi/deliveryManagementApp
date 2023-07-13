part of 'login_bloc.dart';

enum LoginStatus {
  initial,
  loadingLogin,
  initiateOtpVerification,
  verifyOtp,
  verifyOtpLoading,
  verifyOtpFailure,
  verifyDevice,
  verifyDeviceLoading,
  success,
  failure
}

class LoginState {
  final LoginStatus status;
  final CognitoUser? user;
  final int retryCount;
  final String error;
  final List<dynamic> deviceList;

  LoginState(
      {this.status = LoginStatus.initial,
      this.user,
      this.retryCount = 0,
      this.deviceList = const [],
      this.error = ''});

  LoginState copyWith(
      {LoginStatus? status,
      CognitoUser? user,
      int? retryCount,
      List<dynamic>? deviceList,
      String? error}) {
    return LoginState(
        status: status ?? this.status,
        user: user ?? this.user,
        deviceList: deviceList ?? this.deviceList,
        retryCount: retryCount ?? this.retryCount,
        error: error ?? this.error);
  }

  @override
  String toString() {
    return 'LoginState{status: $status, user: $user, retryCount: $retryCount, error: $error, deviceList: $deviceList}';
  }
}
