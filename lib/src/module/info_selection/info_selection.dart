import 'package:delivery_management_app/src/models/loc_model.dart';
import 'package:delivery_management_app/src/models/vehicle_model.dart';
import 'package:delivery_management_app/src/models/warehouse_list_model.dart';
import 'package:delivery_management_app/src/module/authentication/bloc/authentication_bloc.dart';
import 'package:delivery_management_app/src/module/dashboard/home_screen.dart';
import 'package:delivery_management_app/src/module/delivery_order/delivery_order.dart';
import 'package:delivery_management_app/src/module/info_selection/bloc/info_bloc.dart';
import 'package:delivery_management_app/src/module/info_selection/bloc/info_bloc.dart';
import 'package:delivery_management_app/src/module/info_selection/bloc/info_bloc.dart';
import 'package:delivery_management_app/src/module/info_selection/bloc/info_bloc.dart';
import 'package:delivery_management_app/src/module/login/verification_user.dart';
import 'package:delivery_management_app/src/module/picking_order/picking_order.dart';
import 'package:delivery_management_app/src/module/vehicle_selection/bloc/vehicle_bloc.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_dropdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InfoSelectionScreen extends StatefulWidget {
  final String actionType;

  InfoSelectionScreen({super.key, required this.actionType});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => InfoSelectionScreen(actionType: '',));
  }

  @override
  _InfoSelectionState createState() => _InfoSelectionState();
}

class _InfoSelectionState extends State<InfoSelectionScreen> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (context) =>
      InfoSelectionBloc(warehouseRepo: RepositoryProvider.of(context))
        ..add(FetchAllLocations()),
      child: LocationSelectionListBody(actionType: widget.actionType,),
    );
  }
}

class LocationSelectionListBody extends StatelessWidget {
  final String actionType;
  String selectedWarehouse = '';
  LocationSelectionListBody({ required this.actionType});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(
          title: Text(actionType == "PICKING" ? 'Pickup Location' : 'Delivery Location'),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),

        body: BlocBuilder<InfoSelectionBloc, InfoSelectionState>(
          builder: (context, state) {
            switch (state.status) {
              case InfoSelectionStatus.failure:
                return _buildErrorScreen(context);
              case InfoSelectionStatus.success:
                return FetchInfoSelectionBoard(
                  locationList: state.locList,
                  actionType: actionType
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
                context.read<InfoSelectionBloc>().add(FetchAllLocations())
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

class FetchInfoSelectionBoard extends StatelessWidget {
  List<LocModel> locationList;
  String actionType;
  String selectedWarehouse = '';
  FetchInfoSelectionBoard({
    Key? key,
    required this.locationList, required  this.actionType,
  }) : super(key: key);

  Future<List<String>> getLocationNames() async {
    return locationList
        .map((item) => item.locDesc)
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
              LocationDropDownSelector(actionType: actionType)
            ],
          ),
        ));
  }
}

class LocationDropDownSelector extends StatefulWidget {
  final String actionType;
  LocationDropDownSelector({super.key, required this.actionType});

  @override
  _LocationDropDownSelectorState createState() => _LocationDropDownSelectorState(actionType:actionType);
}

class _LocationDropDownSelectorState extends State<LocationDropDownSelector> {
  String selectedValue = "";
  String actionType;
  _LocationDropDownSelectorState({ required this.actionType});

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
    return BlocBuilder<InfoSelectionBloc, InfoSelectionState>(builder: (context, state) {
      Future<List<String>> getLocationNames() async {
        return state.locList
            .map((item) => item.locDesc)
            .whereType<String>()
            .toList();
      }
      return Column(
        children: [
          CustomDropDown<String>(
            label: actionType == "PICKING"? "Select Pickup Location": 'Select Delivery Location',
            asyncItems: (String filter) async {
              final locNames = getLocationNames();
              return locNames;
            },
            itemAsString: (String? u) => u ?? '',
            onChanged: (String? value) {
              selectedValue = value.toString();
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                if(selectedValue.isEmpty){
                  _showSnackBar(context, "Please! Select Location", Colors.red);
                  return;
                }
                LocModel? getAllLocations = state.locList
                    .firstWhere((obj) => obj.locDesc == selectedValue);
                BlocProvider.of<AuthenticationBloc>(context).add(
                    LocSelectEvent(getAllLocations.locID,
                        getAllLocations.locDesc,getAllLocations.locType));
                if(actionType == "PICKING"){
                  Navigator.of(context).push(PickingOrder.route());
                }else if(actionType == "DELIVERY"){
                  Navigator.of(context).push(DeliveryOrder.route());
                }
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

void _showSnackBar(BuildContext context, String message, Color color) {
  final snackBar = SnackBar(content: Text(message), backgroundColor: color);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
