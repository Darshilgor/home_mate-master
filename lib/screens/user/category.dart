import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/category_model.dart';
import 'package:home_mate/widgets/category_card.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: clBG,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Category",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: clPrimary,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("categories").snapshots(),
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasData){
            List<CategoryModel> userCategories = snapshot.data!.docs.map((e) => CategoryModel.fromMap(e.data())).toList();
            if(userCategories.isNotEmpty){
              return GridView.builder(
                  semanticChildCount: userCategories.length,
                  itemCount: userCategories.length,
                  padding: EdgeInsets.only(top: 30, bottom: 70,left: screenWidth * 0.1,right: screenWidth * 0.1),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 100/100,
                      crossAxisSpacing: screenWidth * 0.1,
                      mainAxisSpacing: screenWidth * 0.1
                  ),
                  itemBuilder: (context, index) {
                    return CategoryCard(category: userCategories[index]);
                  });
            }
            return const Center(child: Text("No Categories Found"),);

          }
          return const Center(child: Text("Something went wrong"),);
        }
      ),
    );
  }
}
