import 'dart:convert';

import 'package:findme/httpServices/httpServices.dart';
import 'package:findme/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/post.dart';

class Updates extends StatefulWidget {
  const Updates({super.key});

  @override
  State<Updates> createState() => _UpdatesState();
}

class _UpdatesState extends State<Updates> {
  HttpServices httpServices = HttpServices();

  List<Post>? posts = [];
  User? user;

  void _fetchPosts() async {
    posts = await httpServices.fetchPosts();
  }

  void loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = jsonDecode(prefs.getString('user').toString());
    setState(() {
      user = User.fromJson(map);
    });
    print(map);
  }

  @override
  void initState() {
    _fetchPosts();
    loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: const Text(
          'Posts',
          style: TextStyle(),
        ),
      ),
      body: FutureBuilder(
        future: httpServices.fetchPosts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SpinKitCircle(
                color: Colors.grey.shade300,
                size: 50.0,
              ),
            );
          }
          return PageView.builder(
            itemCount: posts!.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var post = posts![index];

              return Container(
                  decoration: BoxDecoration(
                    // color: Colors.black,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Colors.grey[700],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 60,
                            // width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.white
                                  : Colors.grey[800],
                              // borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                post.user!.image == ''
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor),
                                            shape: BoxShape.circle,
                                            color: Colors.blue.shade100,
                                          ),
                                          child: Center(
                                              child: Text(post.user!.name[0])),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor),
                                            shape: BoxShape.circle,
                                            color: Colors.amber,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  post.user!.image.toString()),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      post.user!.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      post.user!.bio,
                                      style: TextStyle(color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                  image: NetworkImage(
                                    post.file.toString(),
                                  ),
                                  fit: BoxFit.contain),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: ReadMoreText(
                            post.description.toString(),
                            trimLines: 4,
                            colorClickableText:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Show less',
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            moreStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ));
            },
          );
        },
      ),
    );
  }
}
