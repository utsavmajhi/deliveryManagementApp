part of 'picking_bloc.dart';

enum PickingStatus {
  initial,
  loading,
  success,
  failure,
  submit,
  submitted,
  searchIdLoading,
  searchIdSuccess
}

class PickingState extends Equatable {
  final PickingStatus status;
  final String key;
  final List<CartonModel> cartonList;
  final String errMsg;

  const PickingState({
    this.status = PickingStatus.initial,
    this.key = '',
    this.cartonList = const [],
    this.errMsg=''
  });

  PickingState copyWith({
    PickingStatus? status,
    String? key,
    List<CartonModel>? cartonList,
    String? enteredBolCartonId,
    String? errMsg
  }) {
    return PickingState(
      status: status ?? this.status,
      key: key ?? this.key,
      cartonList: cartonList ?? this.cartonList,
        errMsg: errMsg?? this.errMsg
    );
  }

  @override
  String toString() {
    return 'PickingState{status: $status, key: $key, cartonList: $cartonList}';
  }

  @override
  List<Object?> get props => [status, key, cartonList,errMsg];
}
