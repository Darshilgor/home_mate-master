import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/payment_model.dart';
import 'package:home_mate/model/service_model.dart';
import 'package:home_mate/model/user_model.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  User? user;
  List<DropDownValueModel> items = [
    const DropDownValueModel(name: "Pending", value: "Pending"),
    const DropDownValueModel(name: "Completed", value: "Completed"),
  ];

  final SingleValueDropDownController controller =
      SingleValueDropDownController();
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
          "Booking",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  stream: FirebaseFirestore.instance.collection("users").doc(user!.uid).collection("bookings").snapshots(),
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
                              boX(e.orderID,e.serviceId, e.amount, e.discount, e.paymentDate, e.paymentMethod,e.orderStatus)
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
      ),
    );
  }

  dropDown(context, SingleValueDropDownController controller,
      List<DropDownValueModel> items) {
    return Container(
      color: Colors.grey[200],
      child: DropDownTextField(
        clearOption: false,
        controller: controller,
        dropDownItemCount: items.length,
        dropDownList: items,
        dropdownRadius: 0,
        textFieldDecoration: InputDecoration(
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).primaryColor,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  boX(String orderId,String id,  double price, double offer,
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
                                      const Text("Provider",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      Text("${provider.fName} ${provider.lName}"),
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
                                const Divider(
                                  height: 1,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Status",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      Text(status),
                                    ],
                                  ),
                                ),
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
