import 'package:delivery_management_app/src/models/warehouse_list_model.dart';
import 'package:logging/logging.dart';
import '../util/helper/rest_api.dart';

class WarehouseRepository {
  final log = Logger('WarehouseRepository');

  // Response resp = Response(
  //   "[{\"pickId\":\"10001\",\"pickUser\":\"USR001\",\"fulfillmentId\":\"QTAE00000010001_1\",\"customerOrderId\":\"QTAE00000010001\",\"storeId\":\"101\",\"customerId\":\"CP432324242\",\"orderType\":\"PURCHASE\",\"deliveryType\":\"90MinutesDelivery\",\"deliveryDate\":\"2022-08-05T05:50:49Z\",\"deliveryWindow\":\"\",\"orderStatus\":\"READY_FOR_PICK\",\"comment\":\"\",\"orderDate\":\"2022-08-04T05:50:49Z\",\"shipmentCarrierId\":\"UPS\",\"allowPartialDelivery\":\"N\",\"department\":\"Home\"},{\"pickId\":\"10002\",\"pickUser\":\"USR001\",\"fulfillmentId\":\"QTAE00000010004_1\",\"customerOrderId\":\"QTAE00000010004\",\"storeId\":\"101\",\"customerId\":\"CP430424242\",\"orderType\":\"PURCHASE\",\"deliveryType\":\"90MinutesDelivery\",\"deliveryDate\":\"2022-08-05T05:50:49Z\",\"deliveryWindow\":\"\",\"orderStatus\":\"READY_FOR_PICK\",\"comment\":\"\",\"orderDate\":\"2022-08-04T05:50:49Z\",\"shipmentCarrierId\":\"UPS\",\"allowPartialDelivery\":\"N\",\"department\":\"Home\"},{\"pickId\":\"10003\",\"pickUser\":\"USR001\",\"fulfillmentId\":\"QTAE00000010007_1\",\"customerOrderId\":\"QTAE00000010007\",\"storeId\":\"101\",\"customerId\":\"CP432124242\",\"orderType\":\"PURCHASE\",\"deliveryType\":\"90MinutesDelivery\",\"deliveryDate\":\"2022-08-05T05:50:49Z\",\"deliveryWindow\":\"\",\"orderStatus\":\"READY_FOR_PICK\",\"comment\":\"\",\"orderDate\":\"2022-08-04T05:50:49Z\",\"shipmentCarrierId\":\"UPS\",\"allowPartialDelivery\":\"N\",\"department\":\"Home\"},{\"pickId\":\"10004\",\"pickUser\":\"USR001\",\"fulfillmentId\":\"QTAE00000010008_1\",\"customerOrderId\":\"QTAE00000010008\",\"storeId\":\"101\",\"customerId\":\"CP432424742\",\"orderType\":\"PURCHASE\",\"deliveryType\":\"90MinutesDelivery\",\"deliveryDate\":\"2022-08-05T05:50:49Z\",\"deliveryWindow\":\"\",\"orderStatus\":\"READY_FOR_PICK\",\"comment\":\"\",\"orderDate\":\"2022-08-04T05:50:49Z\",\"shipmentCarrierId\":\"UPS\",\"allowPartialDelivery\":\"N\",\"department\":\"Home\"},{\"pickId\":\"10005\",\"pickUser\":\"USR001\",\"fulfillmentId\":\"QTAE00000010009_1\",\"customerOrderId\":\"QTAE00000010009\",\"storeId\":\"101\",\"customerId\":\"CP432494242\",\"orderType\":\"PURCHASE\",\"deliveryType\":\"90MinutesDelivery\",\"deliveryDate\":\"2022-08-05T05:50:49Z\",\"deliveryWindow\":\"\",\"orderStatus\":\"READY_FOR_PICK\",\"comment\":\"\",\"orderDate\":\"2022-08-04T05:50:49Z\",\"shipmentCarrierId\":\"UPS\",\"allowPartialDelivery\":\"N\",\"department\":\"Home\"}]",
  //   200
  // );
  //
  // Response detailsResp = Response(
  //     "{\"picklines\":[{\"id\":\"1231\",\"itemId\":\"10452171\",\"fulOrdPickId\":\"50001\",\"fulOrdId\":\"QTAE00000010008_1\",\"fulOrdLineItemId\":\"1\",\"preferredUom\":\"EA\",\"quantitySuggested\":5,\"quantityPicked\":0,\"caseSize\":\"1\",\"lineItemOrdinal\":\"1\",\"barcode\":\"10452171\",\"item\":{\"active\":null,\"arrival_date\":null,\"brand\":null,\"child_skus\":null,\"core_product\":null,\"date_available\":null,\"default_product_listing_sku\":null,\"description\":\"FranklinSportsFootballShuffleboardGame\",\"discountable\":null,\"display_name\":\"Franklin Sports Football Shuffleboard Game\",\"height\":null,\"id\":\"10452171\",\"length\":null,\"long_description\":null,\"nonreturnable\":null,\"online_only\":null,\"order_limit\":null,\"primary_thumb_image_url\":\"https://slimages.macysassets.com/is/image/MCY/products/3/optimized/16075283_fpx.tif\",\"route\":null,\"shippable\":null,\"tax_code\":null,\"type\":null,\"weight\":null,\"width\":null}},{\"id\":\"1232\",\"itemId\":\"11803071\",\"fulOrdPickId\":\"50001\",\"fulOrdId\":\"QTAE00000010008_1\",\"fulOrdLineItemId\":\"2\",\"preferredUom\":\"EA\",\"quantitySuggested\":3,\"quantityPicked\":0,\"caseSize\":\"1\",\"lineItemOrdinal\":\"2\",\"barcode\":\"11803071\",\"item\":{\"active\":null,\"arrival_date\":null,\"brand\":null,\"child_skus\":null,\"core_product\":null,\"creation_date\":null,\"date_available\":null,\"default_product_listing_sku\":null,\"description\":\"KryptonicsLongboardCompleteSkateboard\",\"discountable\":null,\"display_name\":\"Kryptonics Longboard Complete Skateboard\",\"height\":null,\"id\":\"11803071\",\"length\":null,\"long_description\":null,\"nonreturnable\":null,\"online_only\":null,\"order_limit\":null,\"primary_thumb_image_url\":\"https://slimages.macysassets.com/is/image/MCY/products/2/optimized/18206092_fpx.tif\",\"route\":null,\"shippable\":null,\"tax_code\":null,\"type\":null,\"weight\":null,\"width\":null}},{\"id\":\"1233\",\"itemId\":\"10053989\",\"fulOrdPickId\":\"50001\",\"fulOrdId\":\"QTAE00000010008_1\",\"fulOrdLineItemId\":\"3\",\"preferredUom\":\"EA\",\"quantitySuggested\":3,\"quantityPicked\":0,\"caseSize\":\"2\",\"lineItemOrdinal\":\"3\",\"barcode\":\"10053989\",\"item\":{\"active\":null,\"arrival_date\":null,\"brand\":null,\"child_skus\":null,\"core_product\":null,\"creation_date\":null,\"date_available\":null,\"default_product_listing_sku\":null,\"description\":\"Thames&KosmosSteppingIntoScience\",\"discountable\":null,\"display_name\":\"Thames & Kosmos Stepping Into Science\",\"height\":null,\"id\":\"10053989\",\"length\":null,\"long_description\":null,\"nonreturnable\":null,\"online_only\":null,\"order_limit\":null,\"primary_thumb_image_url\":\"https://slimages.macysassets.com/is/image/MCY/products/9/optimized/14594649_fpx.tif\",\"route\":null,\"shippable\":null,\"tax_code\":null,\"type\":null,\"weight\":null,\"width\":null}}]}",
  //     200
  // );

  final RestApiClient restClient;

  WarehouseRepository({required this.restClient});

  Future<String> getWarehouseDetail(String barcode) async {
    log.info("Fethching warehouse details for barcode: $barcode");
    return "Abstract Warehouse";
  }

  Future<List<WarehouseModel>> getWarehouseList() async {
    log.info("Fetching warehouses list");
    var resp = await restClient.get(
        restOptions: RestOptions(
          path: "/allLoc"
        ));
    var rawList = restClient.parsedResponse(resp);
    List<dynamic> storesList = rawList['stores'].toList();
    return storesList.map((e) => WarehouseModel.fromJson(e)).toList();
  }
}