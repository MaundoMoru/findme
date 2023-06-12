import 'dart:convert';
import 'package:findme/dial.dart';
import 'package:findme/hire.dart';
import 'package:findme/httpServices/httpServices.dart';
import 'package:findme/imageview.dart';
import 'package:findme/models/user.dart';
import 'package:findme/ratings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({
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
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  HttpServices httpServices = HttpServices();
  List<User>? users = [];
  User? user;

  void _getData() async {
    var data = (await httpServices.fetchUsers());
    for (int i = 0; i < data.length; i++) {
      if (data[i].category == widget.category &&
          data[i].id != widget.id &&
          data[i].id != user!.id) {
        users!.add(data[i]);
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
    print(map['category']);
  }

  @override
  void initState() {
    loadUserData();
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(),
        ),
      ),
      body: ListView(
        children: [
          buildUserProfile(),
          buildRelatedUsers(),
        ],
      ),
    );
  }

  Widget buildUserProfile() => Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Stack(
              children: [
                widget.image == ''
                    ? Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${widget.name}'[0],
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageView(
                                image: widget.image.toString(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage('${widget.image}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              '${widget.name}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Ratings(name: '${widget.name}'),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RatingBar.builder(
                  initialRating: 1,
                  ignoreGestures: true,
                  direction: Axis.horizontal,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.blue,
                  ),
                  updateOnDrag: true,
                  itemSize: 17,
                  onRatingUpdate: (rating) {},
                  allowHalfRating: true,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text('(${widget.rating.toString()})')
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: ReadMoreText(
              '${widget.bio}',
              trimLines: 2,
              colorClickableText: Colors.grey.shade700,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Show more',
              trimExpandedText: 'Show less',
              style: const TextStyle(color: Colors.grey),
              moreStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Hire(
                        id: widget.id,
                        image: widget.image,
                        name: widget.name,
                        bio: widget.bio,
                        category: widget.category,
                        payment: widget.payment,
                        rating: widget.rating,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Hire',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text('Hire ${widget.name}'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Divider(),
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.grey.shade200
                                    : Colors.grey[700],
                                border: Border.all(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade700,
                                ),
                              ),
                              child: TextFormField(
                                maxLines: 6,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  border: InputBorder.none,
                                  hintText: 'Add description (optional)',
                                ),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel')),
                          InkWell(
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
                          )
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Call',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Divider(),
          ),
        ],
      );

  Widget buildRelatedUsers() => FutureBuilder<List<User>>(
        future: httpServices.fetchUsers(),
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
              return Column(
                children: [
                  // friends
                  Center(
                    child: Text(
                      users!.length == 1
                          ? '(${users!.length}) other related'
                          : '(${users!.length}) others related',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 200,
                    child: PageView.builder(
                      controller: PageController(
                        initialPage: 1,
                        viewportFraction: 0.8,
                      ),
                      itemCount: users!.length,
                      itemBuilder: (BuildContext context, index) {
                        var user = users![index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.white
                                    : Colors.grey[700],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    user.image == ''
                                        ? Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade200,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  offset:
                                                      const Offset(5.0, 5.0),
                                                  blurRadius: 1,
                                                  spreadRadius: 1,
                                                  color: Colors.grey.shade400
                                                      .withOpacity(0.4),
                                                )
                                              ],
                                            ),
                                            child: Center(
                                                child: Text(user.name[0])),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImageView(
                                                    image:
                                                        user.image.toString(),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 45,
                                              width: 45,
                                              decoration: BoxDecoration(
                                                color: Colors.blue.shade200,
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image:
                                                      NetworkImage(user.image),
                                                  fit: BoxFit.cover,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    offset:
                                                        const Offset(5.0, 5.0),
                                                    blurRadius: 1,
                                                    spreadRadius: 1,
                                                    color: Colors.grey.shade400
                                                        .withOpacity(0.4),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                    Container(
                                      height: 30,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: user.hired == 'true'
                                            ? const Text(
                                                'Hired',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(
                                                  //     builder: (context) =>
                                                  //         Profile(
                                                  //       id: userId,
                                                  //       image: user.image,
                                                  //       name: user.name,
                                                  //       category: user.category,
                                                  //       payment: user.payment,
                                                  //       rating: user.rating,
                                                  //     ),
                                                  //   ),
                                                  // );
                                                },
                                                child: const Text(
                                                  'Hire',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  user.bio,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                users!.length < 3
                                    ? Text(user.name)
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 75,
                                            height: 28,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 0,
                                                  child: users!
                                                              .elementAt(0)
                                                              .image ==
                                                          ''
                                                      ? Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Theme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor),
                                                            color: Colors
                                                                .blue[200],
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Center(
                                                            child: Text(users!
                                                                .elementAt(0)
                                                                .name[0]),
                                                          ),
                                                        )
                                                      : Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Theme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor),
                                                            color: Colors
                                                                .blue[200],
                                                            shape:
                                                                BoxShape.circle,
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    users!
                                                                        .elementAt(
                                                                            0)
                                                                        .image),
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                          child: const Center(),
                                                        ),
                                                ),
                                                Positioned(
                                                  left: 15,
                                                  child: users!
                                                              .elementAt(1)
                                                              .image ==
                                                          ''
                                                      ? Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Theme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor),
                                                            color: Colors
                                                                .blue[200],
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Center(
                                                            child: Text(users!
                                                                .elementAt(1)
                                                                .name[0]),
                                                          ),
                                                        )
                                                      : Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Theme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor),
                                                            color: Colors
                                                                .blue[200],
                                                            shape:
                                                                BoxShape.circle,
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    users!
                                                                        .elementAt(
                                                                            1)
                                                                        .image),
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                          child: const Center(),
                                                        ),
                                                ),
                                                Positioned(
                                                  left: 30,
                                                  child: users!
                                                              .elementAt(2)
                                                              .image ==
                                                          ''
                                                      ? Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Theme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor),
                                                            color: Colors
                                                                .blue[200],
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Center(
                                                            child: Text(users!
                                                                .elementAt(2)
                                                                .name[0]),
                                                          ),
                                                        )
                                                      : Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Theme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor),
                                                            color: Colors
                                                                .blue[200],
                                                            shape:
                                                                BoxShape.circle,
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    users!
                                                                        .elementAt(
                                                                            2)
                                                                        .image),
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                          child: const Center(),
                                                        ),
                                                ),
                                                users!.length == 3
                                                    ? const Text('')
                                                    : Positioned(
                                                        left: 45,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          child: Container(
                                                            height: 25,
                                                            width: 25,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  width: 1,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .scaffoldBackgroundColor),
                                                              color: Colors
                                                                  .blue[200],
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                '+${users!.length - 3}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              '${user.name} related',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
