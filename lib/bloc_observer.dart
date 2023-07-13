import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

/// Custom [BlocObserver] which observes all bloc and cubit instances.
class PickingAppBlocObserver extends BlocObserver {
  final log = Logger('PickingAppBlocObserver');
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log.info(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log.info(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log.severe(error);
    super.onError(bloc, error, stackTrace);
  }
}
