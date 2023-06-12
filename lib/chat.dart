import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class Chat extends StatefulWidget {
  const Chat({
    Key? key,
    required this.id,
    required this.image,
    required this.name,
    required this.bio,
  }) : super(key: key);

  final String id;
  final String image;
  final String name;
  final String bio;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _message = TextEditingController();

  bool showImageBtn = true;
  bool showMicBtn = true;
  bool showVideoBtn = true;
  bool showSendBtn = false;

  final ImagePicker _imagePicker = ImagePicker();
  XFile? image;
  XFile? video;
  late VideoPlayerController vpc;

  @override
  void initState() {
    super.initState();
    // vpc = VideoPlayerController.asset('images/video.mp4')
    //   ..initialize().then((_) {
    //     setState(() {});
    //   });
  }

  bool showImageBox = false;

  List messages = [
    {
      'id': 1,
      'sender': '3',
      'receiver': '1',
      'last_seen': '2 min ago',
      'sender_name': 'Antonio Baderas',
      'receiver_name': 'Josef',
      'sender_image': 'images/user 3.jfif',
      'receiver_image': 'images/user 1.jfif',
      'bio': 'Front end dev',
      'message': 'Hello friend, how far have you reached with flutter',
      'is_read': true,
      'time': '5:14 pm',
      'online': false,
    },
    {
      'id': 2,
      'sender': '4',
      'receiver': '1',
      'last_seen': '8 min ago',
      'sender_name': 'Roy Fielding',
      'receiver_name': 'Josef',
      'sender_image': '',
      'receiver_image': 'images/user 4.jfif',
      'bio': 'Front end dev',
      'message': 'Hello friend, how far have you reached with flutter',
      'is_read': true,
      'time': '3:14 pm',
      'online': false,
    },
    {
      'id': 3,
      'sender': '8',
      'receiver': '1',
      'last_seen': '10 hrs ago',
      'sender_name': 'Elsama Yego',
      'receiver_name': 'Josef',
      'sender_image': 'images/user 8.jfif',
      'receiver_image': 'images/user 1.jfif',
      'bio': 'Front end dev',
      'message':
          'Hello friend, how far have you reached with flutter. Hello friend, how far have you reached with flutter. Hello friend, how far have you reached with flutter',
      'is_read': true,
      'time': 'Yesterday',
      'online': true,
    },
    {
      'id': 4,
      'sender': '9',
      'receiver': '1',
      'last_seen': 'Last week',
      'sender_name': 'Caleb Kiplagat',
      'receiver_name': 'Josef',
      'sender_image': 'images/user 9.jfif',
      'receiver_image': 'images/user 1.jfif',
      'bio': 'Front end dev',
      'message': 'Hello friend, how far have you reached with flutter',
      'is_read': true,
      'time': '4:00 pm',
      'online': true,
    },
    {
      'id': 5,
      'sender': '10',
      'receiver': '1',
      'last_seen': '2 min ago',
      'sender_name': 'Brad Travesy',
      'receiver_name': 'Josef',
      'sender_image': 'images/user 10.jfif',
      'receiver_image': 'images/user 1.jfif',
      'bio': 'Front end dev',
      'message': 'Hello friend',
      'is_read': true,
      'time': '4:00 pm',
      'online': false,
    },
    {
      'id': 6,
      'sender': '7',
      'receiver': '1',
      'last_seen': '30 Sec ago',
      'sender_name': 'Eric Allan',
      'receiver_name': 'Josef',
      'sender_image': '',
      'receiver_image': 'images/user 1.jfif',
      'bio': 'Front end dev',
      'message': 'Hello friend, how far have you reached with flutter',
      'unread_messages': '1',
      'time': '4:00 pm',
      'online': true,
    },
    {
      'id': 7,
      'sender': '1',
      'receiver': '10',
      'last_seen': '30 Sec ago',
      'sender_name': 'Josef',
      'receiver_name': 'Brad',
      'sender_image': 'images/user 1.jfif',
      'receiver_image': 'images/user 10.jfif',
      'bio': 'Front end dev',
      'message': 'Hello friend, how far have you reached with flutter',
      'is_read': true,
      'time': '2: 29 pm',
      'online': true,
    },
    {
      'id': 8,
      'sender': '1',
      'receiver': '10',
      'last_seen': '30 Sec ago',
      'sender_name': 'Josef',
      'receiver_name': 'Brad',
      'sender_image': 'images/user 1.jfif',
      'receiver_image': 'images/user 10.jfif',
      'bio': 'Front end dev',
      'message': 'Hello friend, how far have you reached with flutter',
      'is_read': false,
      'time': '2: 29 pm',
      'online': true,
    },
    {
      'id': 9,
      'sender': '1',
      'receiver': '10',
      'last_seen': '30 Sec ago',
      'sender_name': 'Josef',
      'receiver_name': 'Brad',
      'sender_image': 'images/user 1.jfif',
      'receiver_image': 'images/user 10.jfif',
      'bio': 'Front end dev',
      'message':
          'Hello friend, how far have you reached with flutter. Hello friend, how far have you reached with flutter. Hello friend, how far have you reached with flutter',
      'is_read': true,
      'time': '2: 29 pm',
      'online': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => Profile(
            //       image: widget.image,
            //       name: widget.name,
            //       bio: widget.bio,
            //       id: widget.id,
            //     ),
            //   ),
            // );
          },
          child: Row(
            children: [
              widget.image == ""
                  ? Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade300,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 3,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          widget.name[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade300,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 3,
                            blurRadius: 6,
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage(widget.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              const SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name),
                  const Text(
                    'Active 3 m ago',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        actions: const [
          Icon(
            Icons.more_vert_outlined,
          )
        ],
      ),
      body: Stack(
        children: [
          buildChats(),
          const SizedBox(height: 200),
          buildChatBox(),
        ],
      ),
    );
  }

  Widget buildChats() => Stack(
        children: [
          GroupedListView<dynamic, String>(
            padding: const EdgeInsets.all(8.0),
            // reverse: true,
            // useStickyGroupSeparators: true,
            elements: messages,
            groupBy: (element) => element['time'].toString(),
            groupSeparatorBuilder: (String groupByValue) => SizedBox(
              height: 40,
              child: Center(
                child: Card(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade300
                      : Colors.grey.shade300.withOpacity(0.05),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(groupByValue),
                  ),
                ),
              ),
            ),
            itemBuilder: (context, dynamic element) => element['sender'] == '1'
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.blueAccent,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 20,
                              top: 10,
                              bottom: 20,
                            ),
                            child: Text(
                              element['message'],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 10,
                            child: Row(
                              children: [
                                Text(
                                  element['time'].toString(),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                element['sender'] == '1'
                                    ? element['is_read'] == true
                                        ? const Icon(
                                            Icons.done_all,
                                            size: 20,
                                          )
                                        : const Icon(
                                            Icons.done,
                                            size: 20,
                                          )
                                    : const Text('')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      // color: Colors.blueAccent,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 20,
                              top: 10,
                              bottom: 20,
                            ),
                            child: Text(
                              element['message'],
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 10,
                            child: Row(
                              children: [
                                Text(
                                  element['time'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                element['sender'] == '1'
                                    ? element['is_read'] == true
                                        ? const Icon(
                                            Icons.done_all,
                                            size: 20,
                                            // color: Colors.blue,
                                          )
                                        : const Icon(
                                            Icons.done,
                                            size: 20,
                                          )
                                    : const Text('')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          (image == null && video == null)
              ? const Text('')
              : Positioned(
                  bottom: 70,
                  left: 20,
                  right: 20,
                  child: Stack(
                    children: [
                      image == null
                          ? Container(
                              height: 350,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                // color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: AspectRatio(
                                aspectRatio: vpc.value.aspectRatio,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: VideoPlayer(vpc),
                                ),
                              ),
                            )
                          : Container(
                              height: 350,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                // color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: FileImage(
                                      File(image!.path),
                                    ),
                                    fit: BoxFit.cover),
                              ),
                            ),
                      Positioned(
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              image = null;
                              video = null;
                            });
                          },
                          icon: const Icon(Icons.close),
                        ),
                      )
                    ],
                  ))
        ],
      );

  Widget buildChatBox() => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey.shade200
                : Colors.grey.shade800,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.sentiment_satisfied_alt_outlined),
              ),
              Expanded(
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Send message',
                  ),
                  controller: _message,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        showImageBtn = false;
                        showVideoBtn = false;
                        showMicBtn = false;
                        showSendBtn = true;
                      });
                    } else {
                      setState(() {
                        showImageBtn = true;
                        showVideoBtn = true;
                        showMicBtn = true;
                        showSendBtn = false;
                      });
                    }
                  },
                ),
              ),
              Row(
                children: [
                  Visibility(
                    visible: showImageBtn,
                    child: IconButton(
                      icon: const Icon(Icons.image_outlined),
                      onPressed: () {
                        selectImage();
                      },
                    ),
                  ),
                  Visibility(
                    visible: showVideoBtn,
                    child: IconButton(
                      icon: const Icon(Icons.video_call_outlined),
                      onPressed: () {
                        selectVideo();
                      },
                    ),
                  ),
                  Visibility(
                    visible: showMicBtn,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.mic),
                    ),
                  ),
                  Visibility(
                    visible: showSendBtn,
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {},
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );

  void selectImage() async {
    XFile? img = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (img == null) return;
    setState(() {
      image = img;
      showImageBox = !showImageBox;
    });
  }

  Future<void> selectVideo() async {
    XFile? vid = await _imagePicker.pickVideo(source: ImageSource.gallery);
    if (vid == null) {
      return;
    } else {
      setState(() {
        video = vid;
      });
      vpc = VideoPlayerController.file(File(video!.path))
        ..initialize().then((_) {
          setState(() {});
          vpc.play();
        });
    }
  }

  // void sendMessage() {
  //   messages.add({
  //     'id': 1,
  //     'sender': '1',
  //     'receiver': '2',
  //     'last_seen': '2 min ago',
  //     'sender_name': 'Antonio Baderas',
  //     'receiver_name': 'Josef',
  //     'sender_image': 'images/user 3.jfif',
  //     'receiver_image': 'images/user 1.jfif',
  //     'bio': 'Front end dev',
  //     'message': _message.text,
  //     'is_read': true,
  //     'time': DateTime(),
  //     'online': false,
  //   });
  // }
}
