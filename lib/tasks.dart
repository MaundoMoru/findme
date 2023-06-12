import 'dart:convert';

import 'package:findme/data.dart';
import 'package:findme/httpServices/httpServices.dart';
import 'package:findme/models/task.dart';
import 'package:findme/models/user.dart';
import 'package:findme/task.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  HttpServices httpServices = HttpServices();
  List<Task>? myTasks = [];
  List<Task>? otherTasks = [];
  User? user;

  void _getData() async {
    var data = (await httpServices.fetchTasks());
    for (int i = 0; i < data.length; i++) {
      if (data[i].userId.toString() == user!.id.toString() &&
          data[i].recipientId.toString() != user!.id.toString()) {
        myTasks!.add(data[i]);
        // print(data[i].user.category);
        setState(() {});
      } else if (data[i].recipientId.toString() == user!.id.toString()) {
        otherTasks!.add(data[i]);
        print(data[i].description);
        setState(() {});
      }
    }
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = jsonDecode(prefs.getString('user').toString());
    setState(() {
      user = User.fromJson(map);
    });
    print(map['id']);
  }

  @override
  void initState() {
    loadUserData();
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Text(
              'Tasks',
              style: TextStyle(),
            ),
            bottom: TabBar(
              tabs: [
                Column(
                  children: const [
                    Tab(
                      text: 'GIVEN',
                    ),
                  ],
                ),
                Column(
                  children: const [
                    Tab(
                      text: 'RECEIVED',
                    ),
                  ],
                ),
              ],
            )),
        body: TabBarView(
          children: [
            // my tasks
            myTasks!.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.work,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey.shade400
                                  : Colors.grey[700],
                          size: 90,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'No task found',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey.shade400
                                    : Colors.grey[700],
                          ),
                        )
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: buildTasksGiven(),
                  ),

            // other tasks
            otherTasks!.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.work,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey.shade400
                                  : Colors.grey[700],
                          size: 90,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'No task found',
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey.shade400
                                    : Colors.grey[700],
                          ),
                        )
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: buildReceivedTasks(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildTasksGiven() => FutureBuilder<List<Task>>(
        future: httpServices.fetchTasks(),
        builder: (
          BuildContext context,
          AsyncSnapshot snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return GroupedListView<dynamic, String>(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                elements: myTasks!,
                separator: const SizedBox(height: 5),
                order: GroupedListOrder.ASC,
                groupBy: (myTask) => myTask.status,
                groupSeparatorBuilder: (value) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 20, bottom: 5, left: 20),
                  child: Text(
                    value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                itemBuilder: (BuildContext context, myTask) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.grey[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              myTask.recipient.user.image == ''
                                  ? Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          myTask.recipient.user.name[0],
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              myTask.recipient.user.image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              myTask.recipient.user.online == true
                                  ? Positioned(
                                      right: -5,
                                      child: Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const Text('')
                            ],
                          ),
                          title: Text(
                            myTask.recipient.user.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.work,
                                    size: 17,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      myTask.category,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'TASK ${myTask.status}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Due on ${DateFormat('MMM d').format(myTask.enddate)}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const Divider(),
                              myTask.status == 'PENDING'
                                  ? Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'PENDING',
                                          style: TextStyle(
                                            color: Colors.blue.shade300,
                                          ),
                                        ),
                                      ),
                                    )
                                  : myTask.status == 'IN PROGRESS'
                                      ? Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'IN PROGRESS',
                                              style: TextStyle(
                                                color: Colors.blue.shade300,
                                              ),
                                            ),
                                          ),
                                        )
                                      : myTask.status == 'COMPLETED' &&
                                              myTask.paid == 'true'
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
                                                        vertical: 4,
                                                      ),
                                                      title: const Text(
                                                          "Confirm Payment"),
                                                      content: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20),
                                                        child: Text(
                                                            'Please confirm that you want to pay KES ${myTask.payment} to ${myTask.recipient.user.name}'),
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
                                                                    .circular(
                                                                        20),
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
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'PAY NOW',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.blue.shade300,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                            ],
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                myTask == null
                                    ? ''
                                    : DateFormat('MMM d, yyyy')
                                        .format(myTask.createdAt),
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 20,
                                width: 90,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                    child: Text('KES ${myTask.payment}')),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetails(
                                  // task
                                  // taskId: myTask.id,
                                  recipientId: myTask.recipientId,
                                  category: myTask.category,
                                  description: myTask.description,
                                  payment: myTask.payment,
                                  startdate: myTask.startdate,
                                  enddate: myTask.enddate,
                                  status: myTask.status,
                                  paid: myTask.paid,
                                  createdAt: myTask.createdAt,
                                  updatedAt: myTask.updatedAt,
                                  userId: myTask.userId,
                                  // employer
                                  employerid: myTask.user.id,
                                  employerimage: myTask.user.image,
                                  employername: myTask.user.name,
                                  employerhired: myTask.user.hired,
                                  employeravailability:
                                      myTask.user.availability,
                                  employercategory: myTask.user.category,
                                  employerpayment: myTask.user.payment,
                                  employerrating: myTask.user.rating,
                                  employeronline: myTask.user.online,
                                  // recipient
                                  recipientimage: myTask.recipient.user.image,
                                  recipientname: myTask.recipient.user.name,
                                  recipienthired: myTask.recipient.user.hired,
                                  recipientavailability:
                                      myTask.recipient.user.availability,
                                  recipientcategory:
                                      myTask.recipient.user.category,
                                  recipientpayment:
                                      myTask.recipient.user.payment,
                                  recipientrating: myTask.recipient.user.rating,
                                  recipientonline: myTask.recipient.user.online,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No user found'));
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      );

  Widget buildReceivedTasks() => FutureBuilder<List<Task>>(
        future: httpServices.fetchTasks(),
        builder: (
          BuildContext context,
          AsyncSnapshot snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return GroupedListView<dynamic, String>(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                elements: otherTasks!,
                separator: const SizedBox(height: 5),
                order: GroupedListOrder.ASC,
                groupBy: (otherTask) => otherTask.status,
                groupSeparatorBuilder: (value) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 20, bottom: 5, left: 20),
                  child: Text(
                    value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                itemBuilder: (BuildContext context, otherTask) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.grey[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              otherTask.user.image == ''
                                  ? Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          otherTask.user.name[0],
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              otherTask.user.image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              otherTask.user.online == true
                                  ? Positioned(
                                      right: -5,
                                      child: Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const Text('')
                            ],
                          ),
                          title: Text(
                            otherTask.user.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.work,
                                    size: 17,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      otherTask.category,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'TASK ${otherTask.status}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Due on ${DateFormat('MMM d').format(otherTask.enddate)}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const Divider(),
                              otherTask.status == 'PENDING'
                                  ? Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'PENDING',
                                          style: TextStyle(
                                            color: Colors.blue.shade300,
                                          ),
                                        ),
                                      ),
                                    )
                                  : otherTask.status == 'IN PROGRESS'
                                      ? Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'IN PROGRESS',
                                              style: TextStyle(
                                                color: Colors.blue.shade300,
                                              ),
                                            ),
                                          ),
                                        )
                                      : otherTask.status == 'COMPLETED' &&
                                              otherTask.paid == 'true'
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
                                                        vertical: 4,
                                                      ),
                                                      title: const Text(
                                                          "Confirm Payment"),
                                                      content: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20),
                                                        child: Text(
                                                            'Please confirm that you want to mark KES ${otherTask.payment} was paid to you by ${otherTask.user.name}'),
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
                                                                    .circular(
                                                                        20),
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
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'PAY NOW',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.blue.shade300,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                            ],
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                otherTask == null
                                    ? ''
                                    : DateFormat('MMM d, yyyy')
                                        .format(otherTask.createdAt),
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 20,
                                width: 90,
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                    child: Text('KES ${otherTask.payment}')),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetails(
                                  // task
                                  // taskId: myTask.id,
                                  recipientId: otherTask.recipientId,
                                  category: otherTask.category,
                                  description: otherTask.description,
                                  payment: otherTask.payment,
                                  startdate: otherTask.startdate,
                                  enddate: otherTask.enddate,
                                  status: otherTask.status,
                                  paid: otherTask.paid,
                                  createdAt: otherTask.createdAt,
                                  updatedAt: otherTask.updatedAt,
                                  userId: otherTask.userId,
                                  // employer
                                  employerid: otherTask.user.id,
                                  employerimage: otherTask.user.image,
                                  employername: otherTask.user.name,
                                  employerhired: otherTask.user.hired,
                                  employeravailability:
                                      otherTask.user.availability,
                                  employercategory: otherTask.user.category,
                                  employerpayment: otherTask.user.payment,
                                  employerrating: otherTask.user.rating,
                                  employeronline: otherTask.user.online,
                                  // recipient
                                  recipientimage:
                                      otherTask.recipient.user.image,
                                  recipientname: otherTask.recipient.user.name,
                                  recipienthired:
                                      otherTask.recipient.user.hired,
                                  recipientavailability:
                                      otherTask.recipient.user.availability,
                                  recipientcategory:
                                      otherTask.recipient.user.category,
                                  recipientpayment:
                                      otherTask.recipient.user.payment,
                                  recipientrating:
                                      otherTask.recipient.user.rating,
                                  recipientonline:
                                      otherTask.recipient.user.online,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No user found'));
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      );
}
