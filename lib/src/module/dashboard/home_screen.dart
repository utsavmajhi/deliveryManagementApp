import 'package:POD/src/module/dashboard/dash_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../config/theme_settings.dart';
import 'profile_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const HomeScreen());
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> _tabs =  [
    DashboardScreen(),
    ProfileView()
  ];

  void changeIndex(int value) {
    setState(() {
      selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.black12,
          Colors.white,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: _tabs[selectedIndex],
            ),
            Positioned(
              bottom: 0,
              child: MyBottomAppBar(
                letIndexChange: changeIndex,
                selectedIndex: selectedIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyBottomAppBar extends StatelessWidget {
  final int selectedIndex;
  final Function letIndexChange;
  const MyBottomAppBar({Key? key, required this.selectedIndex, required this.letIndexChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: IconButton(
              icon: Icon(
                Icons.stacked_bar_chart_rounded,
                color: selectedIndex == 0
                    ? AppColor.primary
                    : AppColor.iconColor,
              ),
              onPressed: () {
                letIndexChange(0);
              },
            ),
          ),
          VerticalDivider(),
          Expanded(
            child: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.user,
                color: selectedIndex == 1
                    ? AppColor.primary
                    : AppColor.iconColor,
                size: 18,
              ),
              onPressed: () {
                letIndexChange(1);
              },
            ),
          ),
                 ],
      ),
    );
  }
}
