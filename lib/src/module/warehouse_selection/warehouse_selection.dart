import 'package:delivery_management_app/src/models/warehouse_list_model.dart';
import 'package:delivery_management_app/src/module/authentication/bloc/authentication_bloc.dart';
import 'package:delivery_management_app/src/module/dashboard/home_screen.dart';
import 'package:delivery_management_app/src/module/warehouse_selection/bloc/warehouse_bloc.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_dropdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarehouseSelectionScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => WarehouseSelectionScreen());
  }

  @override
  _WarehouseScreenState createState() => _WarehouseScreenState();
}

class _WarehouseScreenState extends State<WarehouseSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (context) =>
          FetchWarehouseBloc(warehouseRepo: RepositoryProvider.of(context))
            ..add(FetchWarehouseList()),
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
          title: const Text('Warehouse Screen'),
          backgroundColor: Colors.green,
          leading: const Icon(
            Icons.warehouse, // Add your desired icon
            color: Colors.white, // Set the icon color
          ),
        ),
        body: BlocBuilder<FetchWarehouseBloc, FetchWarehouseState>(
          builder: (context, state) {
            switch (state.status) {
              case FetchWarehouseStatus.failure:
                return _buildErrorScreen(context);
              case FetchWarehouseStatus.success:
                return WarehouseSelectionBoard(
                  warehouseList: state.warehousesList,
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
                    context.read<FetchWarehouseBloc>().add(FetchWarehouseList())
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

class WarehouseSelectionBoard extends StatelessWidget {
  List<WarehouseModel> warehouseList;
  String selectedWarehouse = '';
  WarehouseSelectionBoard({
    Key? key,
    required this.warehouseList,
  }) : super(key: key);

  Future<List<String>> getStoreNames() async {
    return warehouseList
        .map((item) => item.storeDesc)
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
            CustomDropDown<String>(
              label: 'Select Warehouse',
              asyncItems: (String filter) async {
                final storeNames = getStoreNames();
                return storeNames;
              },
              itemAsString: (String? u) => u ?? '',
              onChanged: (String? value) {
                selectedWarehouse = value.toString();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  WarehouseModel? getWarehouseDetails = warehouseList
                      .firstWhere((obj) => obj.storeDesc == selectedWarehouse);
                  print('MEOW CLICK SUBMIT ${getWarehouseDetails.storeDesc}');
                  BlocProvider.of<AuthenticationBloc>(context).add(
                      WarehouseSelectEvent(getWarehouseDetails.storeId,
                          getWarehouseDetails.storeDesc));
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
        ),
      ));
  }
}
