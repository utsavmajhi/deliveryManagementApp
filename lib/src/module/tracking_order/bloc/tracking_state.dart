part of 'tracking_bloc.dart';

enum TrackingStatus {
  initial,
  loading,
  success,
  failure,
  submit,
  submitted
}

class TrackingState extends Equatable {
  final TrackingStatus status;
  final String key;
  final String enteredBolCartonId;
  final List<CartonHistory> cartonHistoryList;
  final String errMsg;

  const TrackingState({
    this.status = TrackingStatus.initial,
    this.key = '',
    this.cartonHistoryList = const [],
    this.enteredBolCartonId= "",
    this.errMsg=''
  });

  TrackingState copyWith({
    TrackingStatus? status,
    String? key,
    List<CartonHistory>? cartonHistoryList,
    String? enteredBolCartonId,
    String? errMsg
  }) {
    return TrackingState(
      status: status ?? this.status,
      key: key ?? this.key,
      cartonHistoryList: cartonHistoryList ?? this.cartonHistoryList,
        enteredBolCartonId: enteredBolCartonId?? this.enteredBolCartonId,
        errMsg: errMsg?? this.errMsg
    );
  }

  @override
  String toString() {
    return 'TrackingState{status: $status, key: $key, cartonHistoryList: $cartonHistoryList}';
  }

  @override
  List<Object?> get props => [status, key, cartonHistoryList,enteredBolCartonId,errMsg];
}
