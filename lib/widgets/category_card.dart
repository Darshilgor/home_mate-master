import 'package:flutter/material.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/category_model.dart';
import 'package:home_mate/model/service_model.dart';
import 'package:home_mate/screens/search.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  const CategoryCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchService(
              category: category.name,
            ),
          ),
        );
      },
      child: LayoutBuilder(
        builder: (context,constraints){
          double height = constraints.maxHeight;
          double width = constraints.maxWidth;
          return Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: height / 1.2,
                height: height * 0.66,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  image: DecorationImage(
                    image: NetworkImage(category.coverUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: height / 1.2,
                height: height * 0.34,
                decoration: BoxDecoration(
                  color: clContainer,
                  borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
