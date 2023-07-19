part of 'delivery_bloc.dart';

enum DeliveryStatus {
  initial,
  loading,
  success,
  failure,
  submit,
  submitted,
  searchIdLoading,
  searchIdSuccess,
  scanCartonIdLoading,
  scanCartonIdSuccess
}

class DeliveryState extends Equatable {
  final DeliveryStatus status;
  final String key;
  final String receiversId;
  final List<CartonModel> cartonList;
  final String errMsg;
  final String enteredCartonId;

  const DeliveryState({
    this.status = DeliveryStatus.initial,
    this.key = '',
    this.cartonList = const [],
    this.receiversId= "",
    this.errMsg='',
    this.enteredCartonId=''
  });

  DeliveryState copyWith({
    DeliveryStatus? status,
    String? key,
    List<CartonModel>? cartonList,
    String? receiversId,
    String? errMsg,
    String? enteredCartonId
  }) {
    return DeliveryState(
      status: status ?? this.status,
      key: key ?? this.key,
      cartonList: cartonList ?? this.cartonList,
        receiversId: receiversId?? this.receiversId,
        errMsg: errMsg?? this.errMsg,
        enteredCartonId: enteredCartonId?? this.enteredCartonId
    );
  }

  @override
  String toString() {
    return 'DeliveryState{status: $status, key: $key, cartonList: $cartonList }';
  }

  @override
  List<Object?> get props => [status, key, cartonList,receiversId,errMsg,enteredCartonId];
}
