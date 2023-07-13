part of 'warehouse_bloc.dart';

@immutable
abstract class FetchWarehouseEvent {}

class FetchWarehouseList extends FetchWarehouseEvent{
  FetchWarehouseList();
}