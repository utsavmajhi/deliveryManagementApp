part of 'delivery_bloc.dart';

enum DeliveryStatus {
  initial,
  loading,
  success,
  failure,
  submit,
  submitted,
  searchIdLoading,
  searchIdSuccess
}

class DeliveryState extends Equatable {
  final DeliveryStatus status;
  final String key;
  final String enteredBolCartonId;
  final List<CartonModel> cartonList;
  final String errMsg;

  const DeliveryState({
    this.status = DeliveryStatus.initial,
    this.key = '',
    this.cartonList = const [],
    this.enteredBolCartonId= "",
    this.errMsg=''
  });

  DeliveryState copyWith({
    DeliveryStatus? status,
    String? key,
    List<CartonModel>? cartonList,
    String? enteredBolCartonId,
    String? errMsg
  }) {
    return DeliveryState(
      status: status ?? this.status,
      key: key ?? this.key,
      cartonList: cartonList ?? this.cartonList,
        enteredBolCartonId: enteredBolCartonId?? this.enteredBolCartonId,
        errMsg: errMsg?? this.errMsg
    );
  }

  @override
  String toString() {
    return 'DeliveryState{status: $status, key: $key, cartonList: $cartonList}';
  }

  @override
  List<Object?> get props => [status, key, cartonList,enteredBolCartonId,errMsg];
}
