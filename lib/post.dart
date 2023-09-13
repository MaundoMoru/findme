import 'dart:convert';
import 'dart:io';
import 'package:findme/httpServices/httpServices.dart';
import 'package:findme/menu.dart';
import 'package:findme/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  TextEditingController post = TextEditingController();
  TextEditingController heading = TextEditingController();
  TextEditingController companylink = TextEditingController();
  var isPosting = '';
  ImagePicker imagePicker = ImagePicker();
  late VideoPlayerController videoPlayerController;
  XFile? image;
  XFile? video;
  late Future<User> userData;
  HttpServices httpServices = HttpServices();

  Future<User> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = jsonDecode(prefs.getString('user').toString());
    return User.fromJson(map);
  }

  @override
  void initState() {
    userData = loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 235, 244, 249),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TabBar(
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Color.fromARGB(255, 213, 233, 247),
                  // indicator: BoxDecoration(),
                  tabs: [
                    Tab(
                      icon: Text(
                        "Post",
                        style: GoogleFonts.montserrat(
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Tab(
                      icon: Text(
                        "Advert",
                        style: GoogleFonts.montserrat(
                          textStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        body: FutureBuilder<User>(
          future: userData,
          builder: (
            BuildContext context,
            AsyncSnapshot snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                var user = snapshot.data;
                return TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Divider(),
                            const SizedBox(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  user!.image == ''
                                      ? Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                              child: Text(user!.name[0])),
                                        )
                                      : Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(user!.image),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                controller: post,
                                autofocus: true,
                                maxLines: null,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type here ...',
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    isPosting = text;
                                  });
                                },
                              ),
                            ),
                            Divider(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade100.withOpacity(0.05),
                              height: 1,
                            ),
                            image == null && video == null
                                ? Container()
                                : Stack(
                                    children: [
                                      video == null && image != null
                                          ? Container(
                                              height: 350,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    image: FileImage(
                                                      File(image!.path),
                                                    ),
                                                    fit: BoxFit.cover),
                                              ),
                                            )
                                          : videoPlayerController
                                                  .value.isInitialized
                                              ? Container(
                                                  height: 350,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: AspectRatio(
                                                    aspectRatio:
                                                        videoPlayerController
                                                            .value.aspectRatio,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: VideoPlayer(
                                                        videoPlayerController,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  height: 350,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                                ),
                                      Positioned(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                image = null;
                                                video = null;
                                              });
                                            },
                                            child: Container(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.grey.shade200
                                                  : Colors.grey[700],
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _pickImage();
                                      },
                                      icon: const Icon(
                                        Icons.image_outlined,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _pickVideo();
                                      },
                                      icon: const Icon(
                                        Icons.video_camera_back_outlined,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(
                                      Icons.attach_file,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                                httpServices.isLoading == true
                                    ? OutlinedButton(
                                        onPressed: () async {},
                                        style: OutlinedButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          backgroundColor: Colors.blue,
                                          side: const BorderSide(
                                            width: 1.0,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            SpinKitCircle(
                                              color: Colors.grey.shade300,
                                              size: 25.0,
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            const Text(
                                              'Wait...',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : OutlinedButton(
                                        onPressed: () async {
                                          setState(() {});
                                          await httpServices.createPost(
                                            user.id,
                                            heading.text,
                                            post.text,
                                            companylink.text,
                                            image,
                                            video,
                                          );
                                          setState(() {});
                                          // ignore: use_build_context_synchronously
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const Menu()));
                                        },
                                        style: OutlinedButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          backgroundColor: Colors.blue,
                                          side: const BorderSide(
                                            width: 1.0,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        child: const Text(
                                          'Submit',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                            Divider(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade100.withOpacity(0.05),
                              height: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Tab 2
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Divider(),
                            const SizedBox(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  user!.image == ''
                                      ? Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                              child: Text(user!.name[0])),
                                        )
                                      : Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(user!.image),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                controller: heading,
                                autofocus: true,
                                maxLines: null,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey.shade300),
                                  ),
                                  hintText: 'Heading ...',
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    isPosting = text;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                controller: post,
                                autofocus: true,
                                maxLines: null,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                minLines: 4,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey.shade300),
                                  ),
                                  hintText: 'Description ...',
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    isPosting = text;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                controller: companylink,
                                autofocus: true,
                                maxLines: null,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.grey.shade300),
                                  ),
                                  hintText: 'company link',
                                ),
                                onChanged: (text) {
                                  setState(
                                    () {
                                      isPosting = text;
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Divider(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade100.withOpacity(0.05),
                              height: 1,
                            ),
                            image == null && video == null
                                ? Container()
                                : Stack(
                                    children: [
                                      video == null && image != null
                                          ? Container(
                                              height: 350,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                    image: FileImage(
                                                      File(image!.path),
                                                    ),
                                                    fit: BoxFit.cover),
                                              ),
                                            )
                                          : videoPlayerController
                                                  .value.isInitialized
                                              ? Container(
                                                  height: 350,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: AspectRatio(
                                                    aspectRatio:
                                                        videoPlayerController
                                                            .value.aspectRatio,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: VideoPlayer(
                                                        videoPlayerController,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  height: 350,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                                ),
                                      Positioned(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                image = null;
                                                video = null;
                                              });
                                            },
                                            child: Container(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.grey.shade200
                                                  : Colors.grey[700],
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _pickImage();
                                      },
                                      icon: const Icon(
                                        Icons.image_outlined,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _pickVideo();
                                      },
                                      icon: const Icon(
                                        Icons.video_camera_back_outlined,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(
                                      Icons.attach_file,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                                httpServices.isLoading == true
                                    ? OutlinedButton(
                                        onPressed: () async {},
                                        style: OutlinedButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          backgroundColor: Colors.blue,
                                          side: const BorderSide(
                                            width: 1.0,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            SpinKitCircle(
                                              color: Colors.grey.shade300,
                                              size: 25.0,
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            const Text(
                                              'Wait...',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : OutlinedButton(
                                        onPressed: () async {
                                          setState(() {});
                                          await httpServices.createPost(
                                            user.id,
                                            heading.text,
                                            post.text,
                                            companylink.text,
                                            image,
                                            video,
                                          );
                                          setState(() {});
                                          // ignore: use_build_context_synchronously
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const Menu()));
                                        },
                                        style: OutlinedButton.styleFrom(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          backgroundColor: Colors.blue,
                                          side: const BorderSide(
                                            width: 1.0,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        child: const Text(
                                          'Submit',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                            Divider(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade100.withOpacity(0.05),
                              height: 1,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return const Center(
                  child: Text('No user found'),
                );
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    XFile? img = await imagePicker.pickImage(source: ImageSource.gallery);
    if (img == null) {
      return;
    } else {
      setState(() {
        image = img;
      });
    }
  }

  Future<void> _pickVideo() async {
    XFile? vid = await imagePicker.pickVideo(source: ImageSource.gallery);
    if (vid == null) {
      return;
    } else {
      setState(() {
        video = vid;
      });
      videoPlayerController = VideoPlayerController.file(File(video!.path))
        ..initialize().then((_) {
          setState(() {});
          videoPlayerController.play();
        });
    }
  }
}
