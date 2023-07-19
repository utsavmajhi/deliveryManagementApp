import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_observer.dart';
import 'log.dart';
import 'my_app.dart';
import 'src/repository/custom_storage.dart';
import 'src/util/helper/rest_api.dart';

Future<void> main() {
  return BlocOverrides.runZoned(() async {
    WidgetsFlutterBinding.ensureInitialized();
    initRootLogger();
    await EasyLocalization.ensureInitialized();
    var customStorage = CustomStorage();
    final userPool = CognitoUserPool(
      'ap-south-1_Hg0sBXW7Q',
      '5u21orv1gmrsnva5uj3o99h2jq',
      storage: customStorage,
    );

    final restClient = RestApiClient(
      userPool: userPool,
      baseUrl: "https://cespfyl04i.execute-api.ap-south-1.amazonaws.com/dev",
    );

    runApp(
      EasyLocalization(
        path: 'assets/translations',
        supportedLocales: const [
          Locale('en', 'US'),
        ],
        fallbackLocale: const Locale('en', 'US'),
        child: MyApp(
          userPool: userPool,
          restClient: restClient,
        ),
      ),
    );
  }, blocObserver: PickingAppBlocObserver());
}
