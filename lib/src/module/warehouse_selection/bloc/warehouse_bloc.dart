import 'dart:async';

import 'package:delivery_management_app/src/models/warehouse_list_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../repository/warehouse_repo.dart';
import '../../authentication/user_mixin.dart';

part 'warehouse_event.dart';
part 'warehouse_state.dart';

class FetchWarehouseBloc extends Bloc<FetchWarehouseEvent, FetchWarehouseState> {
  final log = Logger('FetchWarehouseBloc');
  final WarehouseRepository warehouseRepo;

  FetchWarehouseBloc({required this.warehouseRepo}) : super(const FetchWarehouseState()) {
    on<FetchWarehouseList>(_fetchWarehouseList);
  }

  void _fetchWarehouseList(
      FetchWarehouseList event, Emitter<FetchWarehouseState> emit) async {
    emit(state.copyWith(status: FetchWarehouseStatus.loading));
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      log.info("Getting warehouse list");
      List<WarehouseModel> resp = await warehouseRepo.getWarehouseList();
      log.info("Successfully fetched warehouse list");
      emit(state.copyWith(status: FetchWarehouseStatus.success, warehousesList:resp));
    } on Exception catch (e) {
      log.info("Error while fetching order list");
      emit(state.copyWith(status: FetchWarehouseStatus.failure));
      log.severe(e);
    }
  }
}
