import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
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
      backgroundColor: clBG,
      appBar: AppBar(
        backgroundColor: clPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Payment Method",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc(user!.uid).snapshots(),
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasData){
            String method = snapshot.data!.data()!['paymentMethod']??"";
            return Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ListTile(
                    onTap: () async {
                      if(method != "cash"){
                        processDialog(context);
                        await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
                          "paymentMethod": "cash",
                        });
                        paymentMethod == "cash";
                        Navigator.pop(context);
                      }
                    },
                    title: const Text("Cash"),
                    trailing: const Icon(
                      Icons.payments,
                      color: Colors.green,
                    ),
                    tileColor: clContainer,
                    leading: (method == "cash")?const Icon(Icons.circle):const Icon(Icons.circle_outlined),
                  ),
                  ListTile(
                    onTap: ()async {
                      if(method != "online"){
                        processDialog(context);
                        await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
                          "paymentMethod": "online",
                        });
                        paymentMethod == "online";

                        Navigator.pop(context);
                      }
                    },
                    title: const Text("Online"),
                    trailing: const Icon(
                      Icons.currency_exchange,
                      color: Colors.green,
                    ),
                    tileColor: clContainer,
                    leading: (method == "online")?const Icon(Icons.circle):const Icon(Icons.circle_outlined),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text("Something went wrong"),);
        }
      ),
    );
  }


}
