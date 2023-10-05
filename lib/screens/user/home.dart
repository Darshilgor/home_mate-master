import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/category_model.dart';
import 'package:home_mate/model/service_model.dart';
import 'package:home_mate/screens/search.dart';
import 'package:home_mate/screens/servicedetail.dart';
import 'package:home_mate/widgets/bottom_nav.dart';
import 'package:home_mate/widgets/category_card.dart';
import 'package:home_mate/widgets/services_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchText = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width * 1;
    double screenheight = MediaQuery.of(context).size.height * 1;

    return Scaffold(
      backgroundColor: clBG,
      body: SafeArea(
        child: ListView(
          children: [
            topSearchSlider(screenwidth, screenheight),
            homeCategories(),
            homeServices(),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }

  Container homeServices() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: const EdgeInsets.only(top: 20),
      color: clContainer,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Featured Services",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchService(),
                    ),
                  );
                },
                child: Text(
                  "View All",
                  style: TextStyle(
                    fontSize: 14,
                    color: clBody,
                  ),
                ),
              ),
            ],
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("services")
                  .where("isFeatured", isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData && snapshot.data != null) {
                  List<ServiceModel> featuredServices = snapshot.data!.docs
                      .map((e) => ServiceModel.fromMap(e.data()))
                      .toList();

                  if (featuredServices.isNotEmpty) {
                    return SizedBox(
                      height: 320,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: featuredServices.length,
                          itemBuilder: (context, index) {
                            return ServiceCard(
                              service: featuredServices[index],
                              width: 250,
                            );
                          }),
                    );
                  }
                  return const Center(
                    child: Text("No Featured Services Found"),
                  );
                }
                return const Center(
                  child: Text("Something went wrong"),
                );
              }),
        ],
      ),
    );
  }

  Container homeCategories() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      margin: const EdgeInsets.only(top: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Featured Category",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const NavBar(
                          index: 2,
                        ),
                        transitionDuration: const Duration(seconds: 0),
                        transitionsBuilder: (_, a, __, c) =>
                            FadeTransition(opacity: a, child: c),
                      ),
                      (route) => false);
                },
                child: Text(
                  "View All",
                  style: TextStyle(
                    fontSize: 14,
                    color: clBody,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("categories")
                  .where("isFeatured", isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  List<CategoryModel> featuredCategories = snapshot.data!.docs
                      .map((e) => CategoryModel.fromMap(e.data()))
                      .toList();

                  if (featuredCategories.isNotEmpty) {
                    return Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 10,
                      runSpacing: 15,
                      children: [
                        for (int i = 0; i < featuredCategories.length; i++)
                          SizedBox(
                              height: 120,
                              child: CategoryCard(
                                category: featuredCategories[i],
                              )),
                      ],
                    );
                  }
                  return const Center(
                    child: Text("No Featured Categories Found"),
                  );
                }
                return const Center(
                  child: Text("Something went wrong"),
                );
              }),
        ],
      ),
    );
  }

  Stack topSearchSlider(double screenwidth, double screenheight) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: screenheight * 0.27,
          width: screenwidth,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("services")
                  .where("isSlider", isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  List<ServiceModel> sliderServices = snapshot.data!.docs
                      .map((e) => ServiceModel.fromMap(e.data()))
                      .toList();
                  if (sliderServices.isNotEmpty) {
                    return PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: sliderServices.length,
                      itemBuilder: ((context, index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ServiceDetail(
                                          info: sliderServices[index])));
                            },
                            child: Image.network(
                              sliderServices[index].coverUrl,
                              fit: BoxFit.cover,
                            ),
                          )),
                    );
                  }
                  return const Center(
                    child: Text("No Slider Services Found"),
                  );
                }
                return const Center(
                  child: Text("Something went wrong"),
                );
              }),
        ),
        Positioned(
          right: 20,
          top: 20,
          child: CircleAvatar(
            backgroundColor: clBG,
            child: const Icon(Icons.notifications_none),
          ),
        ),
        Positioned(
          top: screenheight * 0.27 - 30,
          left: (screenwidth - (screenwidth * 0.9)) / 2,
          child: SizedBox(
            width: screenwidth * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: screenwidth * 0.7,
                  height: 60,
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: TextField(
                    // enabled: false,
                    controller: searchText,
                    decoration: const InputDecoration(
                      hintText: "Search Services",
                      border: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchService(
                          query: searchText.text.trim(),
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.white,
                      child: const Icon(
                        Icons.search_outlined,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
