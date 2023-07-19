import 'package:delivery_management_app/src/models/carton_model.dart';
import 'package:delivery_management_app/src/module/authentication/bloc/authentication_bloc.dart';
import 'package:delivery_management_app/src/module/authentication/user_mixin.dart';
import 'package:delivery_management_app/src/module/dashboard/home_screen.dart';
import 'package:delivery_management_app/src/module/delivery_order/bloc/delivery_bloc.dart';
import 'package:delivery_management_app/src/module/picking_order/bloc/picking_bloc.dart';
import 'package:delivery_management_app/src/module/picking_order/picking_order.dart';
import 'package:delivery_management_app/src/widgets/curving_container.dart';
import 'package:delivery_management_app/src/widgets/custom_circular_button.dart';
import 'package:delivery_management_app/src/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class DeliveryOrder extends StatelessWidget {
  const DeliveryOrder({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const DeliveryOrder());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final authenticationStates = context.read<AuthenticationBloc>().state;
    print("MEOW LOC DETAILS ${authenticationStates.location?.locID}");
    return BlocProvider(
      create: (context) => DeliveryBloc(pickingRepo: RepositoryProvider.of(context))..add(DeliveryItemsFetchByVehicleId(UserDetail.vehicle?.vehicleID??"")),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            'Delivery Screen',
            style: TextStyle(
              fontFamily: 'Montserrat Medium',
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.of(context).pop(HomeScreen.route());
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            CurvingContainer(size: size / 1.4),
            SafeArea(
              child: BlocConsumer<DeliveryBloc, DeliveryState>(
                listener: (context, state) {
                  if(state.status == DeliveryStatus.failure){
                    _showSnackBar(context,state.errMsg,Colors.red);
                    BlocProvider.of<DeliveryBloc>(context).add(
                        DeliveryItemResetFailureState());
                  }
                },
                builder: (context, state) {
                  var uniqueBolObjSet = <String>{};
                  var uniqueScannedBolObjSet = <String>{};

                  for (var obj in state.cartonList) {
                    var desc = obj.bolID;
                    if(obj.scanned){
                      uniqueScannedBolObjSet.add(desc!);
                    }
                    uniqueBolObjSet.add(desc!);
                  }
                  return IgnorePointer(
                    ignoring: state.status == DeliveryStatus.submit,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 64,
                            margin: const EdgeInsets.only(bottom: 20),
                            child:  Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.warehouse,size: 20,color: Colors.white,),
                                        SizedBox(width: 5,),
                                        Container(
                                          width: 250,
                                          child: Text(
                                            "Delivery Location: ${authenticationStates.location?.locDesc}",
                                            style: TextStyle(
                                              fontFamily: 'Montserrat Medium',
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            softWrap: true,
                                            maxLines: 3, // Set the maximum number of lines to 2 or any desired value
                                            overflow: TextOverflow.ellipsis, // Truncate the text with an ellipsis
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          CustomTextEditingField(),
                          const SizedBox(height: 10),
                          if(state.cartonList.isEmpty)
                            Center(
                              child: state.status == DeliveryStatus.searchIdLoading? CircularProgressIndicator()
                                  :
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("No Active Records Found", textAlign: TextAlign.center),
                                  ElevatedButton(
                                      onPressed: () => {
                                      BlocProvider.of<DeliveryBloc>(context).add(
                                      DeliveryItemsFetchByVehicleId(UserDetail.vehicle?.vehicleID??""))
                                      },
                                      child: const Text(
                                        "Retry",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ))
                                ],
                              ),
                            ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.cartonList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: state.cartonList[index].scanned? Colors.green:Colors.grey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ListTile(
                                    title: Text(state.cartonList[index].cartonID??""),
                                    leading: state.cartonList[index].scanned ? Icon(Icons.verified,size: 30):Icon(Icons.qr_code_scanner,size: 30),
                                    iconColor:state.cartonList[index].scanned ? Colors.lightGreen:Colors.grey,
                                    subtitle: Text("Bol No: ${state.cartonList[index].bolID??""}"),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete,color: Colors.black26,),
                                      onPressed: () {
                                        BlocProvider.of<DeliveryBloc>(context).add(
                                            DeliveryItemDelete(state.cartonList[index]));
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              Container(
                                child: Text(
                                  'Bol: ${uniqueBolObjSet.length} Con: ${state.cartonList.length}',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat Medium',
                                    // color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(HomeScreen.route());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 24),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if(state.receiversId.length == 0){
                                        _showSnackBar(context, "Please Provider Receiver's Id", Colors.red);
                                        return;
                                      }
                                      if(uniqueScannedBolObjSet.isNotEmpty){
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return Container(
                                              padding: const EdgeInsets.all(20.0),
                                              height: MediaQuery.of(context).size.height * 0.8,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20.0),
                                                  topRight: Radius.circular(20.0),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      const Row(
                                                        children: [
                                                          Icon(Icons.summarize_outlined),
                                                          SizedBox(width: 10,),
                                                          Text(
                                                            'Summary',
                                                            style: TextStyle(
                                                              fontFamily: 'Montserrat Medium',
                                                              color: Colors.green,
                                                              fontSize: 25,
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(Icons.close),
                                                        onPressed: () {
                                                          Navigator.pop(context); // Close the modal sheet
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Center(
                                                        child: ListView.builder(
                                                            itemCount: uniqueScannedBolObjSet.length,
                                                            itemBuilder: (BuildContext context,int index){
                                                              var bolID =
                                                              uniqueScannedBolObjSet.elementAt(index);
                                                              var groupedItems = state.cartonList
                                                                  .where(
                                                                      (item) => item.bolID == bolID && item.scanned)
                                                                  .toList();
                                                              return Container(
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                    color: Colors.grey,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                ),
                                                                margin: const EdgeInsets.symmetric(
                                                                    vertical: 4.0),
                                                                child: ExpansionTile(
                                                                  initiallyExpanded: true,
                                                                  title: Text('BOL ID: ${bolID}'),
                                                                  leading: Icon(Icons.format_bold_outlined),
                                                                  children: groupedItems.map((item){
                                                                    return ListTile(
                                                                      leading: Icon(Icons.verified,size: 30),
                                                                      iconColor:Colors.lightGreen,
                                                                      title: Text(item.cartonID??''),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              );
                                                            })
                                                    ),
                                                  ),
                                                  ElevatedButton(onPressed: (){
                                                    Navigator.of(context).pop("submitted");
                                                  },
                                                    style: ElevatedButton.styleFrom(
                                                      primary: Colors.blue,
                                                      onPrimary: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),), child: const Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                                      child: Text(
                                                        'Submit',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),)
                                                ],
                                              ),
                                            );
                                          },
                                        ).then((value){
                                          if(value == "submitted"){
                                            List<CartonModel> eligibleCartons = state.cartonList.where((carton) => carton.scanned == true).toList();
                                            BlocProvider.of<DeliveryBloc>(context).add(
                                                DeliveryItemSubmit(eligibleCartons,UserDetail.loggedInUser!,state.receiversId,authenticationStates.location?.locID??""));
                                          }
                                        });
                                      }

                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: uniqueScannedBolObjSet.isEmpty? Colors.grey:Colors.blue,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                      child: Text(
                                        'Continue',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            BlocBuilder<DeliveryBloc, DeliveryState>(builder: (context, state) {
              switch (state.status) {
                case DeliveryStatus.submit:
                  return const Positioned(
                    child: CustomDialog(
                      message: 'Please Wait!',
                      lottieAssetPath: 'assets/lottie/loading.zip',
                    ),
                  );
                case DeliveryStatus.submitted:{
                  BlocProvider.of<DeliveryBloc>(context).add(
                      DeliveryItemsFetchByVehicleId(UserDetail.vehicle?.vehicleID??""));
                  return const Positioned(
                    child: CustomDialog(
                      message: 'Done!',
                      lottieAssetPath: 'assets/lottie/test.json',
                    ),
                  );
                }
                default:
                  return const SizedBox.shrink();
              }
            })
          ],
        ),
      ),
    );
  }
}

class CustomTextEditingField extends StatefulWidget {
  @override
  _CustomTextEditingFieldState createState() => _CustomTextEditingFieldState();
}

class _CustomTextEditingFieldState extends State<CustomTextEditingField> {
  final TextEditingController textFieldController = TextEditingController();
  final TextEditingController cartonIdScannerFieldController = TextEditingController();

  final FocusNode textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    textFieldFocusNode.requestFocus();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }

  String getTextFromTextField() {
    return textFieldController.text;
  }

  String getTextFromCartonIDTextField() {
    return cartonIdScannerFieldController.text;
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryBloc, DeliveryState>(builder: (context, state) {
      if (state.status == DeliveryStatus.submit) {
        textFieldFocusNode.unfocus(); // Shrink the keyboard when status is submit
        textFieldController.clear();
      }
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CupertinoSearchTextField(
                      placeholder: "Scan Carton ID",
                      borderRadius: BorderRadius.circular(10),
                      prefixInsets: const EdgeInsets.only(
                        left: 15,
                        right: 10,
                        top: 10,
                        bottom: 10,
                      ),
                      suffixInsets: const EdgeInsets.all(10),
                      prefixIcon: const Icon(
                        CupertinoIcons.barcode,
                        size: 22,
                      ),
                      onSubmitted: (value) {
                        BlocProvider.of<DeliveryBloc>(context).add(
                          DeliveryItemValidateCartonId(value),
                        );
                        cartonIdScannerFieldController.clear();
                      },
                      controller: cartonIdScannerFieldController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularButton(
                      state: state.status == DeliveryStatus.scanCartonIdLoading
                          ? CircularButtonState.loading
                          : CircularButtonState.idle,
                      idleIcon: Icons.arrow_forward_ios,
                      onPressed: () {
                        if (state.status != DeliveryStatus.scanCartonIdLoading) {
                          BlocProvider.of<DeliveryBloc>(context).add(
                            DeliveryItemValidateCartonId(
                                getTextFromCartonIDTextField()
                            ),
                          );
                          cartonIdScannerFieldController.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(label: 'Enter Receiver Id',onValueChange: (e){
                      BlocProvider.of<DeliveryBloc>(context).add(
                        DeliveryItemReceiverEnteredId(
                          getTextFromTextField()),
                      );
                    },
                    controller: textFieldController,)
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
void _showSnackBar(BuildContext context, String message,Color color) {
  final snackBar = SnackBar(content: Text(message),backgroundColor: color);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
