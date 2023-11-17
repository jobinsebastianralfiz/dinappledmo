import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Enter the OTP sent to your mobile number',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          PinCodeTextField(
            appContext: context,
            length: 6,
            onChanged: (value) {
              // Handle changes in the OTP input
            },
            controller: otpController,
            keyboardType: TextInputType.number,
            animationType: AnimationType.fade,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
            ),
            onCompleted: (value) {
              // Handle when the OTP is fully entered
              print("Completed: $value");
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Validate and process the entered OTP
              String enteredOTP = otpController.text;
              // TODO: Implement OTP validation and login logic
            },
            child: Text('Verify OTP'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: OTPScreen(),
  ));
}
