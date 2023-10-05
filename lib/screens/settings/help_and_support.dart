import 'package:flutter/material.dart';
import 'package:home_mate/constant/colors.dart';

class HelpSupport extends StatelessWidget {
  const HelpSupport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<FAQItem> faqItems = [
      FAQItem(
        question: 'How do I book a service?',
        answer:
            'To book a service, simply open the app, log in to your account, choose the service you need, select a date and time, and confirm your booking.',
      ),
      FAQItem(
        question: 'How can I cancel a booking?',
        answer:
            'You can cancel a booking by going to the "My Bookings" section in the app, selecting the booking you want to cancel, and following the provided instructions.',
      ),
      FAQItem(
        question: 'What payment methods do you accept?',
        answer:
            'We accept various payment methods, including credit cards, debit cards, and digital wallets. Payment details can be entered during the booking process.',
      ),
      // Add more FAQ items here
    ];
    return Scaffold(
      backgroundColor: clBG,
      appBar: AppBar(
        backgroundColor: clPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Help & Support",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Contact Us',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'If you need assistance or have any questions, you can reach out to our support team:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            const Text(
              'Email: support@homemateapp.com',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Frequently Asked Questions (FAQs)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Check out our FAQs for quick answers to common questions:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Column(
              children: [
                for (FAQItem i in faqItems)
                  ExpansionTile(
                    title: Text(i.question),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(i.answer),
                      ),
                    ],
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
