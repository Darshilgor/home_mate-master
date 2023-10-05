import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/category_model.dart';
import 'package:home_mate/model/service_model.dart';
import 'package:home_mate/widgets/services_card.dart';

class SearchService extends StatefulWidget {
  SearchService({Key? key, this.query,this.category}) : super(key: key);
  String? query;
  String? category;

  @override
  State<SearchService> createState() => _SearchServiceState();
}

class _SearchServiceState extends State<SearchService> {
  TextEditingController search = TextEditingController();
  int filter = 1;
  late String query;
  String category ="";
  List<ServiceModel> result = [];

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = auth.currentUser;
    search.text = widget.query ?? "";
    query = search.text;
    category = widget.category ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clContainer,
      appBar: AppBar(
        backgroundColor: clPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Available Services",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 60,
                padding: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: clBG,
                ),
                child: TextField(
                  controller: search,
                  onChanged: (value) {
                    setState(() {
                      query = value.trim();
                    });
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "Search Services",
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              PopupMenuButton(
                offset: const Offset(0, 70),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      setState(() {
                        filter = 1;
                      });
                    },
                    value: 1,
                    child: const Text(
                      "Service Name",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      setState(() {
                        filter = 2;
                      });
                    },
                    value: 2,
                    child: const Text(
                      "Service Provider",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 60,
                    width: 60,
                    color: clPrimary,
                    child: const Icon(
                      Icons.filter_alt,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                // child:
              ),
            ],
          ),
          //Selected Categories
          SizedBox(
            height: 40,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("categories")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  if (snapshot.hasData) {
                    List<CategoryModel> searchCategory = snapshot.data!.docs
                        .map((e) => CategoryModel.fromMap(e.data()))
                        .toList();
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: searchCategory.length + 1,
                        itemBuilder: (context, index) {
                          int i = index - 1;
                          bool isSelected = false;
                          List<String> selectedCategories = List.generate(
                              result.length, (i) => result[i].category)
                              .toList();
                          selectedCategories.toSet().toList();
                          if (i == -1) {
                            return InkWell(
                              onTap: () {
                                category = "";
                                setState(() {});
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                margin:
                                const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: clBG),
                                child: Text(
                                  "All",
                                  style: TextStyle(
                                    color: clPrimary,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            (selectedCategories
                                .contains(searchCategory[i].name))
                                ? isSelected = true
                                : isSelected = false;
                            return InkWell(
                              onTap: () {
                                isSelected = true;
                                category = searchCategory[i].name;
                                setState(() {});
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                margin:
                                const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: (isSelected) ? clPrimary : clBG),
                                child: Text(
                                  searchCategory[i].name,
                                  style: TextStyle(
                                      color: (isSelected) ? clBG : clPrimary),
                                ),
                              ),
                            );
                          }
                        });
                  }
                  return const SizedBox();
                }),
          ),
          const SizedBox(
            height: 10,
          ),


          StreamBuilder(
            stream: (category.isNotEmpty)?FirebaseFirestore.instance
                .collection("services").where("category",isEqualTo: category)
                .where("name", isNotEqualTo: query)
                .orderBy("name")
                .startAt([
              query.trim(),
            ]).endAt([
              query.trim() + '\uf8ff',
            ]).snapshots():FirebaseFirestore.instance
                .collection("services")
                .where("name", isNotEqualTo: query)
                .orderBy("name")
                .startAt([
              query.trim(),
            ]).endAt([
              query.trim() + '\uf8ff',
            ]).snapshots()
                ,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                result = snapshot.data!.docs
                    .map((e) => ServiceModel.fromMap(e.data()))
                    .toList();
                print(result);
                if (result.isNotEmpty) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),

                      //Search Results
                      (result.isNotEmpty)
                          ? Column(
                              children: [
                                for (ServiceModel i in result)
                                  Container(
                                    height: 320,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: ServiceCard(
                                      service: i,
                                      width: 330,
                                    ),
                                  ),
                              ],
                            )
                          : const Center(
                              child: Text("No Services Found"),
                            )
                    ],
                  );
                }
                return const Center(
                  child: Text("No Services Found"),
                );
              }
              return const Center(
                child: Text("Something went wrong"),
              );
            },
          ),
        ],
      ),
    );
  }
}
