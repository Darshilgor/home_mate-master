import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:home_mate/model/payment_model.dart';
import 'package:home_mate/model/service_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';

class BookService extends StatefulWidget {
  final ServiceModel service;
  const BookService({super.key, required this.service});

  @override
  State<BookService> createState() => _BookServiceState();
}

class _BookServiceState extends State<BookService> {
  bool flag = true;
  late ServiceModel service;

  //Step 1
  List<Placemark>? location;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController postalCode = TextEditingController();
  TextEditingController administrativeArea = TextEditingController();
  TextEditingController locality = TextEditingController();
  TextEditingController subLocality = TextEditingController();
  TextEditingController street = TextEditingController();

  DateTime now = DateTime.now();

  DateTime selectedDate = (DateTime.now().hour < 17)
      ? DateTime.now()
      : DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day + 1, 0, 0, 0, 0, 0);
  DateTime initialDate = (DateTime.now().hour < 17)
      ? DateTime.now()
      : DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day + 1, 0, 0, 0, 0, 0);

  //Step 2
  int quantity = 1;
  double discount = 5;
  double tax = 18;
  double subTotal = 0;
  double discountAmount = 0;
  double taxAmount = 0;
  double totalAmount = 0;
  User? user;

  List<DropdownMenuItem> timeOpt = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    service = widget.service;
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    subTotal = double.parse((service.price * quantity).toStringAsFixed(2));
    discountAmount =
        double.parse((subTotal * discount / 100).toStringAsFixed(2));
    taxAmount = double.parse((subTotal * tax / 100).toStringAsFixed(2));
    totalAmount = double.parse(
        (subTotal + taxAmount - discountAmount).toStringAsFixed(2));
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: clPrimary,
        title: const Text(
          "Book Service",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(100)),
                        child: flag
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("01"),
                              )
                            : const Icon(Icons.done),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Step 1")
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text("---------------"),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(100)),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("02"),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Step 2")
                    ],
                  ),
                ],
              ),
            ),
          ),
          Visibility(
              visible: flag,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      " Enter Detail information",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: clContainer,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              const Text("Date And Time :"),
                              const SizedBox(
                                height: 5,
                              ),
                              DatePicker(
                                initialDate,
                                onDateChange: (date) {
                                  setState(() {
                                    selectedDate = date;
                                    timeOpt.clear();
                                    now = (selectedDate.day ==
                                                DateTime.now().day &&
                                            selectedDate.month ==
                                                DateTime.now().month)
                                        ? DateTime(
                                            selectedDate.year,
                                            selectedDate.month,
                                            selectedDate.day,
                                            DateTime.now().hour,
                                          )
                                        : selectedDate;
                                    for (int i = now.hour; i <= 17; i++) {
                                      if (i >= 10) {
                                        timeOpt.add(DropdownMenuItem(
                                          alignment: Alignment.center,
                                          value: DateTime(
                                            selectedDate.year,
                                            selectedDate.month,
                                            selectedDate.day,
                                            i,
                                          ),
                                          child: (i == 12)
                                              ? Text("${i}PM")
                                              : (i < 12)
                                                  ? Text("${i}AM")
                                                  : Text("${i - 12}PM"),
                                        ));
                                        continue;
                                      }
                                      continue;
                                    }
                                  });
                                  print(timeOpt);
                                },
                                initialSelectedDate: selectedDate,
                                selectionColor: clPrimary,
                                height: 100,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              DropdownButtonFormField(
                                value: (timeOpt.isNotEmpty)
                                    ? timeOpt[0].value
                                    : null,
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    now = (value.day == DateTime.now().day &&
                                            value.month == DateTime.now().month)
                                        ? DateTime(
                                            value.year,
                                            value.month,
                                            value.day,
                                            DateTime.now().hour,
                                          )
                                        : value;
                                  });
                                },
                                icon: const Icon(Icons.keyboard_arrow_down),
                                validator: (value) {
                                  if (value == null) {
                                    return "This field can't be null";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "Select Time",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                dropdownColor: clContainer,
                                items: timeOpt.toSet().toList(),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              DropdownButtonFormField(
                                value: paymentMethod.isNotEmpty
                                    ? paymentMethod
                                    : null,
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    paymentMethod = value ?? "cash";
                                  });
                                },
                                icon: const Icon(Icons.keyboard_arrow_down),
                                validator: (value) {
                                  if (value == null) {
                                    return "This field can't be null";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "Payment Method",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                dropdownColor: clContainer,
                                items: [
                                  const DropdownMenuItem(
                                    child: Text("cash"),
                                    value: "cash",
                                  ),
                                  const DropdownMenuItem(
                                    child: Text("online"),
                                    value: "online",
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text("Your Address :"),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: street,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  hintText: "Street",
                                  labelText: "Street",
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: subLocality,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "This field can't be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  hintText: "Sublocality",
                                  labelText: "Sublocality",
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: locality,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "This field can't be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  hintText: "District",
                                  labelText: "District",
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: administrativeArea,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "This field can't be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  hintText: "State",
                                  labelText: "State",
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: postalCode,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "This field can't be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  counterText: "",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  hintText: "Postal or Pin Code",
                                  labelText: "Postal Code",
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: () async {
                                        processDialog(context);
                                        location = await determinePosition();
                                        Navigator.pop(context);
                                        Placemark myPlace = location![0];
                                        street.text = myPlace.street ?? "NA";
                                        subLocality.text =
                                            myPlace.subLocality ?? "NA";
                                        locality.text =
                                            myPlace.locality ?? "NA";
                                        administrativeArea.text =
                                            myPlace.administrativeArea ?? "NA";
                                        postalCode.text =
                                            myPlace.postalCode ?? "NA";

                                        setState(() {});
                                      },
                                      child: Text(
                                        "Use Current Location",
                                        style: TextStyle(color: clPrimary),
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            flag = false;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: clPrimary,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Center(
                            child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                      ),
                    )
                  ],
                ),
              )),
          Visibility(
              visible: !flag,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: clContainer,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              quantity++;
                                            });
                                          },
                                          child: const Icon(Icons.arrow_drop_up)),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(quantity.toString()),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            if (quantity > 1) {
                                              quantity--;
                                            }
                                            setState(() {});
                                          },
                                          child:
                                              const Icon(Icons.arrow_drop_down))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: (service.coverUrl.isNotEmpty)
                                      ? NetworkImage(service.coverUrl)
                                      : const AssetImage(
                                              "assets/images/new_service.png")
                                          as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(12)),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      " Price Detail",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: clContainer,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            minVerticalPadding: 0,
                            title: const Text("Price"),
                            trailing: Text(
                              "₹${service.price.toString()}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            minVerticalPadding: 0,
                            title: const Text("Sub Total"),
                            trailing: Text(
                              "₹${subTotal.toString()}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            minVerticalPadding: 0,
                            title:
                                Text("Discount (${discount.toString()}% off)"),
                            trailing: Text(
                              "-₹${(discountAmount).toString()}",
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 16),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            minVerticalPadding: 0,
                            title: Text("Tax (${tax.toString()}%)"),
                            trailing: Text(
                              "+₹${(taxAmount).toString()}",
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 16),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            minVerticalPadding: 0,
                            title: const Text("Total Amount"),
                            trailing: Text(
                              "₹${(totalAmount).toString()}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              flag = true;
                            });
                          },
                          child: Container(
                            width: 140,
                            height: 50,
                            decoration: BoxDecoration(
                              color: clContainer,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Center(
                                child: Text(
                              "Previous",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (paymentMethod == "online") {
                              Razorpay razorpay = Razorpay();
                              var options = {
                                'key': 'rzp_live_ILgsfZCZoFIKMb',
                                'amount': totalAmount * 100,
                                'name': service.name,
                                'description': service.name,
                                'retry': {'enabled': true, 'max_count': 1},
                                'send_sms_hash': true,
                                'prefill': {
                                  'contact': '8888888888',
                                  'email': 'test@razorpay.com'
                                },
                                'external': {
                                  'wallets': ['paytm']
                                }
                              };
                              razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
                                  handlePaymentErrorResponse);
                              razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                                  handlePaymentSuccessResponse);
                              razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                                  handleExternalWalletSelected);
                              razorpay.open(options);
                            } else {
                              await paymentSuccess(totalAmount);
                            }
                          },
                          child: Container(
                            width: 140,
                            height: 50,
                            decoration: BoxDecoration(
                              color: clPrimary,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Center(
                                child: Text(
                              "Next",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Future<List<Placemark>> determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Navigator.pop(context);
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();

    return placemarkFromCoordinates(position.latitude, position.longitude);
  }

  //Razorpay
  void handlePaymentErrorResponse(PaymentFailureResponse response) async {
    await paymentSuccess(totalAmount);
    // showAlertDialog(context, "Payment Failed",
    //     "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> paymentSuccess(double totalAmount) async {
    processDialog(context);
    String uniqueId = const Uuid().v1();
    PaymentReceiptModel payment = PaymentReceiptModel(
      orderID: uniqueId,
      orderStatus: "Pending",
      serviceId: service.id,
      discount: discount,
      quantity: quantity,
      amount: totalAmount,
      paymentDate: now,
      paymentMethod: paymentMethod,
      tax: tax,
      userID: user!.uid,
    );
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("bookings")
        .doc(uniqueId)
        .set(payment.toMap());
    await FirebaseFirestore.instance
        .collection("users")
        .doc(service.providerId)
        .collection("requests")
        .doc(uniqueId)
        .set(payment.toMap());
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
