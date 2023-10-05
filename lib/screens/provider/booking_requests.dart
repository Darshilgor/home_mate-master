import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/payment_model.dart';
import 'package:home_mate/model/service_model.dart';
import 'package:home_mate/model/user_model.dart';

class ProviderOrders extends StatefulWidget {
  const ProviderOrders({super.key});

  @override
  State<ProviderOrders> createState() => _ProviderOrders();
}

class _ProviderOrders extends State<ProviderOrders> {
  User? user;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: clPrimary,
        title: const Text(
          "Orders",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            //dropDown(context, controller, items),
            // const SizedBox(
            //   height: 8,
            // ),
            // const Text(
            //   " Your Booking List",
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            // ),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("requests").where("orderStatus",isEqualTo: "Pending").snapshots(),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  if(snapshot.hasData){
                    List<PaymentReceiptModel> history = snapshot.data!.docs.map((e) => PaymentReceiptModel.fromMap(e.data())).toList();

                    if(history.isNotEmpty){
                      return Column(
                        children: [
                          for(PaymentReceiptModel e in history)
                            boX(e.userID,e.orderID,e.serviceId, e.amount, e.discount, e.paymentDate, e.paymentMethod,e.orderStatus)
                        ],
                      );
                    }
                    return const Center(child: Text("Empty"),);
                  }
                  return const Center(child: Text("Something went wrong"),);

                }),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }



  boX(String userId,String orderId,String id,  double price, double offer,
      DateTime dateTime, String payment,String status) {

    return FutureBuilder(
        future: FirebaseFirestore.instance.collection("services").doc(id).get(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const SizedBox();
          }
          if(snapshot.hasData){
            ServiceModel service = ServiceModel.fromMap(snapshot.data!.data() as Map<String,dynamic>);
            String photo = service.coverUrl;
            String lable = service.name;
            String date = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
            String time = (dateTime.hour == 12)?"${dateTime.hour}PM":(dateTime.hour <12)?"${dateTime.hour}AM":"${dateTime.hour -12}PM";
            return FutureBuilder(
                future: FirebaseFirestore.instance.collection("users").doc(service.providerId).get(),
                builder: (context,snap) {
                  if(snap.connectionState == ConnectionState.waiting){
                    return const SizedBox();
                  }
                  ProviderModel provider = ProviderModel.fromMap(snap.data!.data() as Map<String,dynamic>);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.8),
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage(photo),fit: BoxFit.cover),
                                  // color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              lable,
                              style:
                              const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(orderId),
                            const SizedBox(
                              height: 8,
                            ),
                            RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "₹${price.toString()}",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  TextSpan(
                                      text: " (${offer.toString()}% off)",
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green))
                                ])),
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Date",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                          Text(date),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Time",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                          Text(time),
                                        ],
                                      ),
                                    ),

                                    const Divider(
                                      height: 1,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Payment",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                          Text(payment),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: ()async{
                                            await FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("requests").doc(orderId).update({
                                              "orderStatus":"Accepted",
                                            });
                                            await FirebaseFirestore.instance.collection("users").doc(userId).collection("bookings").doc(orderId).update({
                                              "orderStatus":"Accepted",
                                            });

                                          },
                                          child: Container(
                                            padding:const EdgeInsets.all(12),
                                            decoration:BoxDecoration(
                                              color: clPrimary
                                            ),
                                              child: const Text("Accept",style: TextStyle(color: Colors.white),)),
                                        ),
                                        InkWell(
                                          onTap: ()async{
                                            await FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("requests").doc(orderId).delete();
                                            await FirebaseFirestore.instance.collection("users").doc(userId).collection("bookings").doc(orderId).update({
                                              "orderStatus":"Declined",
                                            });
                                            
                                          },
                                          child: Container(
                                              padding:const EdgeInsets.all(12),
                                              decoration:const BoxDecoration(
                                                  color: Colors.white
                                              ),
                                              child: const Text("Decline",style: TextStyle(),)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
            );
          }
          return const SizedBox();
        }
    );
  }
}
