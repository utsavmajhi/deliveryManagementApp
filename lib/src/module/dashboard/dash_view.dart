import 'package:delivery_management_app/src/module/authentication/bloc/authentication_bloc.dart';
import 'package:delivery_management_app/src/module/authentication/user_mixin.dart';
import 'package:delivery_management_app/src/module/delivery_order/delivery_order.dart';
import 'package:delivery_management_app/src/module/picking_order/picking_order.dart';
import 'package:delivery_management_app/src/module/tracking_order/tracking_order.dart';
import 'package:delivery_management_app/src/widgets/curving_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/custom_dropdown.dart';

class DashboardScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => DashboardScreen());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var screenWidth = size.width;
    var screenHeight = size.height;

    var crossAxisCount = 2; // Default number of columns
    if (screenWidth >= 600) {
      crossAxisCount = 4; // Use 4 columns for larger screens
    } else if (screenWidth >= 400) {
      crossAxisCount = 3; // Use 3 columns for medium-sized screens
    }


    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
  builder: (context, state) {
    return Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          CurvingContainer(size: size),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 64,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 32,
                            backgroundImage: AssetImage(
                              'assets/images/delivery_prick.png',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${state.warehouse?.name}',
                              style: const TextStyle(
                                fontFamily: 'Montserrat Medium',
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "User: ${UserDetail.loggedInUser}",
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
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: GridView.count(
                      childAspectRatio: (1 / 1),
                      mainAxisSpacing: screenHeight * 0.035, // Adjust vertical spacing
                      crossAxisSpacing: screenWidth * 0.035, // Adjust horizontal spacing
                      primary: false,
                      crossAxisCount: crossAxisCount, // Use calculated number of columns
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(DeliveryOrder.route());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/picking.png',
                                    height: 110,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Delivery',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat Regular',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(63, 63, 63, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // GOTO PICKING SCREEN
                            Navigator.of(context).push(PickingOrder.route());
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/packing.png',
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  'Picking',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat Regular',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(63, 63, 63, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            //goto Tracking Screen
                            Navigator.of(context).push(TrackingOrder.route());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/tracking.png',
                                    height: 100,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'Tracking',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat Regular',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromRGBO(63, 63, 63, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  },
),
    );
  }
}
