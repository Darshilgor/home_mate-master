//Simple User Model
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String fName;
  String lName;
  String email;
  String profileUrl;
  String location;
  String phone;
  String type = "user";
  DateTime joined;
  String? paymentMethod;

  UserModel({
    required this.id,
    required this.fName,
    required this.lName,
    required this.email,
    required this.location,
    required this.profileUrl,
    required this.phone,
    required this.joined,
    this.paymentMethod,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'],
        fName: map['fName'],
        lName: map['lName'],
        email: map['email'],
        location: map['location'],
        profileUrl: map['profileUrl'],
        phone: map['phone'],
        joined: DateTime.tryParse(map['joined'])!,
        paymentMethod: map['paymentMethod']
    );
  }


  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "fName": fName,
      "lName": lName,
      "email": email,
      "location": location,
      "profileUrl": profileUrl,
      "phone": phone,
      "joined": joined.toIso8601String(),
      "type": type,
      "paymentMethod":paymentMethod,
    };
  }
}

//Provider Model
class ProviderModel {
  String id;
  String fName;
  String lName;
  String email;
  String profileUrl;
  String location;
  String phone;
  String type = "provider";
  DateTime joined;
  double rating;
  String tagline;
  String description;
  String? paymentMethod;

  ProviderModel({
    required this.id,
    required this.fName,
    required this.lName,
    required this.email,
    required this.location,
    required this.profileUrl,
    required this.phone,
    required this.joined,
    required this.tagline,
    required this.description,
    required this.rating,
    this.paymentMethod,
  });

  factory ProviderModel.fromMap(Map<String, dynamic> map) {
    return ProviderModel(
      id: map['id'],
      fName: map['fName'],
      lName: map['lName'],
      email: map['email'],
      location: map['location'],
      profileUrl: map['profileUrl'],
      phone: map['phone'],
      joined: DateTime.tryParse(map['joined'])!,
      tagline: map['tagline'],
      description: map['description'],
      rating: map['rating'],
      paymentMethod: map['paymentMethod'],
    );
  }

  static Future<ProviderModel> fromProviderID(String id)async{
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("users").doc(id).get();
    Map<String,dynamic> data = snap.data() as Map<String,dynamic>;
    return ProviderModel.fromMap(data);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "fName": fName,
      "lName": lName,
      "email": email,
      "location": location,
      "profileUrl": profileUrl,
      "phone": phone,
      "joined": joined.toIso8601String(),
      "type": type,
      "tagline": tagline,
      "description": description,
      "rating": rating,
      "paymentMethod":paymentMethod,
    };
  }
}

//Admin Model
class AdminModel {
  String id;
  String fName;
  String lName;
  String email;
  String profileUrl;
  String phone;
  String type = "admin";
  DateTime joined;

  AdminModel({
    required this.id,
    required this.fName,
    required this.lName,
    required this.email,
    required this.profileUrl,
    required this.phone,
    required this.joined,
  });

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      id: map['id'],
      fName: map['fName'],
      lName: map['lName'],
      email: map['email'],
      profileUrl: map['profileUrl'],
      phone: map['phone'],
      joined: DateTime.tryParse(map['joined'])!,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "fName": fName,
      "lName": lName,
      "email": email,
      "profileUrl": profileUrl,
      "phone": phone,
      "joined": joined.toIso8601String(),
      "type": type,
    };
  }
}
