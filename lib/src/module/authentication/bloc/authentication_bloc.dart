import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:delivery_management_app/src/models/loc_model.dart';
import 'package:delivery_management_app/src/models/vehicle_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../models/warehouse_model.dart';
import '../user_mixin.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final log = Logger('AuthenticationBloc');
  final CognitoUserPool userPool;

  AuthenticationBloc(
      {required this.userPool,})
      : super(const AuthenticationState.unknown()) {
    // signInIfSessionAvailable();
    on<AuthenticationUserChanged>(_onUserChanged);
    on<InitialAuthEvent>(_onInitialAuth);
    on<LogOutUserEvent>(_logOutUser);
    on<WarehouseLoginEvent>(_onWarehouseLogin);
    on<WarehouseSelectEvent>(_onWarehouseSelectEvent);
    on<VehicleSelectEvent>(_onVehicleSelectEvent);
    on<LocSelectEvent>(_onLocSelectEvent);
  }
  // signInIfSessionAvailable() async {
  //   log.info('Getting if user already present');
  //   // final session = await Amplify.Auth.fetchAuthSession();
  //   // if (session.isSignedIn) {
  //   //   print('User Alreadu Present');
  //   // }
  //   // try {
  //   //   CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(
  //   //       options: CognitoSessionOptions(getAWSCredentials: true));
  //   //   print(res.userSub);
  //   //   print(res.identityId);
  //   // } on AmplifyException catch (e) {
  //   //
  //   //   print(e);
  //   // }
  // }

  void _onInitialAuth(
      InitialAuthEvent event, Emitter<AuthenticationState> emit) async {
    try {
      var user = await userPool.getCurrentUser();
      if (user != null) {
        // Three Scenario when user logged in
        // He is new user need to register for a business.
        // He owns multiple business need to choose which one to login. @TODO
        // Only one business directly login to system.

        await user.getSession();
        var attrib = await user.getUserAttributes();

        Map<String, String?> attributes = {};
        if (attrib != null) {
          for (var x = 0; x < attrib.length; x++) {
            if (attrib[x].name != null) {
              attributes.putIfAbsent(attrib[x].name!, () => attrib[x].value);
            }
          }
        }

        // EmployeeEntity empEntity = EmployeeEntity(
        //   phone: attributes['phone_number'] ?? '',
        //   email: attributes['email'] ?? '',
        //   firstName: attributes['given_name'],
        //   middleName: attributes['middle_name'],
        //   lastName: attributes['family_name'],
        //   employeeId: attributes['sub'],
        //   locale: attributes['locale'],
        //   allocatedStore: attributes['custom:allocated_store'],
        //   currentStore: attributes['custom:current_store'],
        //   picture: attributes['picture'],
        //   gender: attributes['gender'],
        // );
        UserDetail.setLoggedInUser(user.username);
        emit(AuthenticationState.authenticated(user));
      } else {
        emit(const AuthenticationState.unauthenticated());
      }
    } catch (e) {
      log.severe(e);
      emit(const AuthenticationState.unauthenticated());
    }
  }

  void _onUserChanged(AuthenticationUserChanged event,
      Emitter<AuthenticationState> emit) async {
    emit(AuthenticationState.authenticated(event.user));
  }

  void _logOutUser(
      LogOutUserEvent event, Emitter<AuthenticationState> emit) async {
    var tmp = await userPool.getCurrentUser();
    if (tmp != null) {
      await tmp.signOut();
      emit(const AuthenticationState.unauthenticated());
    } else {
      emit(const AuthenticationState.unauthenticated());
    }
  }

  void _onWarehouseLogin(
      WarehouseLoginEvent event, Emitter<AuthenticationState> emit) async {
    if (state.user != null && event.warehouseId != null) {
      emit(AuthenticationState.warehouseLogin(
          state.user!,
          Warehouse(
            id: event.warehouseId!, name: event.warehouseId ?? 'Warehouse',
          )
      ));
    }
  }
  void _onWarehouseSelectEvent(
      WarehouseSelectEvent event, Emitter<AuthenticationState> emit) async {
    if (event.warehouseId != null) {
      emit(AuthenticationState.warehouseSelected(
          Warehouse(
            id: event.warehouseId!, name: event.warehouseDesc ?? 'Warehouse',
          )
      ));
    }
  }
  void _onVehicleSelectEvent(
      VehicleSelectEvent event, Emitter<AuthenticationState> emit) async {
    if (event.vehicleId != null) {
      emit(AuthenticationState.vehicleSelected(
          VehicleModel(
            vehicleID: event.vehicleId!, vehicleDesc: event.vehicleDesc ?? '',
              typeOfVehicle: event.vehicleType
          )
      ));
    }
  }

  void _onLocSelectEvent(
      LocSelectEvent event, Emitter<AuthenticationState> emit) async {
    if (event.locDesc != null) {
      emit(AuthenticationState.locSelected(
          LocModel(
              locID: event.locId!, locDesc: event.locDesc ?? '',
              locType: event.locType
          )
      ));
    }
  }

}
