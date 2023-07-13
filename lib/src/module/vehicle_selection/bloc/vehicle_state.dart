part of 'vehicle_bloc.dart';

enum FetchVehiclesStatus {
  initial,
  loading,
  success,
  failure,
}

class FetchVehicleState extends Equatable {
  final FetchVehiclesStatus status;
  final String key;
  final List<WarehouseModel> warehousesList;
  final List<VehicleModel> vehiclesList;

  const FetchVehicleState({
    this.status = FetchVehiclesStatus.initial,
    this.key = '',
    this.warehousesList = const [],
    this.vehiclesList = const [],
  });

  FetchVehicleState copyWith({
    FetchVehiclesStatus? status,
    String? key,
    List<WarehouseModel>? warehousesList,
    String? selectedWarehouse,
    List<VehicleModel>? vehiclesList,

  }) {
    return FetchVehicleState(
      status: status ?? this.status,
      key: key ?? this.key,
      warehousesList: warehousesList ?? this.warehousesList,
        vehiclesList:vehiclesList ?? this.vehiclesList
    );

  }

  @override
  String toString() {
    return 'FetchVehicleState{status: $status, key: $key, vehiclesList: $vehiclesList}';
  }

  @override
  List<Object?> get props => [status, key, warehousesList,vehiclesList];
}
