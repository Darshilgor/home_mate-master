import 'package:flutter/material.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/screens/login.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late PageController pageController;

  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                scrollDirection: Axis.horizontal,
                itemCount: welcomePages.length,
                itemBuilder: (context, index) => Stack(
                  // clipBehavior: Clip.none,
                  children: [
                    const Positioned(
                      left: 58,
                      bottom: 204,
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFF0F0FA),
                        radius: 341,
                      ),
                    ),
                    Positioned(
                      top: 101,
                      left: 20,
                      right: 20,
                      child: Image.asset(
                        welcomePages[index].imgUrl,
                        width: 335,
                        height: 340,
                      ),
                    ),
                    Positioned(
                      top: 481,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              welcomePages[index].heading,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              welcomePages[index].subHeading,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ...List.generate(
                        welcomePages.length,
                            (value) => Container(
                          margin: const EdgeInsets.all(4),
                          width: (value == currentIndex) ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: clPrimary,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      if (currentIndex == welcomePages.length - 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // builder: (context) => const NavBar(index: 0),
                            builder: (context) => const LogIn(),
                          ),
                        );
                      } else {
                        pageController.nextPage(
                            duration: const Duration(microseconds: 700),
                            curve: Curves.linear);
                      }
                    },
                    child: Text(
                        (currentIndex == welcomePages.length - 1)
                            ? "Get Started"
                            : "Next",
                        style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomePage {
  final String imgUrl;
  final String heading;
  final String subHeading;

  WelcomePage(
      {required this.imgUrl, required this.heading, required this.subHeading});
}

List<WelcomePage> welcomePages = [
  WelcomePage(
    imgUrl: "assets/images/welcome_screen1.png",
    heading: "Welcome To HomeMate",
    subHeading:
        "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint.",
  ),
  WelcomePage(
    imgUrl: "assets/images/welcome_screen2.png",
    heading: "Book The Appointment",
    subHeading: "Book your services on your own time ",
  ),
  WelcomePage(
    imgUrl: "assets/images/welcome_screen3.png",
    heading: "Payment Gateway",
    subHeading: "Choose the preferable options of payment and get best service",
  ),
  WelcomePage(
    imgUrl: "assets/images/welcome_screen4.png",
    heading: "Find Your Service",
    subHeading: "Find your service as per your preferences",
  ),
];
