import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/screens/provider/add_new_service.dart';
import 'package:home_mate/screens/provider/all_services.dart';
import 'package:home_mate/screens/provider/provider_services.dart';

class ProviderHome extends StatefulWidget {
  const ProviderHome({Key? key}) : super(key: key);

  @override
  State<ProviderHome> createState() => _ProviderHome();
}

class _ProviderHome extends State<ProviderHome> {
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
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 12),
            //   child: Column(
            //     children: [
            //       Row(
            //         mainAxisAlignment:MainAxisAlignment.spaceAround,
            //         children: [
            //           Container(
            //             padding: const EdgeInsets.all(12),
            //             decoration: BoxDecoration(
            //               color: clBG,
            //               border: Border.all(color: clBody),
            //               borderRadius: BorderRadius.circular(12),
            //             ),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       "98",
            //                       style: TextStyle(
            //                           color: clPrimary,
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 20),
            //                     ),
            //                     Text(
            //                       "Total Booking",
            //                       style: TextStyle(color: clBody, fontSize: 10),
            //                     ),
            //                   ],
            //                 ),
            //                 CircleAvatar(
            //                   radius: 22,
            //                   child: SvgPicture.asset(
            //                     "assets/icons/Ticket1.svg",
            //                     height: 22,
            //                     width: 22,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Container(
            //             padding: const EdgeInsets.all(12),
            //             decoration: BoxDecoration(
            //               color: clBG,
            //               border: Border.all(color: clBody),
            //               borderRadius: BorderRadius.circular(12),
            //             ),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       "15",
            //                       style: TextStyle(
            //                           color: clPrimary,
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 20),
            //                     ),
            //                     Text(
            //                       "Total Service",
            //                       style: TextStyle(color: clBody, fontSize: 10),
            //                     ),
            //                   ],
            //                 ),
            //                 CircleAvatar(
            //                   radius: 22,
            //                   child: SvgPicture.asset(
            //                     "assets/icons/Ticket1.svg",
            //                     height: 22,
            //                     width: 22,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 10,),
            //       Row(
            //         mainAxisAlignment:MainAxisAlignment.spaceAround,
            //
            //         children: [
            //           Container(
            //             padding: const EdgeInsets.all(12),
            //             decoration: BoxDecoration(
            //               color: clBG,
            //               border: Border.all(color: clBody),
            //               borderRadius: BorderRadius.circular(12),
            //             ),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       "30",
            //                       style: TextStyle(
            //                           color: clPrimary,
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 20),
            //                     ),
            //                     Text(
            //                       "Total Rating",
            //                       style: TextStyle(color: clBody, fontSize: 10),
            //                     ),
            //                   ],
            //                 ),
            //                 CircleAvatar(
            //                   radius: 22,
            //                   child: SvgPicture.asset(
            //                     "assets/icons/Ticket1.svg",
            //                     height: 22,
            //                     width: 22,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Container(
            //             padding: const EdgeInsets.all(12),
            //             decoration: BoxDecoration(
            //               color: clBG,
            //               border: Border.all(color: clBody),
            //               borderRadius: BorderRadius.circular(12),
            //             ),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       "\$45.3",
            //                       style: TextStyle(
            //                           color: clPrimary,
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 20),
            //                     ),
            //                     Text(
            //                       "Total Earning",
            //                       style: TextStyle(color: clBody, fontSize: 10),
            //                     ),
            //                   ],
            //                 ),
            //                 CircleAvatar(
            //                   radius: 22,
            //                   child: SvgPicture.asset(
            //                     "assets/icons/Ticket1.svg",
            //                     height: 22,
            //                     width: 22,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       )
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 10,),
            ListTile(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const AddService(),),);
              },
              leading: Icon(Icons.add),
              title: const Text("Add New Service"),
              trailing: const Icon(Icons.keyboard_arrow_right),
              tileColor: clContainer,
            ),
            const SizedBox(height: 10,),
            ListTile(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const AllProviderServices(),),);
              },
              leading: const Icon(Icons.edit),
              title: const Text("Update Service"),
              trailing: const Icon(Icons.keyboard_arrow_right),
              tileColor: clContainer,
            ),
            const SizedBox(height: 10,),
            ListTile(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const ProviderServices(),),);
              },
              leading: const Icon(Icons.view_agenda),
              title: const Text("View All Service"),
              trailing: const Icon(Icons.keyboard_arrow_right),
              tileColor: clContainer,
            ),

          ],
        ),
      ),
    );
  }
}
