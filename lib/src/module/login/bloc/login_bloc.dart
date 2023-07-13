import 'dart:io';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../authentication/bloc/authentication_bloc.dart';
import '../../authentication/user_mixin.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final log = Logger('LoginBloc');

  final CognitoUserPool userPool;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({required this.userPool, required this.authenticationBloc}) : super(LoginState()) {
    on<LoginUser>(_onLoginUser);
    // on<VerifyUserOtp>(_onVerifyUserOtp);
    // on<RemoveDevice>(_onRemoveDeviceEvent);
  }

  // LoginBloc(): super(LoginState()) {
  //   on<LoginUser>(_onLoginUser);
  //   on<InitialLoginEvent>(_onInitialLogin);
  // }

  void _onLoginUser(
      LoginUser event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loadingLogin));
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      // userPool.getCurrentUser()
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      String deviceName = '';

      if (Platform.isIOS) {
        IosDeviceInfo info = await deviceInfo.iosInfo;
        deviceName = '${info.name}:${info.model}:${info.systemName}:${info.systemVersion}';
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo info = await deviceInfo.androidInfo;
        deviceName = '${info.device}:${info.model}:${info.hardware}';
      } else if (Platform.isMacOS) {
        MacOsDeviceInfo info = await deviceInfo.macOsInfo;
        deviceName = '${info.computerName}:${info.model}:${info.osRelease}:${info.systemGUID}';
      } else if (Platform.isWindows) {
        WindowsDeviceInfo info = await deviceInfo.windowsInfo;
        deviceName = '${info.computerName}:${info.numberOfCores}:${info.systemMemoryInMegabytes}';
      }
      log.info("Logging to $deviceName}");
      final cognitoUser = CognitoUser(event.userName, userPool, deviceName: deviceName);
      // cognitoUser.setAuthenticationFlowType('USER_PASSWORD_AUTH');
      emit(state.copyWith(user: cognitoUser));
      await cognitoUser.authenticateUser(AuthenticationDetails(username: event.userName, password: event.password)); //authenticateUser
      print("MEOW LOGIN ${cognitoUser.username}");
      emit(state.copyWith(status: LoginStatus.success));
      UserDetail.setLoggedInUser(cognitoUser.username);
      authenticationBloc.add(AuthenticationUserChanged(cognitoUser));
    } catch (e) {

      emit(state.copyWith(status: LoginStatus.failure));
      log.severe(e);
    }
  }

  /*
  void _onInitialLogin(
      InitialLoginEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.initial));
  }

  void _getUserDetail() async {
    CognitoUser user = state.user!;
    var tmp = await userPool.getCurrentUser();
    await user.getSession();
    var userAttribute = await user.getUserAttributes();
    log.info(tmp);
    if (tmp != null && userAttribute != null) {
      CognitoUserAttribute? stores;
      for(var x = 0; x < userAttribute.length; x++) {
        if (userAttribute[x].name == "custom:allocated_store") {
          stores = userAttribute[x];
          break;
        }
      }
      authenticationBloc.add(AuthenticationUserChanged(tmp, stores, userAttribute));
    }
  }

  void _onVerifyUserOtp(
      VerifyUserOtp event, Emitter<LoginState> emit) async {
    // Loading
    try {
      emit(state.copyWith(retryCount: state.retryCount + 1, status: LoginStatus.verifyOtpLoading));
      CognitoUser user = state.user!;
      var res = await user.sendCustomChallengeAnswer(event.otp);
      log.info(res);
    } on CognitoUserCustomChallengeException catch(e) {
      // log.severe(e);
      log.severe('Custom Challenge exception', e);
      log.severe(e.challengeParameters);
      var deviceList = json.decode(e.challengeParameters['device_list']) as List<dynamic>;
      authenticationBloc.add(VerifyUserDeviceStep(e.challengeParameters));
      emit(state.copyWith(status: LoginStatus.verifyDevice, deviceList: deviceList));
    } catch (e) {
      log.severe(e);
    }
  }

  void _onRemoveDeviceEvent(
      RemoveDevice event, Emitter<LoginState> emit) async {
    // Loading
    try {
      emit(state.copyWith(status: LoginStatus.verifyDeviceLoading));
      CognitoUser user = state.user!;
      var res = await user.sendCustomChallengeAnswer(' ');
      _getUserDetail();
    } catch (e) {
      log.severe(e);
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }
  */

}
