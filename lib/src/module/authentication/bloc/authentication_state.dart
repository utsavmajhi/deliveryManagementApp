part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated,
  warehouseLogin,
  warehouseSelected,
  vehicleSelected,
  locationSelected,
  unknown
}

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final CognitoUser? user;
  final Warehouse? warehouse;
  final VehicleModel? vehicle;
  final LocModel? location;

  // final String? vehicle;

  const AuthenticationState._({
    required this.status,
    this.user,
    this.warehouse,
    this.vehicle,
    this.location
  });

  const AuthenticationState.unauthenticated()
      : this._(
          status: AuthenticationStatus.unauthenticated,
        );

  const AuthenticationState.unknown()
      : this._(
          status: AuthenticationStatus.unknown,
        );

  const AuthenticationState.authenticated(
    CognitoUser user,
  ) : this._(
          status: AuthenticationStatus.authenticated,
          user: user,
        );

  const AuthenticationState.warehouseLogin(
    CognitoUser user,
    Warehouse warehouse,
  ) : this._(
          status: AuthenticationStatus.warehouseLogin,
          user: user,
          warehouse: warehouse,
        );
  const AuthenticationState.warehouseSelected(
      Warehouse warehouse,
      ) : this._(
    status: AuthenticationStatus.warehouseSelected,
    warehouse: warehouse,
  );
  const AuthenticationState.vehicleSelected(
      VehicleModel vehicle,
      ) : this._(
    status: AuthenticationStatus.vehicleSelected,
    vehicle: vehicle,
  );
  const AuthenticationState.locSelected(
      LocModel location,
      ) : this._(
    status: AuthenticationStatus.locationSelected,
    location: location,
  );



  @override
  List<Object?> get props => [
        status,
        user,
        vehicle,
        location
      ];
}
