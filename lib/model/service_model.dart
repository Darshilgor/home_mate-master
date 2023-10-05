import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/model/user_model.dart';

class ServiceModel {
  String id;
  String name;
  String description;
  String category;
  String subCategory;
  String coverUrl;
  double price;
  double rating;
  bool isFeatured;
  bool isSlider;
  String providerId;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.subCategory,
    required this.rating,
    required this.coverUrl,
    required this.price,
    required this.providerId,
    required this.isFeatured,
    required this.isSlider,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      subCategory: map['subCategory'],
      rating: map['rating'],
      coverUrl: map['coverUrl'],
      price: map['price'],
      providerId: map['providerId'],
      isFeatured: map['isFeatured'],
      isSlider: map['isSlider'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "category": category,
      "subCategory": subCategory,
      "rating": rating,
      "coverUrl": coverUrl,
      "price": price,
      "providerId": providerId,
      "isFeatured": isFeatured,
      "isSlider": isSlider,
    };
  }
}

//To filter services from all services
class FilterService {}
