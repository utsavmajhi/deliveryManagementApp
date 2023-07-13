import 'dart:convert';

import 'package:delivery_management_app/src/models/carton_history.dart';
import 'package:delivery_management_app/src/models/carton_model.dart';
import 'package:delivery_management_app/src/models/warehouse_list_model.dart';
import 'package:logging/logging.dart';
import '../models/carton_pick_model.dart';
import '../util/helper/rest_api.dart';

class PickingRepository {
  final log = Logger('PickingRepository');

  final RestApiClient restClient;

  PickingRepository({required this.restClient});

  Future<List<CartonModel>> getCartonListById(String id, String storeId,String type) async {
    log.info("Fetching Carton list /getCartonsById?requestID=${id}&storeID=${storeId}");
    var resp = await restClient.get(
        restOptions: RestOptions(
            path: "/getCartonsById?requestID=${id}&storeID=${storeId}&type=${type}",
            queryParameters: {
              "requestID": id,
              "storeID": storeId,
              "type":type
        }
        ));
    var rawList = restClient.parsedResponse(resp);
    List<CartonModel> cartonList = (rawList['cartons'] as List<dynamic>)
        .map((item) => CartonModel.fromJson(item))
        .toList();
    return cartonList;
  }

  dynamic pickCartons(List<CartonPickModel> cartonPickedList) async {
    log.info("Picked Cartons Submit");
    Map<String, dynamic> data = {"items":cartonPickedList};
    String body = jsonEncode(data);
    var resp = await restClient.post(
        restOptions: RestOptions(
            path: "/pickCartons",
            body: body
        ));
    var rawList = restClient.parsedResponse(resp);
    return rawList;
  }

  dynamic deliveryCartons(List<CartonPickModel> cartonPickedList) async {
    log.info("Picked Cartons Submit");
    Map<String, dynamic> data = {"items":cartonPickedList};
    String body = jsonEncode(data);
    var resp = await restClient.post(
        restOptions: RestOptions(
            path: "/receiveCartons",
            body: body
        ));
    var rawList = restClient.parsedResponse(resp);
    return rawList;
  }

  Future<List<CartonHistory>> getCartonHistoryById(String id) async {
    log.info("Fetching Carton history");
    var resp = await restClient.get(
        restOptions: RestOptions(
            path: "/trackCartons?cartonID=${id}",
            queryParameters: {
              "cartonID": id,
            }
        ));
    var rawList = restClient.parsedResponse(resp);
    List<CartonHistory> cartonResList = (rawList['cartonHistory'] as List<dynamic>)
        .map((item) => CartonHistory.fromJson(item))
        .toList();
    return cartonResList;
  }
}