import 'dart:convert';

import 'package:findme/httpServices/httpServices.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user.dart';

class Hire extends StatefulWidget {
  const Hire({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.bio,
    required this.category,
    required this.payment,
    required this.rating,
  });

  final int? id;
  final String? image;
  final String? name;
  final String? bio;
  final String? category;
  final String? payment;
  final String? rating;

  @override
  State<Hire> createState() => _HireState();
}

class _HireState extends State<Hire> {
  final TextEditingController _jobDescription = TextEditingController();
  final TextEditingController _jobAmount = TextEditingController();
  DateTime dateTime = DateTime.now();
  HttpServices httpServices = HttpServices();
  DateTime? startDate;
  DateTime? endDate;
  User? user;
  String? jobStatus = 'PENDING';
  String? payment = 'false';

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = jsonDecode(prefs.getString('user').toString());
    setState(() {
      user = User.fromJson(map);
    });
    print(map['category']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Divider(),
            // description
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade200
                    : Colors.grey[700],
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade300
                      : Colors.grey.shade700,
                ),
              ),
              child: TextFormField(
                controller: _jobDescription,
                maxLines: 6,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border: InputBorder.none,
                  hintText: 'Add description (optional)',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // amount
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade200
                    : Colors.grey[700],
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade300
                      : Colors.grey.shade700,
                ),
              ),
              child: TextFormField(
                controller: _jobAmount,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter amount',
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                            child: Text(
                              'KES',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // start date and end date
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey.shade200
                          : Colors.grey[700],
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey.shade300
                            : Colors.grey.shade700,
                      ),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: dateTime,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (newDate == null) return;
                          setState(() {
                            dateTime = newDate;
                          });
                        },
                        child: Text(
                          '${dateTime.year}/${dateTime.month}/${dateTime.day}',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey.shade200
                          : Colors.grey[700],
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey.shade300
                            : Colors.grey.shade700,
                      ),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: dateTime,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (newDate == null) return;
                          setState(() {
                            endDate = newDate;
                          });
                        },
                        child: Text(
                          endDate == null
                              ? 'End date'
                              : '${endDate!.year}/${endDate!.month}/${endDate!.day}',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // TextButton(
                //     onPressed: () {
                //       Navigator.pop(context);
                //     },
                //     child: const Text('Cancel')),
                InkWell(
                  onTap: () {
                    httpServices.addTask(
                      user!.id.toString(),
                      '${widget.id}',
                      '${widget.category}',
                      _jobDescription.text,
                      _jobAmount.text,
                      startDate.toString(),
                      endDate.toString(),
                      jobStatus.toString(),
                      payment.toString(),
                    );
                  },
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
