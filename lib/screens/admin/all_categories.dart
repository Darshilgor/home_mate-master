import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/category_model.dart';
import 'package:home_mate/model/service_model.dart';
import 'package:home_mate/screens/admin/update_category.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({Key? key}) : super(key: key);

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Categories",
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
                return Container(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) => ListTile(
                            onTap: () {},
                            title: Text(categoryList[index].name),
                            trailing: SizedBox(
                              width: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateCategory(
                                                      info: categoryList[index],
                                                    )));
                                      },
                                      child: Icon(Icons.edit)),
                                  InkWell(
                                      onTap: () async {
                                        try {
                                          QuerySnapshot snapshot =
                                              await FirebaseFirestore.instance
                                                  .collection("services")
                                                  .where("category",
                                                      isEqualTo:
                                                          categoryList[index]
                                                              .name)
                                                  .get();
                                          List<ServiceModel> allServices =
                                              snapshot.docs
                                                  .map((e) =>
                                                      ServiceModel.fromMap(
                                                          e.data() as Map<
                                                              String, dynamic>))
                                                  .toList();
                                          for (ServiceModel e in allServices) {
                                            await FirebaseFirestore.instance
                                                .collection("services")
                                                .doc(e.id)
                                                .delete();
                                          }
                                          await FirebaseFirestore.instance
                                              .collection("categories")
                                              .doc(categoryList[index].id)
                                              .delete();
                                        } on FirebaseException catch (e) {
                                          snackMessage(context, e.message!);
                                        }
                                      },
                                      child: Icon(Icons.delete)),
                                ],
                              ),
                            ),
                          )),
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
