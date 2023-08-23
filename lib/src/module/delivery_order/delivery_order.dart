import 'package:POD/src/models/carton_model.dart';
import 'package:POD/src/module/authentication/bloc/authentication_bloc.dart';
import 'package:POD/src/module/authentication/user_mixin.dart';
import 'package:POD/src/module/dashboard/home_screen.dart';
import 'package:POD/src/module/delivery_order/bloc/delivery_bloc.dart';
import 'package:POD/src/module/picking_order/picking_order.dart';
import 'package:POD/src/widgets/custom_circular_button.dart';
import 'package:POD/src/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryOrder extends StatelessWidget {
  const DeliveryOrder({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const DeliveryOrder());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final authenticationStates = context.read<AuthenticationBloc>().state;
    return BlocProvider(
      create: (context) => DeliveryBloc(
          pickingRepo: RepositoryProvider.of(context))
        ..add(
            DeliveryItemsFetchByVehicleId(UserDetail.vehicle?.vehicleID ?? "")),
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Screen',
                style: TextStyle(
                  fontFamily: 'Montserrat Medium',
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Text(
                '${authenticationStates.location?.locDesc}',
                style: TextStyle(
                  fontFamily: 'Montserrat Regular',
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(HomeScreen.route());
            },
          ),
          elevation: 0,
        ),
        body: Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            // CurvingContainer(size: size / 1.2),
            SafeArea(
              child: BlocConsumer<DeliveryBloc, DeliveryState>(
                listener: (context, state) {
                  if (state.status == DeliveryStatus.failure) {
                    _showSnackBar(context, state.errMsg, Colors.red);
                    BlocProvider.of<DeliveryBloc>(context)
                        .add(DeliveryItemResetFailureState());
                  }
                },
                builder: (context, state) {
                  var uniqueBolObjSet = <String>{};
                  var uniqueScannedBolObjSet = <String>{};

                  for (var obj in state.cartonList) {
                    var desc = obj.bolID;
                    if (obj.scanned) {
                      uniqueScannedBolObjSet.add(desc!);
                    }
                    uniqueBolObjSet.add(desc!);
                  }
                  return IgnorePointer(
                    ignoring: state.status == DeliveryStatus.submit,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CustomTextEditingField(),
                          const SizedBox(height: 5),
                          if (state.cartonList.isEmpty)
                            Center(
                              child: state.status ==
                                      DeliveryStatus.searchIdLoading
                                  ? CircularProgressIndicator()
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text("No Active Records Found",
                                            textAlign: TextAlign.center),
                                        ElevatedButton(
                                            onPressed: () => {
                                                  BlocProvider.of<DeliveryBloc>(
                                                          context)
                                                      .add(DeliveryItemsFetchByVehicleId(
                                                          UserDetail.vehicle
                                                                  ?.vehicleID ??
                                                              ""))
                                                },
                                            child: const Text(
                                              "Retry",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ))
                                      ],
                                    ),
                            ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.cartonList.length,
                              itemBuilder: (BuildContext context, int index) {
                                List<CartonModel> sortedList =
                                    List<CartonModel>.from(state.cartonList);
                                sortedList.sort((a, b) {
                                  if (a.scanned && !b.scanned) {
                                    return -1; // a comes before b
                                  } else if (!a.scanned && b.scanned) {
                                    return 1; // b comes before a
                                  } else {
                                    return 0; // no change in order
                                  }
                                });
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: sortedList[index].scanned
                                          ? Colors.green
                                          : Colors.grey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Container(
                                    height: 50,
                                    child: ListTile(
                                      dense: true,
                                      visualDensity: VisualDensity(
                                          horizontal: -4, vertical: -4),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      title: Text(
                                        sortedList[index].cartonID ?? "",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      leading: sortedList[index].scanned
                                          ? Icon(Icons.verified, size: 20)
                                          : Icon(Icons.qr_code_scanner,
                                              size: 20),
                                      iconColor: sortedList[index].scanned
                                          ? Colors.lightGreen
                                          : Colors.grey,
                                      subtitle: Text(
                                        "Bol No: ${sortedList[index].bolID ?? ""}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      trailing: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.delete,
                                            color: Colors.redAccent,
                                            size: 18), // Reduced icon size
                                        onPressed: () {
                                          BlocProvider.of<DeliveryBloc>(context)
                                              .add(
                                            DeliveryItemDelete(
                                                sortedList[index]),
                                          );
                                        },
                                      ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(HomeScreen.route());
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
                                      if (state.receiversId.length == 0) {
                                        _showSnackBar(
                                            context,
                                            "Please Provide Receiver's Id",
                                            Colors.red);
                                        return;
                                      }
                                      if (uniqueScannedBolObjSet.isNotEmpty) {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.8,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(20.0),
                                                  topRight:
                                                      Radius.circular(20.0),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Row(
                                                        children: [
                                                          Icon(Icons
                                                              .summarize_outlined),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'Summary',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Montserrat Medium',
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.close),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context); // Close the modal sheet
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Center(
                                                        child: ListView.builder(
                                                            itemCount:
                                                                uniqueScannedBolObjSet
                                                                    .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              var bolID =
                                                                  uniqueScannedBolObjSet
                                                                      .elementAt(
                                                                          index);
                                                              var groupedItems = state
                                                                  .cartonList
                                                                  .where((item) =>
                                                                      item.bolID ==
                                                                          bolID &&
                                                                      item.scanned)
                                                                  .toList();
                                                              return Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                ),
                                                                margin: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        4.0),
                                                                child:
                                                                    ExpansionTile(
                                                                  initiallyExpanded:
                                                                      true,
                                                                  title: Text(
                                                                      'BOL ID: ${bolID}'),
                                                                  leading: Text('${groupedItems.length}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                                                  children:
                                                                      groupedItems
                                                                          .map(
                                                                              (item) {
                                                                    return ListTile(
                                                                      leading: Icon(
                                                                          Icons
                                                                              .verified,
                                                                          size:
                                                                              30),
                                                                      iconColor:
                                                                          Colors
                                                                              .lightGreen,
                                                                      title: Text(
                                                                          item.cartonID ??
                                                                              ''),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              );
                                                            })),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop("submitted");
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.blue,
                                                      onPrimary: Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                    ),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12,
                                                              horizontal: 24),
                                                      child: Text(
                                                        'Submit',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ).then((value) {
                                          if (value == "submitted") {
                                            List<CartonModel> eligibleCartons =
                                                state.cartonList
                                                    .where((carton) =>
                                                        carton.scanned == true)
                                                    .toList();
                                            BlocProvider.of<DeliveryBloc>(
                                                    context)
                                                .add(DeliveryItemSubmit(
                                                    eligibleCartons,
                                                    UserDetail.loggedInUser!,
                                                    state.receiversId,
                                                    authenticationStates
                                                            .location?.locID ??
                                                        ""));
                                          }
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: uniqueScannedBolObjSet.isEmpty ||
                                              state.receiversId.isEmpty
                                          ? Colors.grey
                                          : Colors.blue,
                                      onPrimary: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 24),
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
                case DeliveryStatus.initial:
                  BlocProvider.of<DeliveryBloc>(context).add(
                      DeliveryItemsFetchByVehicleId(
                          UserDetail.vehicle?.vehicleID ?? ""));
                  return SizedBox.shrink();
                case DeliveryStatus.submit:
                  return const Positioned(
                    child: CustomDialog(
                      message: 'Please Wait!',
                      lottieAssetPath: 'assets/lottie/loading.zip',
                    ),
                  );
                case DeliveryStatus.submitted:
                  {
                    // BlocProvider.of<DeliveryBloc>(context).add(
                    //     DeliveryItemsFetchByVehicleId(UserDetail.vehicle?.vehicleID??""));
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
  final TextEditingController cartonIdScannerFieldController =
      TextEditingController();

  final FocusNode textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    textFieldFocusNode.requestFocus();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    cartonIdScannerFieldController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }

  String getTextFromTextField() {
    var scannedText = textFieldController.text.replaceAll('\n', '');
    return scannedText.trim();
  }

  String getTextFromCartonIDTextField() {
    var scannedText = cartonIdScannerFieldController.text.replaceAll('\n', '');
    return scannedText.trim();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryBloc, DeliveryState>(builder: (context, state) {
      if (state.status == DeliveryStatus.submit) {
        textFieldFocusNode.unfocus();
        textFieldController.clear();
        BlocProvider.of<DeliveryBloc>(context).add(
          DeliveryItemReceiverEnteredId(getTextFromTextField()),
        );
        cartonIdScannerFieldController.clear();
      }
      if (state.status == DeliveryStatus.submitted) {
        textFieldFocusNode.requestFocus();
      }
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CupertinoSearchTextField(
                    focusNode: textFieldFocusNode,
                    placeholder: "Scan Bol/Carton ID",
                    borderRadius: BorderRadius.circular(8),
                    prefixInsets: const EdgeInsets.only(
                        left: 10, right: 5, top: 5, bottom: 5),
                    suffixInsets: const EdgeInsets.all(2),
                    prefixIcon: const Icon(
                      CupertinoIcons.barcode,
                      size: 20,
                    ),
                    onSubmitted: (value) {
                      BlocProvider.of<DeliveryBloc>(context).add(
                        DeliveryItemValidateCartonId(
                            getTextFromCartonIDTextField()),
                      );
                      cartonIdScannerFieldController.clear();
                      textFieldFocusNode.requestFocus();
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
                              getTextFromCartonIDTextField()),
                        );
                        cartonIdScannerFieldController.clear();
                        textFieldFocusNode.requestFocus();
                      }
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: CustomTextField(
                  label: 'Enter Receiver Id',
                  suffixIcon: getTextFromTextField().isNotEmpty
                      ? InkWell(
                          onTap: () {
                            textFieldController.clear();
                            BlocProvider.of<DeliveryBloc>(context).add(
                              DeliveryItemReceiverEnteredId(
                                  getTextFromTextField()),
                            );
                          },
                          child: Icon(
                            Icons.cancel,
                            size: 22,
                            color: Colors.grey[600],
                          ),
                        )
                      : SizedBox.shrink(),
                  onValueChange: (e) {
                    BlocProvider.of<DeliveryBloc>(context).add(
                      DeliveryItemReceiverEnteredId(getTextFromTextField()),
                    );
                  },
                  controller: textFieldController,
                )),
              ],
            ),
          ],
        ),
      );
    });
  }
}

void _showSnackBar(BuildContext context, String message, Color color) {
  final snackBar = SnackBar(content: Text(message), backgroundColor: color);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
