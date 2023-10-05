import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/screens/settings/about_us.dart';
import 'package:home_mate/screens/settings/bookmarks.dart';
import 'package:home_mate/screens/settings/change_contact.dart';
import 'package:home_mate/screens/settings/editprofile.dart';
import 'package:home_mate/screens/login.dart';
import 'package:home_mate/screens/settings/help_and_support.dart';
import 'package:home_mate/screens/settings/payment_method.dart';
import 'package:home_mate/screens/settings/privacy_policy.dart';
import 'package:home_mate/screens/settings/terms_and_conditions.dart';
import 'package:home_mate/screens/settings/verify_email.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User user;
  late FirebaseAuth auth;
  bool emailVerified = false;

  String? profileUrl;
  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    user = auth.currentUser!;
    profileUrl = user.photoURL;
    emailVerified = user.emailVerified;
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width * 1;
    double screenheight = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clPrimary,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: CircleAvatar(
                  radius: screenheight * 0.075,
                  backgroundColor: clBG,
                  backgroundImage:
                      (profileUrl != null) ? NetworkImage(profileUrl!) : null,
                  child: (profileUrl == null)
                      ? const Icon(
                          Icons.person,
                          size: 40,
                        )
                      : null,
                ),
              ),
              Positioned(
                top: screenheight * 0.1,
                left: screenwidth * 0.52,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfile(),
                      ),
                    );
                  },
                  child: const Image(
                    width: 50,
                    height: 50,
                    image: AssetImage(
                      'assets/images/Edit.png',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Text(
                user.displayName!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              (emailVerified)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.email!,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(Icons.verified),
                      ],
                    )
                  : Text(
                      user.email!,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                width: screenwidth,
                color: clBG,
                child: Text(
                  "GENERAL",
                  style: TextStyle(
                    fontSize: 16,
                    color: clPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChangeContact()));
                      },
                      leading: const Icon(
                        Icons.phone,
                        size: 20,
                      ),
                      title: const Text(
                        "Change Contact",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VerifyEmail()));
                      },
                      leading: const Icon(
                        Icons.verified_user,
                        size: 20,
                      ),
                      title: const Text(
                        "Verify Email",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PaymentMethod()));
                      },
                      leading: const Icon(
                        Icons.payment,
                        size: 20,
                      ),
                      title: const Text(
                        "Payment Method",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Bookmarks()));
                      },
                      leading: const Icon(
                        Icons.favorite_outline,
                        size: 20,
                      ),
                      title: const Text(
                        "Favourite Services",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                width: screenwidth,
                color: clBG,
                child: Text(
                  "ABOUT APP",
                  style: TextStyle(
                    fontSize: 16,
                    color: clPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PrivacyPolicy()));
                      },
                      leading: SvgPicture.asset(
                        'assets/icons/privacy.svg',
                        height: 23,
                        width: 23,
                      ),
                      title: const Text(
                        "Privacy Policy",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TermCondition()));
                      },
                      leading: SvgPicture.asset(
                        'assets/icons/term.svg',
                        height: 23,
                        width: 23,
                      ),
                      title: const Text(
                        "Terms & Conditions",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HelpSupport()));
                      },
                      leading: SvgPicture.asset(
                        'assets/icons/help.svg',
                        height: 23,
                        width: 23,
                      ),
                      title: const Text(
                        "Help Support",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AboutUs()));
                      },
                      leading: SvgPicture.asset(
                        'assets/icons/about.svg',
                        height: 23,
                        width: 23,
                      ),
                      title: const Text(
                        "About Us",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.12,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: clPrimary),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut().then((value) =>
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LogIn()),
                              (route) => false));
                    },
                    child: const Text(
                      "Log Out",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 70,
          ),
        ],
      ),
    );
  }
}
