import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:increment_decrement_form_field/increment_decrement_form_field.dart';
import 'package:rive/rive.dart';

class UserInfoForm extends StatefulWidget {
  const UserInfoForm({super.key});

  @override
  State<UserInfoForm> createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
          ),
          const RiveAnimation.asset('assets/RiveAssets/shapes.riv',
              fit: BoxFit.fitHeight),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
            child: const SizedBox(),
          ),
          SafeArea(
            child: Column(
              children: [
                const Text("Age"),
                IncrementDecrementFormField<int>(
                  incrementIconButtonConfig: const IconButtonConfig(
                      icon: Icon(Icons.add), color: Colors.white),
                  decrementIconButtonConfig: const IconButtonConfig(
                      icon: Icon(Icons.remove), color: Colors.white),
                  // an initial value
                  initialValue: 0,

                  // return the widget you wish to hold the value, in this case Text
                  // if no value set 0, otherwise display the value as a string
                  displayBuilder: (value, field) {
                    return Text(
                      value == null ? "0" : value.toString(),
                      style: const TextStyle(color: Colors.white),
                    );
                  },

                  // run when the left button is pressed (decrement)
                  // the current value is passed as a parameter
                  // return what you want to update the display value to
                  // when decrement is pressed. In this case if null 0,
                  // otherwise current value -1
                  onDecrement: (currentValue) {
                    return currentValue! - 1;
                  },

                  // run when the right button is pressed (increment)
                  // the current value is passed as a parameter
                  // return what you want to update the display value to
                  // when increment is pressed. In this case if null 0,
                  // otherwise current value +1
                  onIncrement: (currentValue) {
                    return currentValue! + 1;
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
