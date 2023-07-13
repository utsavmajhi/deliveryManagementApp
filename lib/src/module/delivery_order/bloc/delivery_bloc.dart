import 'dart:async';

import 'package:delivery_management_app/src/models/carton_model.dart';
import 'package:delivery_management_app/src/models/carton_pick_model.dart';
import 'package:delivery_management_app/src/models/error_model.dart';
import 'package:delivery_management_app/src/repository/picking_repo.dart';
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
    on<DeliveryItemEnteredId>(_setSelectedCartonsId);
    on<DeliveryItemDelete>(_deleteCartonItemFromList);
    on<DeliveryItemResetFailureState>(_resetFailureStatus);
    on<DeliveryItemSubmit>(_deliveryItemSubmit);

  }

  void _getCartonsById(
      DeliveryItemAdd event, Emitter<DeliveryState> emit) async {
    emit(state.copyWith(status: DeliveryStatus.searchIdLoading));
    await Future.delayed(const Duration(milliseconds: 100));
    String id = event.id;
    try {
      log.info("Getting getAllCartons list");
      var resp = await pickingRepo.getCartonListById(id,event.storeId,"receive");
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

  void _setSelectedCartonsId(
      DeliveryItemEnteredId event, Emitter<DeliveryState> emit) async {
    String id = event.bolCartonId;
    try {
      emit(state.copyWith(enteredBolCartonId:id));
    } on Exception catch (e) {
      emit(state.copyWith(status: DeliveryStatus.failure));
      log.severe(e);
    }
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

  void _deliveryItemSubmit(
      DeliveryItemSubmit event, Emitter<DeliveryState> emit) async {
    List<CartonModel> selectedCartonList = event.validatedCartonsList;
    emit(state.copyWith(status: DeliveryStatus.submit));
    List<CartonPickModel> modifiedList = selectedCartonList.map((e) => CartonPickModel(
      cartonID: e.cartonID,
      storeID:event.warehouse.id,
      storeDesc: event.warehouse.name,
      user: event.userId
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
    emit(state.copyWith(status: DeliveryStatus.initial));
  }
}
