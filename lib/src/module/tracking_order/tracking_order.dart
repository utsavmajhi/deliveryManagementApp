import 'package:POD/src/models/carton_history.dart';
import 'package:POD/src/module/authentication/bloc/authentication_bloc.dart';
import 'package:POD/src/module/authentication/user_mixin.dart';
import 'package:POD/src/module/dashboard/home_screen.dart';
import 'package:POD/src/module/picking_order/bloc/picking_bloc.dart';
import 'package:POD/src/widgets/curving_container.dart';
import 'package:POD/src/widgets/custom_circular_button.dart';
import 'package:POD/src/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'bloc/tracking_bloc.dart';

class TrackingOrder extends StatelessWidget {
  const TrackingOrder({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const TrackingOrder());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final authenticationStates = context.read<AuthenticationBloc>().state;

    return BlocProvider(
      create: (context) =>
          TrackingBloc(pickingRepo: RepositoryProvider.of(context)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
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
              child: BlocConsumer<TrackingBloc, TrackingState>(
                listener: (context, state) {
                  if (state.status == TrackingStatus.failure) {
                    _showSnackBar(context, state.errMsg, Colors.red);
                    BlocProvider.of<TrackingBloc>(context)
                        .add(TrackingItemResetFailureState());
                  }
                },
                builder: (context, state) {
                  var uniqueBolObjSet = <String>{};
                  for (var obj in state.cartonHistoryList) {
                    var desc = obj.cartonID;
                    uniqueBolObjSet.add(desc!);
                  }
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 64,
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Tracking Screen',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat Medium',
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.warehouse,
                                        size: 25,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Vehicle: ${UserDetail.vehicle?.vehicleID}",
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
                        BlocBuilder<TrackingBloc, TrackingState>(
                          builder: (context, state) {
                            var cartonHistoryList = state.cartonHistoryList;
                            List<TimelineTile> timelines = [];
                            for (var entry
                                in cartonHistoryList.asMap().entries) {
                              var index = entry.key;
                              var item = entry.value;

                              timelines.add(
                                TimelineTile(
                                  alignment: TimelineAlign.start,
                                  lineXY: 0.01,
                                  isFirst: index == 0,
                                  isLast: index == cartonHistoryList.length - 1,
                                  indicatorStyle: const IndicatorStyle(
                                    width: 15,
                                    color: Color(0xFF27AA69),
                                    padding: EdgeInsets.all(6),
                                  ),
                                  endChild: _RightChild(
                                    asset: item.eventType == "Pick" ? 'assets/images/picking.png':'assets/images/packing.png',
                                    title: () {
                                      switch (item.eventType) {
                                        case 'Pick':
                                          return "Carton Picked at ${item.location}";
                                        case 'Receive':
                                          return "Carton Received at ${item.location}";
                                        default:
                                          return "No Action";
                                      }
                                    }(),
                                    message: '${parseDateString(item.dateTimeStamp!)}',
                                    userName: "${item.user}",
                                  ),
                                  beforeLineStyle: const LineStyle(
                                    color: Color(0xFF27AA69),
                                  ),
                                ),
                              );
                            }

                            return Expanded(
                              child: timelines.length ==0 ?
                              Center(
                                child:Text("No History Found")
                            )
                              :ListView(
                                shrinkWrap: true,
                                children: <Widget>[...timelines],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RightChild extends StatelessWidget {
  const _RightChild({
    Key? key,
    required this.asset,
    required this.title,
    required this.message,
    required this.userName,
    this.disabled = false,
  }) : super(key: key);

  final String asset;
  final String title;
  final String message;
  final bool disabled;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Opacity(
            child: Image.asset(asset, height: 50),
            opacity: disabled ? 0.5 : 1,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
              ),
              const SizedBox(height: 6),
              Text(
                message,
              ),
              Text(
                'User: ${userName}',
              ),
            ],
          ),
        ],
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
    return BlocBuilder<TrackingBloc, TrackingState>(builder: (context, state) {
      if (state.status == TrackingStatus.submit) {
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
                  placeholder: "Enter Carton Id",
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
                    BlocProvider.of<TrackingBloc>(context)
                        .add(TrackingItemSearch(
                        getTextFromTextField()));
                    textFieldController.clear();
                  },
                  controller: textFieldController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularButton(
                  state: state.status == TrackingStatus.loading
                      ? CircularButtonState.loading
                      : CircularButtonState.idle,
                  idleIcon: Icons.arrow_forward_ios,
                  onPressed: () {
                    if (state.status != TrackingStatus.loading) {
                      BlocProvider.of<TrackingBloc>(context)
                          .add(TrackingItemSearch(
                          getTextFromTextField()));
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
void _showSnackBar(BuildContext context, String message, Color color) {
  final snackBar = SnackBar(content: Text(message), backgroundColor: color);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

DateTime parseDateString(String dateString) {
  // Extract year, month, day, hour, minute, and second from the input string
  final year = int.parse(dateString.substring(0, 4));
  final month = int.parse(dateString.substring(4, 6));
  final day = int.parse(dateString.substring(6, 8));
  final hour = int.parse(dateString.substring(8, 10));
  final minute = int.parse(dateString.substring(10, 12));
  final second = int.parse(dateString.substring(12, 14));

  // Create a DateTime object using the extracted values
  final dateTime = DateTime(year, month, day, hour, minute, second);

  return dateTime;
}