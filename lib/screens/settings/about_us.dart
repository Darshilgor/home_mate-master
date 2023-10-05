import 'package:flutter/material.dart';
import 'package:home_mate/constant/colors.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clBG,

      appBar: AppBar(
        backgroundColor: clPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("About Us",
          style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(

          children: const [

            SizedBox(height: 20),
            Text(
              'Welcome to Home Mate',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Your Trusted Home Services Partner',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 20),
            Text(
              '''
              Home Mate is your one-stop solution for all your home service needs. Our platform connects you with experienced and reliable professionals who are ready to assist you with various tasks and projects around your home.

              Our mission is to make your life easier by providing top-quality services, whether it's cleaning, repairs, gardening, or any other home-related task. We value your time and comfort, and that's why we're dedicated to delivering excellence in every service we offer.

              Thank you for choosing Home Mate for your home service needs. We're here to make your home a better place.

              Contact us at support@homemateapp.com for any inquiries or assistance.

              Stay connected with us on social media!
              ''',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
