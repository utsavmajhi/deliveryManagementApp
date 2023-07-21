import 'dart:async';

import 'package:POD/src/models/entity_model.dart';
import 'package:POD/src/models/loc_model.dart';
import 'package:POD/src/models/warehouse_list_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../repository/warehouse_repo.dart';
import '../../authentication/user_mixin.dart';

part 'info_event.dart';
part 'info_state.dart';

class InfoSelectionBloc extends Bloc<InfoSelectionEvent, InfoSelectionState> {
  final log = Logger('InfoSelectionBloc');
  final WarehouseRepository warehouseRepo;

  InfoSelectionBloc({required this.warehouseRepo}) : super(const InfoSelectionState()) {
    on<FetchAllLocations>(_fetchAllLocations);
  }

  void _fetchAllLocations(
      FetchAllLocations event, Emitter<InfoSelectionState> emit) async {
    emit(state.copyWith(status: InfoSelectionStatus.loading));
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      log.info("Getting alllocations list");
      List<LocModel> resp = await warehouseRepo.getAllLocationsList();
      log.info("Successfully fetched All locations list");
      emit(state.copyWith(status: InfoSelectionStatus.success,locList: resp));
    } on Exception catch (e) {
      log.info("Error while fetching order list");
      emit(state.copyWith(status: InfoSelectionStatus.failure));
      log.severe(e);
    }
  }
}
