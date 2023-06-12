import 'dart:async';
import 'package:findme/auth/userinfo.dart';
import 'package:findme/httpServices/httpServices.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class Otp extends StatefulWidget {
  const Otp({Key? key, required this.countryCode, required this.phoneNumber})
      : super(key: key);

  final String countryCode;
  final String phoneNumber;
  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _otp = TextEditingController();
  HttpServices httpServices = HttpServices();

  Timer? timer;
  int start = 60;

  // void startTimer() {
  //   timer = Timer.periodic(
  //     const Duration(seconds: 1),
  //     (Timer timer) {
  //       if (start == 0) {
  //         setState(() {
  //           timer.cancel();
  //         });
  //       } else {
  //         if (mounted) {
  //           setState(() {
  //             start--;
  //           });
  //         }
  //       }
  //     },
  //   );
  // }

  @override
  void initState() {
    // startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Sign in',
        ),
      ),
      // First
      body: buildOtpUi(),
    );
  }

  Widget buildOtpUi() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.grey.shade200
                        : Colors.grey[700],
                    shape: BoxShape.circle),
                child: const Icon(
                  Icons.work,
                  size: 70,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  'Verification',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  'Enter your verification number',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Pinput(
                controller: _otp,
                length: 4,
                onCompleted: (pin) async {
                  await httpServices.verifyOtp(
                    widget.countryCode,
                    widget.phoneNumber,
                    _otp.text,
                  );
                  if (httpServices.approved == "pending" &&
                      httpServices.valid == false) {
                    setState(() {
                      httpServices.loginStatus = 'invalid';
                      start = 0;
                    });
                  }
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(
                  //     builder: (context) => UserInfo(
                  //       countryCode: widget.countryCode,
                  //       phoneNumber: widget.phoneNumber,
                  //     ),
                  //   ),
                  // );
                  // if (httpServices.approved == "approved" &&
                  //     httpServices.valid == true) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => UserInfo(
                        countryCode: widget.countryCode,
                        phoneNumber: widget.phoneNumber,
                      ),
                    ),
                  );
                  // }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              start == 0
                  ? InkWell(
                      // onTap: () {
                      //   // startTimer();
                      //   setState(() {
                      //     start = 60;
                      //     startTimer();
                      //   });
                      // },
                      child: const Center(
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                      'Resend OTP ... $start sec',
                      style: const TextStyle(
                        fontSize: 17,
                      ),
                    )),
              const SizedBox(
                height: 10,
              ),
              httpServices.loginStatus == 'loading'
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : httpServices.loginStatus == 'invalid'
                      ? const Center(
                          child: Text(
                            'Invalid OTP. Please try again',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : Container()
            ],
          ),
        ),
      );
}
