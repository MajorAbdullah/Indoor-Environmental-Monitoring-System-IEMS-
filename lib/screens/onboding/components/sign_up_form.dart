import 'package:fast_snackbar/fast_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iems/screens/onboding/components/emailVerification.dart';
import 'package:rive/rive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;
  late SMITrigger confetti;
  String emailAddress = '';
  String username = '';
  String userPassword = '';
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  var db = FirebaseFirestore.instance;

  Future<int> createUser() async {
    print(userPassword);
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: userPassword,
      );

      await credential.user!.sendEmailVerification();

      db.collection("users").doc(emailAddress).set({
        "username": username,
        "emailaddress": emailAddress,
        "age": ageController.text.toString(),
        "gender": genderController.text.toString(),
        "phoneNo": contactNoController.text.toString()
      }).onError((e, _) => print("Error writing document: $e"));
      return 200;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return 2;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return 1;
      }
      print(e);
    } catch (e) {
      print(e);
    }
    return 100;
  }

  void signUp(BuildContext context) async {
    int code = await createUser();
    print("HERE");
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (_formKey.currentState!.validate() && code == 200) {
        // show success
        check.fire();
        Future.delayed(const Duration(seconds: 2), () async {
          setState(() {
            isShowLoading = false;
          });

          context.showFastSnackbar(
              "Account created successfully, Try signing in now.",
              color: TypeFastSnackbar.success);
          confetti.fire();
          Navigator.pop(context);
        });
      } else if (code == 2) {
        error.fire();
        context.showFastSnackbar(
            "Password is weak. Use 8 characters with numbers and symbols",
            color: TypeFastSnackbar.error);

        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
        });
      } else {
        context.showFastSnackbar("Email already in use",
            color: TypeFastSnackbar.error);

        error.fire();
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      }
                      return null;
                    },
                    onChanged: (name) {
                      username = name;
                    },
                    decoration: const InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.person_3_sharp),
                        )),
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      label: Text("Age"),
                      prefixIcon: Icon(CupertinoIcons.app_badge)),
                  keyboardType: TextInputType.number,
                  controller: ageController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      label: Text("Gender"),
                      prefixIcon: Icon(CupertinoIcons.pause_rectangle)),
                  controller: genderController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      label: Text("Phone No"),
                      prefixIcon: Icon(CupertinoIcons.phone)),
                  keyboardType: TextInputType.number,
                  controller: contactNoController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      }
                      return null;
                    },
                    onChanged: (email) {
                      emailAddress = email;
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.email),
                        ),
                        labelText: "Enter Email"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "";
                      }
                      return null;
                    },
                    onChanged: (password) {
                      userPassword = password;
                    },
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.lock),
                        ),
                        labelText: "Enter Password"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 24),
                  child: ElevatedButton.icon(
                      onPressed: () async {
                        // // verifyOTP(,otp);
                        // // verifyOtp();
                        // print("TRYING");
                        if (_formKey.currentState!.validate()) {
                          debugPrint("User Password$userPassword");
                          try {
                            final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: emailAddress,
                              password: userPassword,
                            );

                            await credential.user!.sendEmailVerification();

                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VerificationScreen(
                                  fullName: username,
                                  age: ageController.text.toString(),
                                  gender: genderController.text.toString(),
                                  email: emailAddress,
                                  phoneNo: contactNoController.text.toString(),
                                ),
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            print(e.message);
                            if (e.code == 'weak-password') {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text(
                                      'The password provided is too weak.')));
                            } else if (e.code == 'email-already-in-use') {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text(
                                      'The account already exists for that email.')));
                            }
                            print(e);
                          } catch (e) {
                            print(e);
                          }
                        }

                        // signUp(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(double.infinity, 56),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                  bottomLeft: Radius.circular(25)))),
                      icon: const Icon(
                        CupertinoIcons.arrow_right,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            )),
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                "assets/RiveAssets/check.riv",
                onInit: (artboard) {
                  StateMachineController controller =
                      getRiveController(artboard);
                  check = controller.findSMI("Check") as SMITrigger;
                  error = controller.findSMI("Error") as SMITrigger;
                  reset = controller.findSMI("Reset") as SMITrigger;
                },
              ))
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
                child: Transform.scale(
                scale: 6,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/confetti.riv",
                  onInit: (artboard) {
                    StateMachineController controller =
                        getRiveController(artboard);
                    confetti =
                        controller.findSMI("Trigger explosion") as SMITrigger;
                  },
                ),
              ))
            : const SizedBox()
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child, this.size = 100});

  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: size,
            width: size,
            child: child,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
