import 'package:flutter/material.dart';
import 'contact_section.dart';

/// Example page demonstrating the ContactSection widget
class ContactSectionExample extends StatelessWidget {
  const ContactSectionExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Section Example'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // Add some spacing at the top
            SizedBox(height: 40),

            // Contact Section with form
            ContactSection(
              showContactForm: true,
            ),
          ],
        ),
      ),
    );
  }
}

/// Example of using ContactSection without the form
class ContactSectionWithoutForm extends StatelessWidget {
  const ContactSectionWithoutForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),

            // Contact Section without form (only contact info and social links)
            ContactSection(
              showContactForm: false,
            ),
          ],
        ),
      ),
    );
  }
}
