import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iems/screens/current_weather.dart';

class VerificationScreen extends StatefulWidget {
  VerificationScreen(
      {super.key,
      required this.fullName,
      required this.age,
      required this.gender,
      required this.phoneNo,
      required this.email});

  var fullName, age, gender, phoneNo, email;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Icon(
                Icons.email_outlined,
                size: 110,
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                'Verify Your Email Address',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'We have just send email verification link on your email. Please check email and click on the link to verify you email address.',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.6)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'After Verification, Click on Continue button',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.6)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
              isLoading == true ? const CircularProgressIndicator()
                  : OutlinedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    debugPrint("Pressed");
                    final user = FirebaseAuth.instance.currentUser;
                    await user!.reload();
                    if (user.emailVerified) {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(user.email)
                          .set({
                        "username": widget.fullName,
                        "emailaddress": widget.email,
                        "age": widget.age,
                        "gender": widget.gender,
                        "phoneNo": widget.phoneNo
                      }).then((value) {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WeatherPage()));
                      }).catchError((error) {
                        setState(() {
                          isLoading = false;
                        });
                        debugPrint('Error setting user data: $error');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Failed to set user data. Please try again later.')),
                        );
                      });
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Please verify your email address before proceeding.')),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    debugPrint("Error: $e");
                  }
                },
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 15),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)))),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              TextButton(
                  onPressed: () async {
                    try {
                      final user = FirebaseAuth.instance.currentUser;
                      await user!.sendEmailVerification();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Verification email sent. Check your inbox.')),
                      );
                    } catch (e) {
                      debugPrint('Error sending verification email: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Failed to send verification email. Please try again later.')),
                      );
                    }
                  },
                  child: const Text(
                    'Resend E-mail Link',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent),
                  )),
              TextButton.icon(
                onPressed: () async {
                  User? user = FirebaseAuth.instance.currentUser;
                  user!.delete();
                  Navigator.pop(context);
                },
                label: const Text(
                  'Back to Login',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent),
                ),
                icon: const Icon(
                  Icons.arrow_back_sharp,
                  color: Colors.blueAccent,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
