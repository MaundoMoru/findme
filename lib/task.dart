import 'dart:convert';
import 'package:findme/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskDetails extends StatefulWidget {
  const TaskDetails({
    super.key,
    // TaskDetails
    // required this.taskId,
    required this.recipientId,
    required this.category,
    required this.description,
    required this.payment,
    required this.startdate,
    required this.enddate,
    required this.status,
    required this.paid,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    // employer
    required this.employerid,
    required this.employerimage,
    required this.employername,
    required this.employerhired,
    required this.employeravailability,
    required this.employercategory,
    required this.employerpayment,
    required this.employerrating,
    required this.employeronline,
    // employee
    required this.recipientimage,
    required this.recipientname,
    required this.recipienthired,
    required this.recipientavailability,
    required this.recipientcategory,
    required this.recipientpayment,
    required this.recipientrating,
    required this.recipientonline,
  });

// TaskDetails
  // final int taskId;
  final int recipientId;
  final String category;
  final String description;
  final String payment;
  final DateTime startdate;
  final DateTime enddate;
  final String status;
  final String paid;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int userId;
  // employer
  final int employerid;
  final String employername;
  final String employerimage;
  final String employerhired;
  final String employeravailability;
  final String employercategory;
  final String employerpayment;
  final String employerrating;
  final String employeronline;
  // recipient
  final String recipientname;
  final String recipientimage;
  final String recipienthired;
  final String recipientavailability;
  final String recipientcategory;
  final String recipientpayment;
  final String recipientrating;
  final String recipientonline;

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  User? user;
  Future<User> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = jsonDecode(prefs.getString('user').toString());
    var userObj = User.fromJson(map);
    setState(() {
      user = userObj;
    });
    return userObj;
  }

  @override
  void initState() {
    loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: loadUserData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return '${widget.userId}' == user!.id.toString()
                  ? Stack(
                      children: [
                        CustomScrollView(
                          slivers: [
                            SliverAppBar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              title: const Text('Job Description'),
                              expandedHeight: 200,
                              pinned: true,
                              flexibleSpace: FlexibleSpaceBar(
                                background: widget.recipientimage == ''
                                    ? Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.blue.shade100),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                widget.recipientimage),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.white
                                            : Colors.grey.shade800,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        // first part
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      widget.recipientname,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: const [
                                                        Icon(
                                                          Icons.work,
                                                          color: Colors.blue,
                                                          size: 16,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text('You hired')
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      DateFormat(
                                                              'EEEE MMM d yyyy')
                                                          .format(
                                                              widget.createdAt),
                                                      style: const TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          widget.status,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                        const SizedBox(
                                                            width: 3),
                                                        const Icon(
                                                          Icons.timer,
                                                          size: 17,
                                                          color: Colors.grey,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // third part
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.white
                                                  : Colors.grey.shade800,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Job Description',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  widget.description,
                                                  style: const TextStyle(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: widget.status == 'PENDING'
                                ? Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.status,
                                        style: TextStyle(
                                            color: Colors.blue.shade300),
                                      ),
                                    ),
                                  )
                                : widget.status == 'IN PROGRESS'
                                    ? Container(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.status,
                                            style: TextStyle(
                                                color: Colors.blue.shade300),
                                          ),
                                        ),
                                      )
                                    : widget.status == 'COMPLETED' &&
                                            widget.paid == 'true'
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) {
                                                  return AlertDialog(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 1,
                                                            vertical: 4),
                                                    title: const Text(
                                                        "Confirm Payment"),
                                                    content: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 20,
                                                      ),
                                                      child: Text(
                                                          'Please confirm that you want to pay KES ${widget.payment} to ${widget.recipientname}'),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      Container(
                                                        height: 40,
                                                        width: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .blue.shade100,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'Proceed',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              decoration: BoxDecoration(
                                                color: Colors.blue.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'PAY NOW',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                          ),
                        )
                      ],
                    )
                  : Stack(
                      children: [
                        CustomScrollView(
                          slivers: [
                            SliverAppBar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              title: const Text('Job Description'),
                              expandedHeight: 200,
                              pinned: true,
                              flexibleSpace: FlexibleSpaceBar(
                                background: widget.employerimage == ''
                                    ? Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.blue.shade100),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                widget.employerimage),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.white
                                            : Colors.grey.shade800,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        // first part
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      widget.employername,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: const [
                                                        Icon(
                                                          Icons.work,
                                                          color: Colors.blue,
                                                          size: 16,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text('You was hired')
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      DateFormat(
                                                              'EEEE MMM d yyyy')
                                                          .format(
                                                              widget.createdAt),
                                                      style: const TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          widget.status,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey),
                                                        ),
                                                        const SizedBox(
                                                            width: 3),
                                                        const Icon(
                                                          Icons.timer,
                                                          size: 17,
                                                          color: Colors.grey,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // third part
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.white
                                                  : Colors.grey.shade800,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Job Description',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  widget.description,
                                                  style: const TextStyle(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: widget.status == 'PENDING'
                                ? Container(
                                    height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade300,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'ACCEPT TASK',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                : widget.status == 'IN PROGRESS'
                                    ? Container(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade300,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'MARK AS FINISHED',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )
                                    : widget.status == 'COMPLETED' &&
                                            widget.paid == 'true'
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) {
                                                  return AlertDialog(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 1,
                                                            vertical: 4),
                                                    title: const Text(
                                                        "Confirm Payment"),
                                                    content: const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                      ),
                                                      // child: Text(
                                                      //     'Please confirm that you want to pay KES ${widget.payment} to ${widget.recipientname}'),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      Container(
                                                        height: 40,
                                                        width: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .blue.shade100,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'Proceed',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              decoration: BoxDecoration(
                                                color: Colors.blue.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'PAY NOW',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                          ),
                        )
                      ],
                    );
            }
          }),
    );
  }
}
