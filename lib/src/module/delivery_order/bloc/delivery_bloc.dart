import 'dart:async';

import 'package:POD/src/models/carton_model.dart';
import 'package:POD/src/models/carton_pick_model.dart';
import 'package:POD/src/models/carton_receive_submit_model.dart';
import 'package:POD/src/models/error_model.dart';
import 'package:POD/src/repository/picking_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';


import '../../../models/warehouse_model.dart';


part 'delivery_event.dart';
part 'delivery_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final log = Logger('DeliveryBloc');
  final PickingRepository pickingRepo;

  DeliveryBloc({required this.pickingRepo}) : super(const DeliveryState()) {
    on<DeliveryItemAdd>(_getCartonsById);
    on<DeliveryItemReceiverEnteredId>(_setReceiverId);
    on<DeliveryItemEnterCartonId>(_setCartonId);
    on<DeliveryItemDelete>(_deleteCartonItemFromList);
    on<DeliveryItemResetFailureState>(_resetFailureStatus);
    on<DeliveryItemSubmit>(_deliveryItemSubmit);
    on<DeliveryItemsFetchByVehicleId>(_getDeliveryItemsByVehicleId);
    on<DeliveryItemValidateCartonId>(_validateCartonId);

  }

  void _getCartonsById(
      DeliveryItemAdd event, Emitter<DeliveryState> emit) async {
    emit(state.copyWith(status: DeliveryStatus.searchIdLoading));
    await Future.delayed(const Duration(milliseconds: 100));
    String id = event.id;
    try {
      log.info("Getting getAllCartons list");
      var resp = await pickingRepo.getCartonListById(id);
      Set<CartonModel> cartonSet = Set<CartonModel>.from(state.cartonList);
      for(var res in resp){
        if(!(state.cartonList.any((carton) => carton.cartonID == res.cartonID))){
          cartonSet.add(res);
        }
      }
      log.info("Successfully getAllCartons list");
      emit(state.copyWith(status: DeliveryStatus.searchIdSuccess, cartonList:cartonSet.toList()));
    } catch (e) {
      if(e is ErrorModel){
        emit(state.copyWith(status: DeliveryStatus.failure,errMsg: e.errorMsg));
        return;
      }
      log.info("Error while getAllCartons list ${e}");
      emit(state.copyWith(status: DeliveryStatus.failure,errMsg: 'Invalid Carton/Bol ID '));
      log.severe(e);
    }
  }

  void _getDeliveryItemsByVehicleId(
      DeliveryItemsFetchByVehicleId event, Emitter<DeliveryState> emit) async {
    emit(state.copyWith(status: DeliveryStatus.searchIdLoading));
    await Future.delayed(const Duration(milliseconds: 100));
    String id = event.vehicleId;
    try {
      log.info("Getting getAllDeliveryItems for vehicle id ${id} list");
      var resp = await pickingRepo.getDeliveryItemsByVehicleId(id);
      Set<CartonModel> cartonSet = Set<CartonModel>.from(state.cartonList);
      for(var res in resp){
        if(!(state.cartonList.any((carton) => carton.cartonID == res.cartonID))){
          cartonSet.add(res);
        }
      }
      log.info("Successfully getAllDeliveryItems list");
      emit(state.copyWith(status: DeliveryStatus.searchIdSuccess, cartonList:cartonSet.toList()));
    } catch (e) {
      if(e is ErrorModel){
        emit(state.copyWith(status: DeliveryStatus.failure,errMsg: e.errorMsg));
        return;
      }
      log.info("Error while getAllCartons list ${e}");
      emit(state.copyWith(status: DeliveryStatus.failure,errMsg: 'Invalid Vehicle ID '));
      log.severe(e);
    }
  }
  void _setReceiverId(
      DeliveryItemReceiverEnteredId event, Emitter<DeliveryState> emit) async {
      String id = event.receiversid;
      emit(state.copyWith(receiversId:id));
  }
  void _setCartonId(
      DeliveryItemEnterCartonId event, Emitter<DeliveryState> emit) async {
    String id = event.enteredCartonId;
    emit(state.copyWith(enteredCartonId:id));
  }

  void _deleteCartonItemFromList(
      DeliveryItemDelete event, Emitter<DeliveryState> emit) async {
    CartonModel cartonObj = event.cartonObj;
    var cartonListCopy = List<CartonModel>.from(state.cartonList);
    cartonListCopy.removeWhere((element) =>
    element.cartonID == cartonObj.cartonID &&
        element.bolID == cartonObj.bolID);
    try {
      emit(state.copyWith(cartonList:[...cartonListCopy]));
    } on Exception catch (e) {
      emit(state.copyWith(status: DeliveryStatus.failure));
      log.severe(e);
    }
  }

  void _validateCartonId(
      DeliveryItemValidateCartonId event, Emitter<DeliveryState> emit) async {
    String scannedCartonId = event.enteredCartonId;
    List<CartonModel> cartonListCopy = List<CartonModel>.from(state.cartonList);

    // var matchingCartons = cartonListCopy.where((carton) => carton.cartonID == scannedCartonId).toList();
    List<CartonModel> matchedCartons = cartonListCopy.where((carton) => carton.cartonID == scannedCartonId || carton.bolID == scannedCartonId).toList();
    if(matchedCartons.isEmpty){
      emit(state.copyWith(status: DeliveryStatus.failure,errMsg: "Invalid CartonId/Bol Id"));
      return;
    }

    for (CartonModel carton in matchedCartons) {
      carton.scanned = true;
    }
    try {
      emit(state.copyWith(status: DeliveryStatus.progress));
      Set<CartonModel> mergedSet = {...cartonListCopy, ...matchedCartons};
      List<CartonModel> mergedList = mergedSet.toList();
      emit(state.copyWith(cartonList: [...mergedList],status: DeliveryStatus.scanCartonIdSuccess));
    } on Exception catch (e) {
      emit(state.copyWith(status: DeliveryStatus.failure));
      log.severe(e);
    }
  }

  void _deliveryItemSubmit(
      DeliveryItemSubmit event, Emitter<DeliveryState> emit) async {
    List<CartonModel> selectedCartonList = event.validatedCartonsList;
    emit(state.copyWith(status: DeliveryStatus.submit));
    List<CartonReceiveSubmitModel> modifiedList = selectedCartonList.map((e) => CartonReceiveSubmitModel(
        cartonID: e.cartonID,
        pickID: e.pickID,
        receivedBy: event.receivedBy,
        receivedLoc: event.locId
    )).toList();

    try {
      await pickingRepo.deliveryCartons(modifiedList);
      const newInitialState = DeliveryState();
      emit(newInitialState.copyWith(status: DeliveryStatus.submitted));
      await Future.delayed(const Duration(milliseconds: 5000));
      emit(newInitialState.copyWith(status: DeliveryStatus.initial));
    } on Exception catch (e) {
      emit(state.copyWith(status: DeliveryStatus.failure,errMsg: "Delivery items not Submitted"));
      log.severe(e);
    }
  }

  void _resetFailureStatus(
      DeliveryItemResetFailureState event, Emitter<DeliveryState> emit) async {
    emit(state.copyWith(status: DeliveryStatus.progress));
  }
}
