import 'package:findme/dial.dart';
import 'package:flutter/material.dart';

class LogDetails extends StatefulWidget {
  const LogDetails({
    super.key,
    required this.requester,
    required this.image,
    required this.name,
    required this.day,
    required this.request,
    required this.picked,
    required this.payment,
    required this.time,
  });
  final String requester;
  final String image;
  final String name;
  final String day;
  final String request;
  final bool picked;
  final String payment;
  final String time;

  @override
  State<LogDetails> createState() => _LogDetailsState();
}

class _LogDetailsState extends State<LogDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: const Text('Job Description'),
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.image),
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
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          // first part
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      const SizedBox(height: 5),
                                      widget.requester == 'me'
                                          ? Row(
                                              children: const [
                                                Icon(
                                                  Icons.work,
                                                  color: Colors.blue,
                                                  size: 16,
                                                ),
                                                SizedBox(width: 5),
                                                Text('You requested')
                                              ],
                                            )
                                          : Row(
                                              children: const [
                                                Icon(
                                                  Icons.work,
                                                  size: 16,
                                                ),
                                                SizedBox(width: 5),
                                                Text('Requested you')
                                              ],
                                            )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        widget.time,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      widget.requester == 'me'
                                          ? widget.picked == true
                                              ? Row(
                                                  children: const [
                                                    Text(
                                                      'Received',
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                    Icon(
                                                      Icons.call_received,
                                                      size: 17,
                                                      color: Colors.blue,
                                                    )
                                                  ],
                                                )
                                              : Row(
                                                  children: const [
                                                    Text(
                                                      'Missed',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .call_missed_outgoing,
                                                      size: 17,
                                                      color: Colors.red,
                                                    )
                                                  ],
                                                )
                                          //
                                          : widget.picked == true
                                              ? Row(
                                                  children: const [
                                                    Text(
                                                      'Received',
                                                      style: TextStyle(),
                                                    ),
                                                    Icon(
                                                      Icons.call_received,
                                                      size: 17,
                                                    )
                                                  ],
                                                )
                                              : Row(
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
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.white
                                    : Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    widget.request,
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
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Dial(
                        image: widget.image,
                        name: widget.name,
                        payment: widget.payment,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  // width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Request',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
