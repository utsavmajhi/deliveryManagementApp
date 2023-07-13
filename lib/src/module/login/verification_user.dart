import 'package:delivery_management_app/src/module/authentication/bloc/authentication_bloc.dart';
import 'package:delivery_management_app/src/module/dashboard/home_screen.dart';
import 'package:delivery_management_app/src/module/picking_order/bloc/picking_bloc.dart';
import 'package:delivery_management_app/src/widgets/curving_container.dart';
import 'package:delivery_management_app/src/widgets/custom_circular_button.dart';
import 'package:delivery_management_app/src/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class PickingOrder extends StatelessWidget {
  const PickingOrder({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const PickingOrder());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
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
         Text("test")
        ],
      ),
    );
  }
}

void _showSnackBar(BuildContext context, String message, Color color) {
  final snackBar = SnackBar(content: Text(message), backgroundColor: color);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
