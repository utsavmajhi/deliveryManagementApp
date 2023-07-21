import 'package:POD/src/models/vehicle_model.dart';
import 'package:POD/src/models/warehouse_list_model.dart';
import 'package:POD/src/module/authentication/bloc/authentication_bloc.dart';
import 'package:POD/src/module/authentication/user_mixin.dart';
import 'package:POD/src/module/dashboard/home_screen.dart';
import 'package:POD/src/module/vehicle_selection/bloc/vehicle_bloc.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_dropdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleSelectionScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => VehicleSelectionScreen());
  }

  @override
  _VehicleSelectionState createState() => _VehicleSelectionState();
}

class _VehicleSelectionState extends State<VehicleSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (context) =>
      FetchVehicleBloc(vehicleRepository: RepositoryProvider.of(context))
            ..add(FetchVehicleIdList()),
      child: WarehouseSelectionListBody(),
    );
  }
}

class WarehouseSelectionListBody extends StatelessWidget {
  String selectedWarehouse = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(
          title: const Text('Vehicle Selection Screen'),
          backgroundColor: Colors.green,
          leading: const Icon(
            Icons.warehouse, // Add your desired icon
            color: Colors.white, // Set the icon color
          ),
        ),
        body: BlocBuilder<FetchVehicleBloc, FetchVehicleState>(
          builder: (context, state) {
            switch (state.status) {
              case FetchVehiclesStatus.failure:
                return _buildErrorScreen(context);
              case FetchVehiclesStatus.success:
                return FetchVehicleSelectionBoard(
                  vehicleList: state.vehiclesList,
                );
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Oops!\nAn error occurred.", textAlign: TextAlign.center),
          ElevatedButton(
              onPressed: () => {
                    context.read<FetchVehicleBloc>().add(FetchVehicleIdList())
                  },
              child: const Text(
                "Retry",
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}

class FetchVehicleSelectionBoard extends StatelessWidget {
  List<VehicleModel> vehicleList;
  String selectedWarehouse = '';
  FetchVehicleSelectionBoard({
    Key? key,
    required this.vehicleList,
  }) : super(key: key);

  Future<List<String>> getVehicleNames() async {
    return vehicleList
        .map((item) => item.vehicleDesc)
        .whereType<String>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
          child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/images/warehouse.png',
                  fit: BoxFit.contain,
                )),
            const SizedBox(height: 20),
            VehicleDropDownSelector()
            // CustomDropDown<String>(
            //   label: 'Select Warehouse',
            //   asyncItems: (String filter) async {
            //     final storeNames = getVehicleNames();
            //     return storeNames;
            //   },
            //   itemAsString: (String? u) => u ?? '',
            //   onChanged: (String? value) {
            //     selectedWarehouse = value.toString();
            //   },
            // ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //     onPressed: () {
            //       WarehouseModel? getWarehouseDetails = warehouseList
            //           .firstWhere((obj) => obj.storeDesc == selectedWarehouse);
            //       print('MEOW CLICK SUBMIT ${getWarehouseDetails.storeDesc}');
            //       BlocProvider.of<AuthenticationBloc>(context).add(
            //           WarehouseSelectEvent(getWarehouseDetails.storeId,
            //               getWarehouseDetails.storeDesc));
            //       Navigator.of(context).push(HomeScreen.route());
            //     },
            //     style: ElevatedButton.styleFrom(
            //       primary: Colors.blue,
            //       onPrimary: Colors.white,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //     ),
            //     child: const Padding(
            //       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            //       child: Text(
            //         'Submit',
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ))
          ],
        ),
      ));
  }
}

class VehicleDropDownSelector extends StatefulWidget {
  @override
  _VehicleDropDownSelectorState createState() => _VehicleDropDownSelectorState();
}

class _VehicleDropDownSelectorState extends State<VehicleDropDownSelector> {
  String selectedValue = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authenticationStates = context.read<AuthenticationBloc>().state;

    return BlocBuilder<FetchVehicleBloc, FetchVehicleState>(builder: (context, state) {
      // if (state.status == FetchVehiclesStatus.submit) {
      //   textFieldFocusNode.unfocus(); // Shrink the keyboard when status is submit
      // }

      Future<List<String>> getVehicleNames() async {
        return state.vehiclesList
            .map((item) => item.vehicleDesc)
            .whereType<String>()
            .toList();
      }
      return Column(
        children: [
          CustomDropDown<String>(
            label: 'Select Vehicle Id',
            asyncItems: (String filter) async {
              final vehicleNames = getVehicleNames();
              return vehicleNames;
            },
            itemAsString: (String? u) => u ?? '',
            onChanged: (String? value) {
              selectedValue = value.toString();
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                VehicleModel? getVehicleDetails = state.vehiclesList
                    .firstWhere((obj) => obj.vehicleDesc == selectedValue);
                print('MEOW CLICK SUBMIT ${getVehicleDetails.vehicleDesc}');
                BlocProvider.of<AuthenticationBloc>(context).add(
                    VehicleSelectEvent(getVehicleDetails.vehicleID,
                        getVehicleDetails.vehicleDesc,getVehicleDetails.typeOfVehicle));
                UserDetail.setVehicleDetails(VehicleModel(vehicleID:getVehicleDetails.vehicleID,
                vehicleDesc: getVehicleDetails.vehicleDesc,typeOfVehicle: getVehicleDetails.typeOfVehicle));
                Navigator.of(context).push(HomeScreen.route());
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ))
        ],

      );
    });
  }
}
