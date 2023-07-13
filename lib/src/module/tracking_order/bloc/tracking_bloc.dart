import 'dart:async';

import 'package:delivery_management_app/src/models/carton_history.dart';
import 'package:delivery_management_app/src/models/carton_model.dart';
import 'package:delivery_management_app/src/repository/picking_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';


import '../../../models/warehouse_model.dart';
import '../../delivery_order/bloc/delivery_bloc.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final log = Logger('TrackingBloc');
  final PickingRepository pickingRepo;

  TrackingBloc({required this.pickingRepo}) : super(const TrackingState()) {
    on<TrackingItemSearch>(_getCartonsHistoryById);
    on<TrackingItemEnteredId>(_setSelectedCartonsId);
    on<TrackingItemResetFailureState>(_resetFailureStatus);

  }

  void _getCartonsHistoryById(
      TrackingItemSearch event, Emitter<TrackingState> emit) async {
    emit(state.copyWith(status: TrackingStatus.loading));
    await Future.delayed(const Duration(milliseconds: 100));
    String id = event.id;
    try {
      log.info("Getting getAllCartonHistory list");
      var resp = await pickingRepo.getCartonHistoryById(id);
      emit(state.copyWith(status: TrackingStatus.success,cartonHistoryList: resp));
      log.info("Successfully getAllCartonHistory list");
    } on Exception catch (e) {
      log.info("Error while getAllCartonHistory list ${e}");
      emit(state.copyWith(status: TrackingStatus.failure,errMsg: 'Invalid Carton ID'));
      log.severe(e);
    }
  }

  void _setSelectedCartonsId(
      TrackingItemEnteredId event, Emitter<TrackingState> emit) async {
    String id = event.bolCartonId;
    try {
      emit(state.copyWith(enteredBolCartonId:id));
    } on Exception catch (e) {
      emit(state.copyWith(status: TrackingStatus.failure));
      log.severe(e);
    }
  }

  void _resetFailureStatus(
      TrackingItemResetFailureState event, Emitter<TrackingState> emit) async {
    emit(state.copyWith(status: TrackingStatus.initial));
  }
}
