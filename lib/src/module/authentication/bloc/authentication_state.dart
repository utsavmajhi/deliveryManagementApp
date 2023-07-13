part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated,
  warehouseLogin,
  warehouseSelected,
  unknown
}

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final CognitoUser? user;
  final Warehouse? warehouse;

  const AuthenticationState._({
    required this.status,
    this.user,
    this.warehouse,
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


  @override
  List<Object?> get props => [
        status,
        user,
      ];
}
