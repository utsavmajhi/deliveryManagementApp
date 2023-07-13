import 'dart:async';

import 'package:delivery_management_app/src/models/entity_model.dart';
import 'package:delivery_management_app/src/models/vehicle_model.dart';
import 'package:delivery_management_app/src/models/warehouse_list_model.dart';
import 'package:delivery_management_app/src/repository/vehicle_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../repository/warehouse_repo.dart';
import '../../authentication/user_mixin.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class FetchVehicleBloc extends Bloc<FetchVehicleEvent, FetchVehicleState> {
  final log = Logger('FetchVehicleBloc');
  final VehicleRepository vehicleRepository;

  FetchVehicleBloc({required this.vehicleRepository}) : super(const FetchVehicleState()) {
    on<FetchVehicleIdList>(_FetchVehicleIdList);
  }

  void _FetchVehicleIdList(
      FetchVehicleIdList event, Emitter<FetchVehicleState> emit) async {
    emit(state.copyWith(status: FetchVehiclesStatus.loading));
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      log.info("Getting warehouse list");
      List<VehicleModel> resp = await vehicleRepository.getVehiclesList();
      log.info("Successfully fetched warehouse list");
      emit(state.copyWith(status: FetchVehiclesStatus.success, vehiclesList:resp));
    } on Exception catch (e) {
      log.info("Error while fetching order list");
      emit(state.copyWith(status: FetchVehiclesStatus.failure));
      log.severe(e);
    }
  }
}
