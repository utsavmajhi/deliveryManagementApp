import 'package:POD/src/module/authentication/user_mixin.dart';
import 'package:POD/src/widgets/curving_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/custom_button.dart';
import '../authentication/bloc/authentication_bloc.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        CurvingContainer(size: size),
        SafeArea(child:
        Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const ProfileCard(),
            const SizedBox(
                height: 100
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthenticationBloc>().add(LogOutUserEvent());
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Set the background color
                onPrimary: Colors.white, // Set the text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Set the button border radius
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ))

      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              width: 140,
              height: 140,
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
                  'assets/images/dummypro.png',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${UserDetail.loggedInUser}",
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500,color: Colors.white),
            ),
          ],
        );
      },
    );
  }
}
