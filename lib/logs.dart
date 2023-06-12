import 'package:findme/data.dart';
import 'package:findme/logdetails.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class Logs extends StatefulWidget {
  const Logs({super.key});

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // centerTitle: true,
        title: const Text(
          'Logs',
          style: TextStyle(),
        ),
      ),
      body: GroupedListView<dynamic, String>(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        elements: logs,
        separator: const SizedBox(height: 5),
        order: GroupedListOrder.ASC,
        groupBy: (log) => log['day'],
        groupSeparatorBuilder: (value) => Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 20, bottom: 5, left: 20),
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        itemBuilder: (BuildContext context, log) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.grey[700],
                borderRadius: BorderRadius.circular(10),
              ),
              child: log['requester'] == 'me'
                  ? ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(log['requestee_image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        log['requestee_name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: const [
                          Icon(
                            Icons.work,
                            color: Colors.blue,
                            size: 16,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('You requested'),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log['time'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                          log['picked'] == true
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'Received',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Icon(
                                      Icons.call_received,
                                      size: 17,
                                      color: Colors.blue,
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'Missed',
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                    Icon(
                                      Icons.call_missed_outgoing,
                                      size: 17,
                                      color: Colors.red,
                                    )
                                  ],
                                )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LogDetails(
                              requester: log['requester'],
                              image: log['requestee_image'],
                              name: log['requestee_name'],
                              request: log['request'],
                              picked: log['picked'],
                              day: log['day'],
                              payment: '400',
                              time: log['time'],
                            ),
                          ),
                        );
                      },
                    )
                  : ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(log['requester_image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        log['requester_name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: const [
                          Icon(
                            Icons.work,
                            size: 16,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Requested you'),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log['time'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                          log['picked'] == true
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'Received',
                                      style: TextStyle(),
                                    ),
                                    Icon(
                                      Icons.call_received,
                                      size: 17,
                                      color: Colors.grey,
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'Missed',
                                      style: TextStyle(),
                                    ),
                                    Icon(
                                      Icons.call_missed,
                                      size: 17,
                                    )
                                  ],
                                )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LogDetails(
                              requester: log['requester'],
                              image: log['requester_image'],
                              name: log['requester_name'],
                              request: log['request'],
                              picked: log['picked'],
                              day: log['day'],
                              payment: '400',
                              time: log['time'],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
