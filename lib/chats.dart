import 'package:findme/chat.dart';
import 'package:findme/data.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  String? selectedFeed = "";
  bool showFeeds = false;

  List selectedChat = [];
  bool isChatSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Chats',
          style: TextStyle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: messages.length,
                separatorBuilder: (BuildContext context, index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, index) {
                  return messages[index]['sender_id'] == '1'
                      ? ListTile(
                          leading: Stack(
                            children: [
                              messages[index]['receiver_image'] == ''
                                  ? Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          messages[index]['receiver_name'][0],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage(
                                            messages[index]['receiver_image'],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      messages[index]['receiver_name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(width: 8),
                                    messages[index]['online'] == true
                                        ? const Text('')
                                        : Expanded(
                                            child: Text(
                                              messages[index]['last_seen'],
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                              messages[index]['unread_messages'] == ''
                                  ? const Text('')
                                  : Container(
                                      height: 20,
                                      width: 20,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          messages[index]['unread_messages'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                              messages[index]['online'] == true
                                  ? Positioned(
                                      right: 0,
                                      child: Container(
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                            ),
                                            color: Colors.blue,
                                            shape: BoxShape.circle),
                                      ),
                                    )
                                  : const Text(''),
                              selectedChat.contains(messages[index]['id'])
                                  ? Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                            ),
                                            color: Colors.blue[200],
                                            shape: BoxShape.circle),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    )
                                  : const Text(''),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  messages[index]['message'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(messages[index]['time'])
                            ],
                          ),
                          onLongPress: () {
                            if (selectedChat.contains(messages[index]['id'])) {
                              setState(() {
                                selectedChat.remove(messages[index]['id']);
                              });
                            } else {
                              setState(() {
                                isChatSelected = true;
                                selectedChat.add(messages[index]['id']);
                              });
                            }
                          },
                          onTap: (() {
                            if (isChatSelected == true &&
                                selectedChat.isNotEmpty) {
                              if (selectedChat
                                  .contains(messages[index]['id'])) {
                                setState(() {
                                  selectedChat.remove(messages[index]['id']);
                                });
                              } else {
                                setState(() {
                                  isChatSelected = true;
                                  selectedChat.add(messages[index]['id']);
                                });
                              }
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Chat(
                                    id: messages[index]['receiver_id'],
                                    image: messages[index]['receiver_image'],
                                    name: messages[index]['receiver_name'],
                                    bio: messages[index]['receiver_bio'],
                                  ),
                                ),
                              );
                            }
                          }),
                        )
                      : ListTile(
                          leading: InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => Profile(
                              //       id: messages[index]['sender_id'],
                              //       image: messages[index]['sender_image'],
                              //       name: messages[index]['sender_name'],
                              //       bio: messages[index]['sender_bio'],
                              //     ),
                              //   ),
                              // );
                            },
                            child: Stack(
                              children: [
                                messages[index]['sender_image'] == ''
                                    ? Container(
                                        height: 50,
                                        width: 50,
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            messages[index]['sender_name'][0],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: AssetImage(
                                              messages[index]['sender_image'],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                messages[index]['online'] == true
                                    ? Positioned(
                                        right: 0,
                                        child: Container(
                                          height: 15,
                                          width: 15,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                              color: Colors.blue,
                                              shape: BoxShape.circle),
                                        ),
                                      )
                                    : const Text(''),
                                selectedChat.contains(messages[index]['id'])
                                    ? Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                              color: Colors.blue[200],
                                              shape: BoxShape.circle),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      )
                                    : const Text(''),
                              ],
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      messages[index]['sender_name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(width: 8),
                                    messages[index]['online'] == true
                                        ? const Text('')
                                        : Expanded(
                                            child: Text(
                                              messages[index]['last_seen'],
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                  ],
                                ),
                              ),
                              messages[index]['unread_messages'] == ''
                                  ? const Text('')
                                  : Container(
                                      height: 20,
                                      width: 20,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          messages[index]['unread_messages'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  messages[index]['message'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(messages[index]['time'])
                            ],
                          ),
                          onLongPress: () {
                            if (selectedChat.contains(messages[index]['id'])) {
                              setState(() {
                                selectedChat.remove(messages[index]['id']);
                              });
                            } else {
                              setState(() {
                                isChatSelected = true;
                                selectedChat.add(messages[index]['id']);
                              });
                            }
                          },
                          onTap: (() {
                            if (isChatSelected == true &&
                                selectedChat.isNotEmpty) {
                              if (selectedChat
                                  .contains(messages[index]['id'])) {
                                setState(() {
                                  selectedChat.remove(messages[index]['id']);
                                });
                              } else {
                                setState(() {
                                  isChatSelected = true;
                                  selectedChat.add(messages[index]['id']);
                                });
                              }
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Chat(
                                    id: messages[index]['sender_id'],
                                    image: messages[index]['sender_image'],
                                    name: messages[index]['sender_name'],
                                    bio: messages[index]['sender_bio'],
                                  ),
                                ),
                              );
                            }
                          }),
                        );
                },
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
