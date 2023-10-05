import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/screens/admin/add_new_category.dart';
import 'package:home_mate/screens/admin/all_categories.dart';
import 'package:home_mate/screens/admin/all_users.dart';
import 'package:home_mate/screens/admin/featured_categories.dart';
import 'package:home_mate/screens/admin/featured_services.dart';
import 'package:home_mate/screens/admin/slider_services.dart';
import 'package:home_mate/screens/search.dart';
import 'package:home_mate/screens/user/category.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clBG,
      appBar: AppBar(
        backgroundColor: clPrimary,
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),

            ListTile(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const AddCategory(),),);
              },
              leading: Icon(Icons.add),
              title: const Text("Add New Category"),
              trailing: const Icon(Icons.keyboard_arrow_right),
              tileColor: clContainer,
            ),
            const SizedBox(height: 10,),
            ListTile(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const AllCategories(),),);
              },
              leading: const Icon(Icons.edit),
              title: const Text("Update Category"),
              trailing: const Icon(Icons.keyboard_arrow_right),
              tileColor: clContainer,
            ),
            const SizedBox(height: 10,),
            ListTile(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const FeaturedCategories(),),);
              },
              leading: const Icon(Icons.featured_play_list),
              title: const Text("Featured Categories"),
              trailing: const Icon(Icons.keyboard_arrow_right),
              tileColor: clContainer,
            ),
            const SizedBox(height: 10,),
            ListTile(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const Categories(),),);
              },
              leading: const Icon(Icons.view_agenda),
              title: const Text("View All Categories"),
              trailing: const Icon(Icons.keyboard_arrow_right),
              tileColor: clContainer,
            ),

            const SizedBox(height: 10,),
            ListTile(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const FeaturedServices(),),);
              },
              leading: const Icon(Icons.view_column),
              title: const Text("Featured Services"),
              trailing: const Icon(Icons.keyboard_arrow_right),
              tileColor: clContainer,
            ),
            const SizedBox(height: 10,),
            ListTile(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const SliderServices(),),);
              },
              leading: const Icon(Icons.view_carousel),
              title: const Text("Slider Services"),
              trailing: const Icon(Icons.keyboard_arrow_right),
              tileColor: clContainer,
            ),
            const SizedBox(height: 10,),
            ListTile(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>SearchService(),),);
              },
              leading: const Icon(Icons.view_list_rounded),
              title: const Text("View All Services"),
              trailing: const Icon(Icons.keyboard_arrow_right),
              tileColor: clContainer,
            ),
            const SizedBox(height: 10,),
            ListTile(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const AllUsers(),),);
              },
              leading: const Icon(Icons.group),
              title: const Text("View All Users"),
              trailing: const Icon(Icons.keyboard_arrow_right),
              tileColor: clContainer,
            ),

          ],
        ),
      ),
    );
  }
}
