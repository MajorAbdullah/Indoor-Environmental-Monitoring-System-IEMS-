import 'dart:io';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iems/screens/onboding/onboding_screen.dart';
import 'package:iems/screens/personalized_suggestions.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(currentUser?.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text('No data available'));
                    }
                    final yourData = snapshot.data;
                    debugPrint("Your Data: ${yourData?.data()}");

                    return SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: BlurryContainer(
                                  blur: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 2.3,
                                  height:
                                      MediaQuery.of(context).size.height / 8,
                                  elevation: 10,
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.all(8),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Email Address",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          yourData!['emailaddress'] ?? 'N/A',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: BlurryContainer(
                                  blur: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 2.3,
                                  height:
                                      MediaQuery.of(context).size.height / 8,
                                  elevation: 10,
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.all(8),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Username",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          yourData['username'] ?? 'N/A',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: BlurryContainer(
                                  blur: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 2.3,
                                  height:
                                      MediaQuery.of(context).size.height / 8,
                                  elevation: 10,
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.all(8),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Age",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          yourData['age'] ?? "N/A",
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: BlurryContainer(
                                  blur: 50,
                                  width:
                                      MediaQuery.of(context).size.width / 2.3,
                                  height:
                                      MediaQuery.of(context).size.height / 8,
                                  elevation: 10,
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.all(8),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Gender",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          yourData['gender'] ?? "N/A",
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BlurryContainer(
                              blur: 50,
                              width: MediaQuery.of(context).size.width / 2.3,
                              height: MediaQuery.of(context).size.height / 8,
                              elevation: 10,
                              color: Colors.transparent,
                              padding: const EdgeInsets.all(8),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Phone Number",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    Text(
                                      yourData['phoneNo'] ?? "N/A",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(currentUser?.email)
                      .collection("diseases")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Show loading indicator while data is being fetched
                    } else if (snapshot.hasError) {
                      debugPrint("Error: ${snapshot.error}");
                      return Text("Error: ${snapshot.error}");
                    }

                    // Check if data exists
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      final docSnapshot = snapshot.data!.docs.first;
                      final userData = docSnapshot.data() as Map;
                      debugPrint("User data: $userData");
                      return UserInfo(data: userData);
                    } else {
                      return UserInfo(data: const {});
                    }
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:[
                  ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PersonalizedSuggestions(),
                          ));
                    },
                    icon: const Icon(Icons.dashboard_customize),
                    label: const Text("Diseases"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AllergiesFormDialog();
                        },
                      );
                    },
                    label: const Text("Edit Your Info"),
                    icon: const Icon(Icons.info_outline),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardingScreen(),
                      ));
                },
                icon: const Icon(Icons.logout),
                label: const Text("Sign Out"),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  Map data;
  UserInfo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlurryContainer(
                blur: 50,
                width: MediaQuery.of(context).size.width / 2.3,
                height: MediaQuery.of(context).size.height / 8,
                elevation: 10,
                color: Colors.transparent,
                padding: const EdgeInsets.all(8),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Blood Pressure",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        data['bloodPressure'].toString() ?? "N/A",
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlurryContainer(
                blur: 50,
                width: MediaQuery.of(context).size.width / 2.3,
                height: MediaQuery.of(context).size.height / 8,
                elevation: 10,
                color: Colors.transparent,
                padding: const EdgeInsets.all(8),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Diabetes",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        data["diabetes"].toString() ?? 'N/A',
                        style: const TextStyle(fontSize: 18, color: Colors.white),
                      )
                    ]),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlurryContainer(
            blur: 50,
            width: MediaQuery.of(context).size.width / 1,
            height: MediaQuery.of(context).size.height / 2,
            elevation: 10,
            color: Colors.transparent,
            padding: const EdgeInsets.all(8),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Allergies",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Pollen Allergy",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['pollenAllergy'] != null ? data['pollenAllergy'].toString() : 'N/A',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Mold Allergy",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['moldAllergy'] != null ? data['moldAllergy'].toString() : 'N/A',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Dust Mite Allergy",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['dustMiteAllergy'] != null ? data['dustMiteAllergy'].toString() : 'N/A',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Pet Allergy",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['petAllergy'] != null ? data['petAllergy'].toString() : 'N/A',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Airborne Particulate Allergy",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['airborneParticulateAllergy'] != null ? data['airborneParticulateAllergy'].toString() : 'N/A',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Volatile Organic Compound (VOC)",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['volatileOrganicCompoundSensitivity'] != null ? data['volatileOrganicCompoundSensitivity'].toString() : 'N/A',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Nitrogen Dioxide (NO2) Sensitivity",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['nitrogenDioxideSensitivity'] != null ? data['nitrogenDioxideSensitivity'].toString() : 'N/A',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Formaldehyde Sensitivity",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['formaldehydeSensitivity'] != null ? data['formaldehydeSensitivity'].toString() : 'N/A',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ],
    );
  }
}

class AllergiesFormDialog extends StatefulWidget {
  const AllergiesFormDialog({super.key});

  @override
  State<AllergiesFormDialog> createState() => _AllergiesFormDialogState();
}

class _AllergiesFormDialogState extends State<AllergiesFormDialog> {
  var formKey = GlobalKey<FormState>();

  bool pollenAllergy = false;
  bool moldAllergy = false;
  bool dustMiteAllergy = false;
  bool petAllergy = false;
  bool airborneParticulateAllergy = false;
  bool volatileOrganicCompoundSensitivity = false;
  bool nitrogenDioxideSensitivity = false;
  bool formaldehydeSensitivity = false;

  TextEditingController bloodPressureController = TextEditingController();
  TextEditingController diabetesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Any Allergies",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customRow(
                "Pollen Allergy",
                Checkbox(
                    value: pollenAllergy,
                    onChanged: (e) {
                      setState(() {
                        pollenAllergy = true;
                      });
                    }),
              ),
              customRow(
                "Mold Allergy",
                Checkbox(
                  value: moldAllergy,
                  onChanged: (e) {
                    setState(() {
                      moldAllergy = true;
                    });
                  },
                ),
              ),
              customRow(
                "Dust Mite Allergy",
                Checkbox(
                    value: dustMiteAllergy,
                    onChanged: (e) {
                      setState(() {
                        dustMiteAllergy = true;
                      });
                    }),
              ),
              customRow(
                "Pet Allergy",
                Checkbox(
                    value: petAllergy,
                    onChanged: (e) {
                      setState(() {
                        petAllergy = true;
                      });
                    }),
              ),
              customRow(
                "Air Borne Particulate Allergy",
                Checkbox(
                    value: airborneParticulateAllergy,
                    onChanged: (e) {
                      setState(() {
                        airborneParticulateAllergy = true;
                      });
                    }),
              ),
              customRow(
                "Volatile Organic Compound Sensivity",
                Checkbox(
                    value: volatileOrganicCompoundSensitivity,
                    onChanged: (e) {
                      setState(() {
                        volatileOrganicCompoundSensitivity = true;
                      });
                    }),
              ),
              customRow(
                "Nitrogen Dioxide (NO2) Sensivity",
                Checkbox(
                    value: nitrogenDioxideSensitivity,
                    onChanged: (e) {
                      setState(() {
                        nitrogenDioxideSensitivity = true;
                      });
                    }),
              ),
              customRow(
                "Formaldegyde Sensivity",
                Checkbox(
                    value: formaldehydeSensitivity,
                    onChanged: (e) {
                      setState(() {
                        formaldehydeSensitivity = true;
                      });
                    }),
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    label: Text("Blood Pressure"), hintText: "160/100"),
                controller: bloodPressureController,
                validator: (v) {
                  if (v == null || v == '') {
                    return "Required";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration:
                const InputDecoration(label: Text("Diabetes"), hintText: "100"),
                controller: diabetesController,
                validator: (v) {
                  if (v == null || v == '') {
                    return "Required";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus!.unfocus();
                    if (formKey.currentState!.validate()) {
                      var db = FirebaseFirestore.instance;
                      var email = FirebaseAuth.instance.currentUser!.email;
                      var collectionRef = db
                          .collection("users")
                          .doc(email)
                          .collection("diseases");

                      try {
                        collectionRef.get().then((querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            var firstDocumentId = querySnapshot.docs.first.id;
                            collectionRef.doc(firstDocumentId).set({
                              "bloodPressure": bloodPressureController.text,
                              "diabetes": diabetesController.text,
                              "pollenAllergy": pollenAllergy,
                              "moldAllergy": moldAllergy,
                              "dustMiteAllergy": dustMiteAllergy,
                              "airborneParticulateAllergy": airborneParticulateAllergy,
                              "petAllergy": petAllergy,
                              "volatileOrganicCompoundSensitivity":
                                  volatileOrganicCompoundSensitivity,
                              "nitrogenDioxideSensitivity":
                                  nitrogenDioxideSensitivity,
                              "formaldehydeSensitivity": formaldehydeSensitivity
                            }).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Form Submitted'),
                                ),
                              );
                              Navigator.pop(context);
                            });
                          } else {
                            collectionRef.add({
                              "bloodPressure": bloodPressureController.text,
                              "diabetes": diabetesController.text,
                              "pollenAllergy": pollenAllergy,
                              "moldAllergy": moldAllergy,
                              "dustMiteAllergy": dustMiteAllergy,
                              "airborneParticulateAllergy": airborneParticulateAllergy,
                              "petAllergy": petAllergy,
                              "volatileOrganicCompoundSensitivity":
                              volatileOrganicCompoundSensitivity,
                              "nitrogenDioxideSensitivity":
                              nitrogenDioxideSensitivity,
                              "formaldehydeSensitivity": formaldehydeSensitivity
                            }).then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Form Submitted'),
                                ),
                              );
                              Navigator.pop(context);
                            });
                          }
                        });
                      } on SocketException {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Internet Connection Failed'),
                          ),
                        );
                      } catch (e) {
                        debugPrint("User Form Error: e");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                  child: const Text("Submit"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  customRow(String first, Widget second) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Expanded(child: Text(first)), second],
    );
  }
}
