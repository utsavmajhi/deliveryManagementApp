part of 'warehouse_bloc.dart';

enum FetchWarehouseStatus {
  initial,
  loading,
  success,
  failure,
}

class FetchWarehouseState extends Equatable {
  final FetchWarehouseStatus status;
  final String key;
  final List<WarehouseModel> warehousesList;
  final String selectedWarehouse;

  const FetchWarehouseState({
    this.status = FetchWarehouseStatus.initial,
    this.key = '',
    this.warehousesList = const [],
    this.selectedWarehouse = '',
  });

  FetchWarehouseState copyWith({
    FetchWarehouseStatus? status,
    String? key,
    List<WarehouseModel>? warehousesList,
    String? selectedWarehouse,
  }) {
    return FetchWarehouseState(
      status: status ?? this.status,
      key: key ?? this.key,
      warehousesList: warehousesList ?? this.warehousesList,
      selectedWarehouse: selectedWarehouse ?? this.selectedWarehouse,
    );
  }

  @override
  String toString() {
    return 'FetchWarehouseState{status: $status, key: $key, warehousesList: $warehousesList, selectedWarehouse: $selectedWarehouse}';
  }

  @override
  List<Object?> get props => [status, key, warehousesList, selectedWarehouse];
}
