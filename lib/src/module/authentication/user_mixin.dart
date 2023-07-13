import '../../models/vehicle_model.dart';

class UserDetail {
  static String? _loggedInUser;
  static VehicleModel? _vehicle;


  static VehicleModel? get vehicle => _vehicle;

  static String? get loggedInUser => _loggedInUser;

  static void setLoggedInUser(String? user) {
    _loggedInUser = user;
  }

  static void setVehicleDetails(VehicleModel vehicleModel) {
    _vehicle = vehicleModel;
  }
}