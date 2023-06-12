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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Posts',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // image == ''
          //     ? Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Container(
          //           height: 40,
          //           width: 40,
          //           decoration: BoxDecoration(
          //             border: Border.all(
          //                 width: 2,
          //                 color: Theme.of(context).scaffoldBackgroundColor),
          //             shape: BoxShape.circle,
          //             color: Colors.amber,
          //           ),
          //           child: Center(child: Text('name')),
          //         ),
          //       )
          //     : Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Container(
          //           height: 40,
          //           width: 40,
          //           decoration: BoxDecoration(
          //             border: Border.all(
          //                 width: 2,
          //                 color: Theme.of(context).scaffoldBackgroundColor),
          //             shape: BoxShape.circle,
          //             color: Colors.amber,
          //             image: DecorationImage(
          //               image: NetworkImage(image.toString()),
          //               fit: BoxFit.cover,
          //             ),
          //           ),
          //         ),
          //       )
        ],
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

              return Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                          image: NetworkImage(
                            post.file.toString(),
                          ),
                          fit: BoxFit.contain),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: ReadMoreText(
                        post.description.toString(),
                        trimLines: 4,
                        colorClickableText: Colors.grey.shade700,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        style: const TextStyle(color: Colors.white),
                        moreStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
