import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/service_model.dart';
import 'package:home_mate/model/user_model.dart';
import 'package:home_mate/widgets/services_card.dart';

class ProviderDetails extends StatefulWidget {
  final String providerId;
  const ProviderDetails({super.key, required this.providerId});

  @override
  State<ProviderDetails> createState() => _ProviderDetailsState();
}

class _ProviderDetailsState extends State<ProviderDetails> {
  @override
  void initState() {
    super.initState();
  }
  late ProviderModel provider;
  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width * 1;
    double screenheight = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: clPrimary,
        title: const Text(
          "Provider Detail",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc(widget.providerId).snapshots(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          Map<String,dynamic> providerMap = snapshot.data!.data() as Map<String,dynamic>;
          provider = ProviderModel.fromMap(providerMap);
          return ListView(
            children: [
              Container(
                color: const Color(0xFFF6F7F9),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: (provider.profileUrl.isNotEmpty)? NetworkImage(
                        provider.profileUrl,
                      ):null,
                      radius: screenwidth * 0.13,
                      child: (!provider.profileUrl.isNotEmpty)?Icon(Icons.person_outline,size: screenwidth * 0.13,):null,
                    ),

                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${provider.fName} ${provider.lName}",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Text(provider.tagline),
                          const SizedBox(height: 5,),
                          printRating(provider.rating),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(
                  20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "About",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Text(
                        provider.description,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: screenwidth * 0.1),
                  padding: EdgeInsets.symmetric(vertical: screenwidth * 0.05,horizontal: screenwidth * 0.06),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                    color: clContainer,
                  ),
                  width: MediaQuery.of(context).size.width * 0.85,
                  // height: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        provider.email,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      const Text(
                        "Number",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        provider.phone,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10,),

                      const Text(
                        "Member Since",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "${provider.joined.day}/${provider.joined.month}/${provider.joined.year}",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  "Services",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              homeServices()
            ],
          );
        },
      ),
    );
  }

  Widget homeServices() {
      return StreamBuilder(
          stream: FirebaseFirestore.instance.collection("services").where("providerId",isEqualTo: provider.id).snapshots(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            if(snapshot.hasData){
              List<ServiceModel> providerService = snapshot.data!.docs.map((e) => ServiceModel.fromMap(e.data() as Map<String,dynamic>)).toList();
              if(providerService.isNotEmpty){
                return Column(
                  children: [
                    for (int i = 0; i < providerService.length; i++)
                      ServiceCard(
                        service: providerService[i],

                        width: 320,
                      ),
                    const SizedBox(height: 10,),
                    const Center(child: Text("No More",textAlign: TextAlign.center,style:TextStyle(fontSize: 18),))

                  ],
                );
              }
              return const Center(child: Text("Provider does not have any services available right now",textAlign: TextAlign.center,));

            }
            return const Center(child: Text("Something Went Wrong",textAlign: TextAlign.center,));


          });
    }
  }

