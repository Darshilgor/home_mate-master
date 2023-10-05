import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/category_model.dart';

class FeaturedCategories extends StatefulWidget {
  const FeaturedCategories({Key? key}) : super(key: key);

  @override
  State<FeaturedCategories> createState() => _FeaturedCategoriesState();
}

class _FeaturedCategoriesState extends State<FeaturedCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Featured Categories",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("categories").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              List<CategoryModel> categoryList = snapshot.data!.docs
                  .map((e) => CategoryModel.fromMap(e.data()))
                  .toList();
              if (categoryList.isNotEmpty) {
                List<CategoryModel> featuredCategories = categoryList
                    .where((element) => element.isFeatured == true)
                    .toList();
                categoryList
                    .removeWhere((element) => element.isFeatured == true);
                return ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                      color: clBG,
                      child: Text(
                        "FEATURED CATEGORIES",
                        style: TextStyle(
                          fontSize: 16,
                          color: clPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: (featuredCategories.isNotEmpty)
                          ? Column(
                              children: [
                                for (CategoryModel e in featuredCategories)
                                  ListTile(
                                    title: Text(e.name),
                                    trailing: InkWell(
                                        onTap: () async {
                                          processDialog(context);
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection("categories")
                                                .doc(e.id)
                                                .update({
                                              "isFeatured": false,
                                            });
                                            Navigator.pop(context);
                                          } on FirebaseException catch (e) {
                                            snackMessage(context, e.message!);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Icon(Icons.remove)),
                                  ),
                              ],
                            )
                          : const Center(
                              child: Text("No Featured Categories Found")),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                      color: clBG,
                      child: Text(
                        "ADD FEATURED CATEGORIES",
                        style: TextStyle(
                          fontSize: 16,
                          color: clPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: (categoryList.isNotEmpty)
                          ? Column(
                              children: [
                                for (CategoryModel e in categoryList)
                                  ListTile(
                                    title: Text(e.name),
                                    trailing: InkWell(
                                        onTap: () async {
                                          processDialog(context);
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection("categories")
                                                .doc(e.id)
                                                .update({
                                              "isFeatured": true,
                                            });
                                            Navigator.pop(context);
                                          } on FirebaseException catch (e) {
                                            snackMessage(context, e.message!);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Icon(Icons.add)),
                                  ),
                              ],
                            )
                          : const Center(
                              child: Text("All Category is Featured")),
                    ),
                  ],
                );
              }
              return const Center(
                child: Text("No Categories Found"),
              );
            }
            return const Center(
              child: Text("Something went wrong"),
            );
          }),
    );
  }
}
