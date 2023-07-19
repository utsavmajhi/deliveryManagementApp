import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:delivery_management_app/src/module/dashboard/home_screen.dart';
import 'package:delivery_management_app/src/module/login/login_view_mobile.dart';
import 'package:delivery_management_app/src/module/vehicle_selection/vehicle_selection.dart';


import 'package:delivery_management_app/src/repository/picking_repo.dart';
import 'package:delivery_management_app/src/repository/vehicle_repo.dart';
import 'package:delivery_management_app/src/repository/warehouse_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/config/route_config.dart';
import 'src/module/authentication/bloc/authentication_bloc.dart';

import 'src/module/login/bloc/login_bloc.dart';

import 'src/util/helper/rest_api.dart';

class MyApp extends StatelessWidget {
  final CognitoUserPool userPool;
  final RestApiClient restClient;
  const MyApp({Key? key, required this.userPool, required this.restClient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => userPool),
        RepositoryProvider(create: (context) => restClient),
        RepositoryProvider(create: (context) => WarehouseRepository(restClient: restClient)),
        RepositoryProvider(create: (context) => PickingRepository(restClient: restClient)),
        RepositoryProvider(create: (context) => VehicleRepository(restClient: restClient)),

      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              userPool: RepositoryProvider.of(context),
            )..add(
                InitialAuthEvent(),
              ),
          ),
          BlocProvider(
            create: (context) => LoginBloc(
                userPool: RepositoryProvider.of(context),
                authenticationBloc: BlocProvider.of(context)),
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  VehicleSelectionScreen.route(),
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginViewMobile.route(),
                  (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: RouteConfig.onGenerateRoute,
    );
  }
}
