import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/screens/admin/admin_home.dart';
import 'package:home_mate/screens/provider/booking_requests.dart';
import 'package:home_mate/screens/provider/provider_home.dart';
import 'package:home_mate/screens/user/booking_status.dart';
import 'package:home_mate/screens/user/category.dart';
import 'package:home_mate/screens/chat.dart';
import 'package:home_mate/screens/user/home.dart';
import 'package:home_mate/screens/user/profile.dart';

class NavBar extends StatefulWidget {
  final int index;
  const NavBar({super.key, required this.index});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<Widget> adminScreens = [
    const AdminHome(),
    const BookingHistoryPage(),
    const Categories(),
    const Chat(),
    const Profile(),
  ];
  List<Widget> providerScreens = [
    const ProviderHome(),
    const ProviderOrders(),
    const Categories(),
    const Chat(),
    const Profile(),
  ];
  List<Widget> userScreens = [
    const Home(),
    const BookingHistoryPage(),
    const Categories(),
    const Chat(),
    const Profile(),
  ];
  late List<Widget> screens;
  late Widget currentScreen;
  late int index;

  late FirebaseAuth auth;
  User? user;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    screens = (type == "admin")?adminScreens:(type=="provider")?providerScreens:userScreens;
    currentScreen = screens[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          currentScreen,
      resizeToAvoidBottomInset: false,
      bottomSheet:
          SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      index = 0;
                      currentScreen = screens[index];
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        (index == 0)
                            ? "assets/icons/Home1.svg"
                            : "assets/icons/Home.svg",
                        height: 23,
                        width: 23,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      index = 1;
                      currentScreen = screens[index];
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        (index == 1)
                            ? "assets/icons/Ticket1.svg"
                            : "assets/icons/Ticket.svg",
                        height: 23,
                        width: 23,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      index = 2;
                      currentScreen = screens[index];
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        (index == 2)
                            ? "assets/icons/Category1.svg"
                            : "assets/icons/Category.svg",
                        height: 23,
                        width: 23,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      index = 3;
                      currentScreen = screens[index];
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        (index == 3)
                            ? "assets/icons/Chat1.svg"
                            : "assets/icons/Chat.svg",
                        height: 23,
                        width: 23,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      index = 4;
                      currentScreen = screens[index];
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        (index == 4)
                            ? "assets/icons/Profile1.svg"
                            : "assets/icons/Profile.svg",
                        height: 23,
                        width: 23,
                      ),
                    ),
                  ),
                ],
              ),
            )

    );
  }
}
