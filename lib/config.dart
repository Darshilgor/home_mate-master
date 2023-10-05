import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/category_model.dart';
import 'package:home_mate/model/service_model.dart';
import 'package:home_mate/model/user_model.dart';

//User Details
String type = "";
late UserModel normalUser;
late AdminModel adminUser;
late ProviderModel providerUser;
late List<CategoryModel> providerCategories;
late List<ServiceModel> bookmarks;
String paymentMethod = "";

//Get User Details

Future<void> getUserDetails(User? user) async {
  DocumentSnapshot snap =
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
  if (snap.exists) {
    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;
    type = data["type"];
    await getBookmarks(user);
    if (type == "admin") {
      adminUser = AdminModel.fromMap(data);
    } else if (type == "provider") {
      providerUser = ProviderModel.fromMap(data);
      paymentMethod = providerUser.paymentMethod ?? "";
      await getCategories();
    } else {
      normalUser = UserModel.fromMap(data);
      paymentMethod = normalUser.paymentMethod ?? "";
      print(paymentMethod);
    }
  }
}

//Categories for providers



Future<void> getCategories() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("categories").get();
  providerCategories= snapshot.docs.map((e) => CategoryModel.fromMap(e.data() as Map<String,dynamic>)).toList();
}

// Liked Services by user

Future<void> getBookmarks(User? user) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("bookmarks").get();
  bookmarks = snapshot.docs.map((e) => ServiceModel.fromMap(e.data() as Map<String,dynamic>)).toList();
}

Future<void> updateBookmarks(ServiceModel service,User? user)async{


  if(bookmarks.where((element) => element.id == service.id).isEmpty){
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("bookmarks").doc(service.id).set(service.toMap());
    bookmarks.add(service);
  }else{
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("bookmarks").doc(service.id).delete();
    bookmarks.removeWhere((element) => element.id == service.id);
  }


}

//Most Used Shortcuts
Row printRating(double rating) {
  return Row(
    children: [
      ...List.generate(
        5,
        (index) {
          if (rating == 0) {
            return Icon(
              Icons.star,
              color: clBody,
              size: 20,
            );
          } else if (rating - index >= 1) {
            return const Icon(
              Icons.star,
              color: Colors.orange,
              size: 20,
            );
          } else if (rating - index >= 0 && rating - index < 1) {
            return ShaderMask(
              blendMode: BlendMode.modulate,
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [clBody, Colors.orange],
                ).createShader(bounds);
              },
              child: const Icon(
                Icons.star,
                color: Colors.white,
                size: 20,
              ),
            );
          } else {
            return Icon(
              Icons.star,
              color: clBody,
              size: 20,
            );
          }
        },
      ),
      const SizedBox(
        width: 5,
      ),
      Text(rating.toString()),
    ],
  );
}

void processDialog(context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            content: SizedBox(
              height: 200.0,
              width: 200.0,
              child: Center(
                  child: CircularProgressIndicator(
                color: clPrimary,
              )),
            ),
          ));
}

void snackMessage(context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
