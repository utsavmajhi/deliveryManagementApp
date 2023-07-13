part of 'info_bloc.dart';

enum InfoSelectionStatus {
  initial,
  loading,
  success,
  failure,
}

class InfoSelectionState extends Equatable {
  final InfoSelectionStatus status;
  final String key;
  final List<LocModel> locList;

  const InfoSelectionState({
    this.status = InfoSelectionStatus.initial,
    this.key = '',
    this.locList = const [],
  });

  InfoSelectionState copyWith({
    InfoSelectionStatus? status,
    String? key,
    List<LocModel>? locList,
    String? selectedWarehouse,
  }) {
    return InfoSelectionState(
      status: status ?? this.status,
      key: key ?? this.key,
      locList: locList ?? this.locList
    );
  }

  @override
  String toString() {
    return 'InfoSelectionState{status: $status, key: $key, warehousesList: $locList}';
  }

  @override
  List<Object?> get props => [status, key, locList];
}
