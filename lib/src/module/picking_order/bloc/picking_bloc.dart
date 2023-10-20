import 'dart:async';

import 'package:POD/src/models/carton_model.dart';
import 'package:POD/src/models/carton_pick_model.dart';
import 'package:POD/src/models/error_model.dart';
import 'package:POD/src/models/vehicle_model.dart';
import 'package:POD/src/repository/picking_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../../models/warehouse_model.dart';


part 'picking_event.dart';
part 'picking_state.dart';

class PickingBloc extends Bloc<PickingEvent, PickingState> {
  final log = Logger('PickingBloc');
  final PickingRepository pickingRepo;

  PickingBloc({required this.pickingRepo}) : super(const PickingState()) {
    on<PickingItemAdd>(_getCartonsById);
    on<PickingItemEnteredId>(_setSelectedCartonsId);
    on<PickingItemDelete>(_deleteCartonItemFromList);
    on<PickingItemResetFailureState>(_resetFailureStatus);
    on<PickingItemSubmit>(_pickedItemSubmit);
    on<PickingItemResetAllState>(_resetAllStates);

  }

  Stream<void> _resetAllStates(
      PickingItemResetAllState event, Emitter<PickingState> emit) async* {
    try {
      yield const PickingState();
    } on Exception catch (e) {
      emit(state.copyWith(status: PickingStatus.failure));
      log.severe(e);
    }
  }
    void _getCartonsById(
      PickingItemAdd event, Emitter<PickingState> emit) async {
    emit(state.copyWith(status: PickingStatus.searchIdLoading));
    String id = event.id;
    try {
      log.info("Getting getAllCartons list");
      var resp = await pickingRepo.getCartonListById(id);
      if(resp.length == 0){
        emit(state.copyWith(status: PickingStatus.failure,errMsg: 'Invalid Carton/Bol ID'));
        return;
      }
      Set<CartonModel> cartonSet = Set<CartonModel>.from(state.cartonList);
      for(var res in resp){
        if(!(state.cartonList.any((carton) => carton.cartonID == res.cartonID))){
          cartonSet.add(res);
        }
      }
      log.info("Successfully getAllCartons list ${cartonSet.toList()}");
      emit(state.copyWith(status: PickingStatus.searchIdSuccess, cartonList:cartonSet.toList()));
    } catch (e) {
      log.info("Error while getAllCartons list ${e}");
      if(e is ErrorModel){
        emit(state.copyWith(status: PickingStatus.failure,errMsg: e.errorMsg));
      }else{
        emit(state.copyWith(status: PickingStatus.failure,errMsg: 'Invalid Carton/Bol ID'));
      }
      log.severe(e);
    }
  }

  void _setSelectedCartonsId(
      PickingItemEnteredId event, Emitter<PickingState> emit) async {
    String id = event.bolCartonId;
    try {
      emit(state.copyWith(enteredBolCartonId:id));
    } on Exception catch (e) {
      emit(state.copyWith(status: PickingStatus.failure));
      log.severe(e);
    }
  }

  void _deleteCartonItemFromList(
      PickingItemDelete event, Emitter<PickingState> emit) async {
    CartonModel cartonObj = event.cartonObj;
    var cartonListCopy = List<CartonModel>.from(state.cartonList);
    cartonListCopy.removeWhere((element) =>
    element.cartonID == cartonObj.cartonID &&
        element.bolID == cartonObj.bolID);
    try {
      emit(state.copyWith(cartonList:[...cartonListCopy]));
    } on Exception catch (e) {
      emit(state.copyWith(status: PickingStatus.failure));
      log.severe(e);
    }
  }

  void _pickedItemSubmit(
      PickingItemSubmit event, Emitter<PickingState> emit) async {
    List<CartonModel> selectedCartonList = event.validatedCartonsList;
    emit(state.copyWith(status: PickingStatus.submit));
    List<CartonPickModel> modifiedList = selectedCartonList.map((e) => CartonPickModel(
      cartonID: e.cartonID,
      bolID: e.bolID,
      vehicleID: event.vehicle.vehicleID,
      user: event.userId,
      pickLoc: event.pickLoc
    )).toList();
    try {
      await pickingRepo.pickCartons(modifiedList);
      const newInitialState = PickingState();
      emit(newInitialState.copyWith(status: PickingStatus.submitted));
      await Future.delayed(const Duration(milliseconds: 5000));
      emit(newInitialState.copyWith(status: PickingStatus.initial));
    } on Exception catch (e) {
      emit(state.copyWith(status: PickingStatus.failure,errMsg: "Picked items not Submitted"));
      log.severe(e);
    }
  }

  void _resetFailureStatus(
      PickingItemResetFailureState event, Emitter<PickingState> emit) async {
    emit(state.copyWith(status: PickingStatus.initial));
  }
}
