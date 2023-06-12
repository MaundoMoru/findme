import 'package:findme/auth/otp.dart';
import 'package:findme/httpServices/httpServices.dart';
import 'package:flutter/material.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _phoneNumber = TextEditingController();
  HttpServices httpServices = HttpServices();
  bool enabled = true;

  final countryPicker = const FlCountryCodePicker();
  CountryCode? countryCode;

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
      body: buildLogin(),
    );
  }

  Widget buildLogin() => Stack(
        children: [
          Padding(
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
                      'Registration',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                    child: Text(
                      'Add your phone number. We\'ll send you a verification code so we know you\'re real',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      controller: _phoneNumber,
                      // enabled: enabled,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter phone number',
                        border: const OutlineInputBorder(),
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final code = await countryPicker.showPicker(
                                    context: context);
                                setState(() {
                                  countryCode = code;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                height: 56,
                                // width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      child: countryCode != null
                                          ? countryCode!.flagImage
                                          : Container(
                                              width: 35,
                                            ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Center(
                                      child: Text(
                                        countryCode?.dialCode ?? '+1',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        } else if (countryCode == null) {
                          return 'Please select country code';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  _phoneNumber.text == ''
                      ? TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          onPressed: () {},
                          child: const Text('Send'),
                        )
                      : TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            side: BorderSide(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {});
                            if (_form.currentState!.validate()) {
                              await httpServices.sendOtp(
                                countryCode!.dialCode,
                                _phoneNumber.text,
                              );
                              if (httpServices.approved == '400' &&
                                  httpServices.valid == null) {
                                setState(() {
                                  httpServices.loginStatus = 'invalid';
                                });
                              }
                              // if (httpServices.approved == "pending" &&
                              //     httpServices.valid == false) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => Otp(
                                    countryCode: countryCode!.dialCode,
                                    phoneNumber: _phoneNumber.text,
                                  ),
                                ),
                              );
                              // }
                            }
                          },
                          // color: Colors.blue,
                          child: httpServices.isLoading == true
                              ? Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SpinKitCircle(
                                          color: Colors.grey.shade300,
                                          size: 30.0,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Text(
                                        'Please wait...',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const Text(
                                  'Send',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  httpServices.loginStatus == 'loading'
                      ? const SizedBox(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : httpServices.loginStatus == 'invalid'
                          ? const Center(
                              child: Text(
                                'Please enter a valid phone number',
                                style: TextStyle(color: Colors.red),
                              ),
                            )
                          : Container()
                ],
              ),
            ),
          ),
          httpServices.loginStatus == 'loading'
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
        ],
      );
}
