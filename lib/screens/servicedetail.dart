import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/model/service_model.dart';
import 'package:home_mate/model/user_model.dart';
import 'package:home_mate/screens/providerdetail.dart';
import 'package:home_mate/screens/search.dart';
import 'package:home_mate/screens/user/book_service.dart';
import 'package:home_mate/widgets/services_card.dart';

class ServiceDetail extends StatefulWidget {
  final ServiceModel info;
  const ServiceDetail({super.key, required this.info});

  @override
  State<ServiceDetail> createState() => _ServiceDetailState();
}

class _ServiceDetailState extends State<ServiceDetail> {
  User? user;
  late ServiceModel info;
  late ProviderModel provider;
  @override
  void initState() {
    info = widget.info;
    user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width * 1;
    double screenheight = MediaQuery.of(context).size.height * 1;
    return Scaffold(
      backgroundColor: clBorder,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc(info.providerId).snapshots(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          Map<String,dynamic> providerMap = snapshot.data!.data() as Map<String,dynamic>;
          provider = ProviderModel.fromMap(providerMap);
          return ListView(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: screenwidth,
                    height: screenheight * 0.40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: (info.coverUrl.isNotEmpty)
                            ? NetworkImage(info.coverUrl)
                            : const AssetImage("assets/images/new_service.png")
                        as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  //Service Details Container
                  Positioned(
                    top: (screenheight * 0.40 - ((screenheight * 0.3) / 2)),
                    left: ((screenwidth - screenwidth * 0.9) / 2),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        color: Colors.white,
                      ),
                      width: screenwidth * 0.9,
                      height: screenheight * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchService(
                                        category: info.category,
                                        ),
                                      ),

                                  );
                                },
                                child: Text(
                                  info.category,
                                  style: const TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 14,

                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: clPrimary,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: (){
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => SearchService(
                                    //       services: FilterService.withSubcategory(
                                    //           subCategory: info.subCategory),
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Text(
                                    info.subCategory,
                                    style: const TextStyle(
                                      fontSize: 14,
                                        overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            info.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                          Text(
                            "₹${info.price}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: clPrimary,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Duration:",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "01 Hour",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: clPrimary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Rating:",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    info.rating.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: clPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  //Favourite Button
                  Positioned(
                    right: 15,
                    top: 15,
                    child: InkWell(
                      onTap: ()async{
                        processDialog(context);
                        await updateBookmarks(info, user);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        setState(() {

                        });
                      },
                      child: CircleAvatar(
                          radius: 17,
                          backgroundColor: clBG,
                          child: (bookmarks.where((element) => element.id == info.id).isNotEmpty)?const Icon(Icons.favorite,color: Colors.red,):const Icon(Icons.favorite_outline,color: Colors.grey,)
                      ),
                    ),
                  ),

                  //Back Button
                  Positioned(
                    left: 15,
                    top: 15,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                          radius: 17,
                          backgroundColor: clBG,
                          child: const Icon(Icons.arrow_back)),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: (screenheight * 0.3 / 2) + 10),
                padding: const EdgeInsets.all(12),
                child: Container(
                  color: clBorder,
                  // height: phoneheight - imageheight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        info.description,
                      ),

                      // const SizedBox(
                      //   height: 30,
                      // ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProviderDetails(providerId: provider.id),),);
                },
                child: Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage:(provider.profileUrl.isNotEmpty)?
                            NetworkImage(provider.profileUrl):null,
                            radius: screenheight * 0.04,
                            child: (!provider.profileUrl.isNotEmpty)?Icon(Icons.person_outline,size: screenheight * 0.04,):null,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${provider.fName} ${provider.lName}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                printRating(provider.rating)
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.mail_outline,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              provider.email,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone_outlined,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            provider.phone,
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              provider.location,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 25,
                ),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Gallery",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "View all",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 80,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            height: 99,
                            width: 99,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/images/servicecover1.png',
                                ),
                              ),
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 99,
                            width: 99,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/images/servicecover1.png',
                                ),
                              ),
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 99,
                            width: 99,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/images/servicecover1.png',
                                ),
                              ),
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 99,
                            width: 99,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/images/servicecover1.png',
                                ),
                              ),
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Reviews",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("View all")
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(
                            'assets/images/Image.png',
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Gor Darshil",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                  ),
                                  InkWell(onTap: () {}, child: const Text("Edit")),
                                ],
                              ),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "4.5",
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet",
                      style: TextStyle(overflow: TextOverflow.clip),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(
                  20,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Related Services",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    homeServices(),
                    const SizedBox(height: 60,),
                  ],
                ),
              ),

            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: screenwidth,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => BookService(service: info,)),
              ),
            );
          },
          backgroundColor: clPrimary,
          child: const Text(
            "Continue",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
  Widget homeServices() {

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("services").where("category",isEqualTo: info.category).snapshots(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasData){
            List<ServiceModel> similarService = snapshot.data!.docs.map((e) => ServiceModel.fromMap(e.data())).toList();

            similarService.removeWhere((element) => element.id == info.id);

            if(similarService.isNotEmpty){
              return Column(
                children: [
                  for (int i = 0; i < similarService.length; i++)
                    ServiceCard(
                      service: similarService[i],
                      width: 320,
                    ),
                  const SizedBox(height: 10,),
                  const Center(child: Text("No More",textAlign: TextAlign.center,style:TextStyle(fontSize: 18),))

                ],
              );
            }
            return const Center(child: Text("There are not any similar services available right now",textAlign: TextAlign.center,));

          }
          return const Center(child: Text("Something went wrong",textAlign: TextAlign.center,));


        });

    }

  }

