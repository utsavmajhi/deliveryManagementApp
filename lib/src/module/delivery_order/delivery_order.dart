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

    return BlocProvider(
      create: (context) => DeliveryBloc(pickingRepo: RepositoryProvider.of(context)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
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
                  for (var obj in state.cartonList) {
                    var desc = obj.bolID;
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
                                    Text(
                                      'Delivery Screen',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat Medium',
                                        color: Colors.white,
                                        fontSize: 25,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.warehouse,size: 20,color: Colors.white,),
                                        SizedBox(width: 5,),
                                        Text(
                                          "Warehouse: ${authenticationStates.warehouse?.name}",
                                          style: TextStyle(
                                            fontFamily: 'Montserrat Medium',
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
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
                          SearchBar(),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.cartonList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ListTile(
                                    title: Text(state.cartonList[index].cartonID??""),
                                    leading: Icon(Icons.verified,size: 30),
                                    iconColor:Colors.lightGreen,
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
                                      if(state.cartonList.isNotEmpty){
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
                                                            itemCount: uniqueBolObjSet.length,
                                                            itemBuilder: (BuildContext context,int index){
                                                              var bolID =
                                                              uniqueBolObjSet.elementAt(index);
                                                              var groupedItems = state.cartonList
                                                                  .where(
                                                                      (item) => item.bolID == bolID)
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
                                            BlocProvider.of<DeliveryBloc>(context).add(
                                                DeliveryItemSubmit(state.cartonList,UserDetail.loggedInUser!,authenticationStates.warehouse!));
                                          }
                                        });
                                      }

                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: state.cartonList.isEmpty? Colors.grey:Colors.blue,
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
                case DeliveryStatus.submitted:
                  return const Positioned(
                    child: CustomDialog(
                      message: 'Done!',
                      lottieAssetPath: 'assets/lottie/test.json',
                    ),
                  );
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

class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController textFieldController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    final authenticationStates = context.read<AuthenticationBloc>().state;
    return BlocBuilder<DeliveryBloc, DeliveryState>(builder: (context, state) {
      if (state.status == DeliveryStatus.submit) {
        textFieldFocusNode.unfocus(); // Shrink the keyboard when status is submit
      }
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: CupertinoSearchTextField(
                  focusNode: textFieldFocusNode,
                  placeholder: "Enter Bol/Carton ID",
                  borderRadius: BorderRadius.circular(10),
                  prefixInsets: const EdgeInsets.only(
                    left: 15,
                    right: 10,
                    top: 10,
                    bottom: 10,
                  ),
                  suffixInsets: const EdgeInsets.all(10),
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                    size: 22,
                  ),
                  onSubmitted: (value) {
                    BlocProvider.of<DeliveryBloc>(context).add(
                      DeliveryItemAdd(
                        getTextFromTextField(),
                        authenticationStates.warehouse!.id,
                      ),
                    );
                    textFieldController.clear();
                  },
                  controller: textFieldController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularButton(
                  state: state.status == DeliveryStatus.searchIdLoading
                      ? CircularButtonState.loading
                      : CircularButtonState.idle,
                  idleIcon: Icons.arrow_forward_ios,
                  onPressed: () {
                    if (state.status != DeliveryStatus.searchIdLoading) {
                      BlocProvider.of<DeliveryBloc>(context).add(
                        DeliveryItemAdd(
                          getTextFromTextField(),
                          authenticationStates.warehouse!.id,
                        ),
                      );
                      textFieldController.clear();
                    }
                  },
                ),
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
