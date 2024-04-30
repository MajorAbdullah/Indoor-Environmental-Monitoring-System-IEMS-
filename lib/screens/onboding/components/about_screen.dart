import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'About us ',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    const Icon(Icons.arrow_forward_ios)
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    "At IEMS, we're committed to redefining indoor environments with advanced technology and data-driven solutions. Our expertise lies in seamlessly integrating AI algorithms and sensor networks to monitor and optimize indoor air quality, temperature, and humidity. With a focus on user-centric design and sustainability, we empower individuals and organizations to create healthier and more comfortable spaces. Join us in revolutionizing indoor living and working environments for a brighter future. Welcome to the forefront of indoor environmental monitoring with IEMS.",
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Privacy Policy',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios)
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "At Indoor Environmental Monitoring System (IEMS), we are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy outlines how we collect, use, disclose, and safeguard your data when you interact with our website, mobile application, or any other services provided by IEMS.\n\n"
                    "• Information Collection and Use:\n"
                    "   - We collect various types of information when you use our services, including personal data such as name, email address, and location, as well as non-personal data such as device information and usage data. This information is used to provide and improve our services, communicate with you, and personalize your experience.\n\n"
                    "• Data Sharing and Disclosure:\n"
                    "   - We may share your information with trusted third-party service providers who assist us in operating our website, conducting our business, or servicing you. We may also disclose your information in response to legal obligations, to protect our rights or property, or to prevent illegal activities.\n\n"
                    "• Data Security:\n"
                    "   - We implement industry-standard security measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet or electronic storage is 100% secure, and we cannot guarantee absolute security.\n\n"
                    "• Data Retention:\n"
                    "   - We retain your personal information only for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law.\n\n"
                    "• Your Rights:\n"
                    "   - You have the right to access, correct, or delete your personal information at any time. You may also opt out of receiving promotional communications from us by following the instructions provided in such communications.\n\n"
                    "• Children's Privacy:\n"
                    "   - Our services are not intended for children under the age of 13, and we do not knowingly collect personal information from children. If you believe that we have inadvertently collected information from a child, please contact us immediately.\n\n"
                    "• Changes to This Policy:\n"
                    "   - We reserve the right to update or change this Privacy Policy at any time. Any changes will be effective immediately upon posting the revised policy on our website. We encourage you to review this Privacy Policy periodically for any updates.\n\n"
                    "• Contact Us:\n"
                    "   - If you have any questions or concerns about this Privacy Policy or our data practices, please contact us at [insert contact email or address].\n\n"
                    "By using our services, you consent to the collection, use, and disclosure of your information as described in this Privacy Policy.",
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Developed by: Syed Abdullah Shah\n"
                    "Supervisor: Dr. Muhammad Awais Sattar.",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      'FeedBack',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    const Icon(Icons.feed_outlined)
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: GestureDetector(
                    onTap: ()async{
                      print('https://forms.gle/Zf9J72Xm8Acryqbz6');
                    },
                    child: const Text(
                      "Google Form",
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
