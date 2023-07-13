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
      'ap-south-1_XhVn9JS4K',
      '21afno2d82u7p1ia0ooj6ooot8',
      storage: customStorage,
    );

    final restClient = RestApiClient(
      userPool: userPool,
      baseUrl: "https://03p7mgjck2.execute-api.ap-south-1.amazonaws.com/dev",
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
