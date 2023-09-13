import 'dart:convert';
import 'package:findme/data.dart';
import 'package:findme/drawer.dart';
import 'package:findme/httpServices/httpServices.dart';
import 'package:findme/imageview.dart';
import 'package:findme/models/user.dart';
import 'package:findme/post.dart';
import 'package:findme/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:readmore/readmore.dart';
import 'models/post.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String advert = "advert";
  TextEditingController search = TextEditingController();
  final PanelController panelController = PanelController();
  String sortTByCategory = '';
  String? userImage = '';
  bool isSeaching = false;
  HttpServices httpServices = HttpServices();
  List<User>? users = [];
  List<User>? sortedusers = [];
  User? user;
  List<Post>? posts = [];

  late Future<List<User>?> loadUsers;
  late Future<List<Post>?> loadPosts;

  Future<List<User>> _fetchUsers() async {
    var data = (await httpServices.fetchUsers());
    for (int i = 0; i < data.length; i++) {
      if (data[i].id.toString() != 'user!.id.toString()') {
        users!.add(data[i]);
      }
    }
    return data;
  }

  Future<List<Post>?> _fetchPosts() async {
    posts = await httpServices.fetchPosts();
    return posts;
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> map = jsonDecode(prefs.getString('user').toString());
    setState(() {
      user = User.fromJson(map);
    });
    print(map);
  }

  @override
  void initState() {
    _loadUserData();
    loadUsers = _fetchUsers();
    loadPosts = _fetchPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      body: FutureBuilder(
        future: Future.wait([loadUsers, loadPosts]),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitCircle(
                color: Colors.grey.shade300,
                size: 50.0,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  floating: true,
                  pinned: true,
                  snap: false,
                  centerTitle: false,
                  title: Text(
                    'Find me',
                    style: GoogleFonts.montserrat(
                        textStyle:
                            const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.post_add),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PostPage()));
                      },
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(70.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey.shade200
                                  : Colors.grey[700],
                        ),
                        child: Center(
                          child: FocusScope(
                            child: Focus(
                              onFocusChange: (focus) {
                                setState(
                                  () {
                                    isSeaching = focus;
                                  },
                                );
                              },
                              child: TextFormField(
                                controller: search,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search member',
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: Visibility(
                                    visible: isSeaching,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(
                                          () {
                                            isSeaching = !isSeaching;
                                            search.text = '';
                                            FocusScope.of(context).unfocus();
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.cancel),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Other Sliver Widgets
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SingleChildScrollView(
                        physics: const ScrollPhysics(),
                        child: isSeaching == true
                            ? Column(
                                children: [
                                  buildCategories(),
                                ],
                              )
                            : Column(
                                children: [
                                  buildUpdates(),
                                  search.text == ''
                                      ? buildUsers()
                                      : buildUsersResult(),
                                ],
                              ),
                      )
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Text('No data available');
          }
        },
      ),
    );
  }

  Widget buildUpdates() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top updates
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top updates',
                  style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => buildSheet(),
                      backgroundColor: Colors.transparent,
                    );
                  },
                  child: Text(
                    'View all',
                    style: GoogleFonts.montserrat(textStyle: TextStyle()),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: FutureBuilder(
              future: httpServices.fetchPosts(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error');
                } else if (!snapshot.hasData) {
                  const Text("No Posts");
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: posts!.length,
                  itemBuilder: (BuildContext context, index) {
                    var post = posts![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.white
                                  : Colors.grey[700],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  post.file == '' || post.file == null
                                      ? Container(
                                          height: 120.0,
                                          width: 180.0,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                  'images/default.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: 120,
                                          width: 180,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  post.file.toString()),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                  Positioned(
                                    bottom: -20,
                                    right: 5,
                                    child: post.user!.image == ''
                                        ? Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade100,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                post.user!.name[0],
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade100,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    post.user!.image),
                                                fit: BoxFit.cover,
                                              ),
                                              border: Border.all(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                            ),
                                          ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                post.user!.name,
                                style: GoogleFonts.montserrat(
                                  textStyle: const TextStyle(),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.lock,
                                    size: 13,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Subscribe',
                                    style: GoogleFonts.montserrat(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );

  Widget buildUsers() => FutureBuilder<List<User>>(
        future: httpServices.fetchUsers(),
        builder: (
          BuildContext context,
          AsyncSnapshot snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitCircle(
              color: Colors.grey.shade300,
              size: 50.0,
            );
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return GroupedListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                elements: users!,
                separator: const SizedBox(height: 10),
                order: GroupedListOrder.ASC,
                groupBy: (user) => user.category,
                groupSeparatorBuilder: (value) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 20, bottom: 5, left: 20),
                  child: Text(
                    value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                itemBuilder: (BuildContext context, user) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.grey[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  userImage = user.image;
                                });
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 1, vertical: 4),
                                      title: Text(user.name),
                                      content: userImage == ''
                                          ? const Text('')
                                          : Container(
                                              height: 250,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image:
                                                      AssetImage('$userImage'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: user.image == ''
                                  ? Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(child: Text(user.name[0])),
                                    )
                                  : Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(user.image),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                            ),
                            user.online == 'true'
                                ? Positioned(
                                    right: -5,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade400,
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
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                user.name,
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle()),
                              ),
                            ),
                            // const SizedBox(
                            //   width: 3,
                            // ),
                            RatingBar.builder(
                              initialRating: 1.0,
                              minRating: 1,
                              ignoreGestures: false,
                              direction: Axis.horizontal,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.blue,
                              ),
                              updateOnDrag: true,
                              itemSize: 18,
                              onRatingUpdate: (rating) {},
                              allowHalfRating: true,
                            ),
                          ],
                        ),
                        trailing: user.hired == 'true'
                            ? Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.grey.shade200
                                        : Colors.black12,
                                    shape: BoxShape.circle),
                                child: const Icon(
                                  Icons.lock,
                                  size: 18,
                                ),
                              )
                            : Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.grey.shade200
                                        : Colors.black12,
                                    shape: BoxShape.circle),
                                child: const Icon(
                                  Icons.lock_open,
                                  size: 20,
                                ),
                              ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(fontSize: 12)),
                              user.bio,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.blue.shade50
                                        : Colors.black12,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 4),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.work_outline,
                                          size: 17,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          user.availability,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                // Text(
                                //   'KES ${user.payment}',
                                //   style: const TextStyle(
                                //       fontWeight: FontWeight.bold),
                                // )
                              ],
                            )
                          ],
                        ),
                        onTap: () {
                          user.hired == 'true'
                              ? Fluttertoast.showToast(
                                  msg: "${user.name} not available",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 16.0)
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Profile(
                                      id: user.id,
                                      image: user.image,
                                      name: user.name,
                                      bio: user.bio,
                                      category: user.category,
                                      payment: user.payment,
                                      rating: user.rating,
                                    ),
                                  ),
                                );
                        },
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

  Widget buildUsersResult() => GroupedListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        // elements: users!.where((user) => user.category == search.text).toList(),
        elements:
            sortedusers!.where((user) => user.category == search.text).toList(),
        separator: const SizedBox(height: 10),
        order: GroupedListOrder.ASC,
        groupBy: (user) => sortTByCategory,
        groupSeparatorBuilder: (value) => Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sortTByCategory.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(
                width: 3,
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.reviews_outlined),
                            title: const Text('Highest rating'),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                sortedusers!.sort(
                                    (a, b) => b.rating.compareTo(a.rating));
                                sortedusers!.map((e) => e.rating).toList();
                              });
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.person_outline),
                            title: const Text('Current online'),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                sortedusers = users!
                                    .where((element) =>
                                        element.category == sortTByCategory &&
                                        element.online == 'true')
                                    .toList();
                              });
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.check_circle_outline),
                            title: const Text('Completed job'),
                            onTap: () {
                              setState(() {
                                sortedusers = users!
                                    .where((element) =>
                                        element.category == sortTByCategory &&
                                        element.hired == 'false')
                                    .toList();
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.pin_drop_outlined),
                            title: const Text('Distance'),
                            onTap: () {
                              setState(() {});
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.sort),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      'Filter',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        itemBuilder: (BuildContext context, user) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.grey[700],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          userImage = user.image;
                        });
                        showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 4),
                              title: Text(user.name),
                              content: userImage == ''
                                  ? const Text('')
                                  : Container(
                                      height: 250,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage('$userImage'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: user.image == ''
                          ? Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Center(child: Text(user.name[0])),
                            )
                          : Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(user.image),
                                    fit: BoxFit.cover),
                              ),
                            ),
                    ),
                    user.online == 'true'
                        ? Positioned(
                            right: -5,
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade400,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          )
                        : const Text('')
                  ],
                ),
                title: Row(
                  children: [
                    Text(
                      user.name,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    RatingBar.builder(
                      initialRating: 1.0,
                      minRating: 1,
                      ignoreGestures: false,
                      direction: Axis.horizontal,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.blue,
                      ),
                      updateOnDrag: true,
                      itemSize: 18,
                      onRatingUpdate: (rating) {},
                      allowHalfRating: true,
                    ),
                  ],
                ),
                trailing: user.hired == 'true'
                    ? Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey.shade200
                                    : Colors.black12,
                            shape: BoxShape.circle),
                        child: const Icon(
                          Icons.lock,
                          size: 20,
                        ),
                      )
                    : Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey.shade200
                                    : Colors.black12,
                            shape: BoxShape.circle),
                        child: const Icon(
                          Icons.lock_open,
                          size: 20,
                        ),
                      ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.bio,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.blue.shade50
                                    : Colors.black12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 4),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.work_outline,
                                  size: 17,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  user.availability,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                        // Text(
                        //   'KES ${user.payment}',
                        //   style: const TextStyle(
                        //       fontWeight: FontWeight.bold),
                        // )
                      ],
                    )
                  ],
                ),
                onTap: () {
                  user.hired == 'true'
                      ? Fluttertoast.showToast(
                          msg: "${user.name} not available",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0)
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(
                              id: user.id,
                              image: user.image,
                              name: user.name,
                              bio: user.bio,
                              category: user.category,
                              payment: user.payment,
                              rating: user.rating,
                            ),
                          ),
                        );
                },
              ),
            ),
          );
        },
      );

  Widget buildCategories() => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    var category = categories[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          isSeaching = !isSeaching;
                          sortedusers = [];
                          search.text = category['category'];
                          sortTByCategory = category['category'];
                          for (int i = 0; i < users!.length; i++) {
                            if (users![i].category == sortTByCategory) {
                              sortedusers!.add(users![i]);
                            }
                          }
                        });
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Container(
                          decoration: BoxDecoration(
                            // color:
                            //     Theme.of(context).brightness == Brightness.light
                            //         ? Colors.white
                            //         : Colors.grey[700],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: AssetImage(category['image']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                category['category'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      );

  Widget buildSheet() => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        behavior: HitTestBehavior.opaque,
        child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 1,
          builder: (_, controller) {
            return FutureBuilder(
              future: httpServices.fetchPosts(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error');
                } else if (!snapshot.hasData) {
                  const Text("No Posts");
                }
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    controller: controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Updates",
                            style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: posts!.length,
                          itemBuilder: (BuildContext context, index) {
                            var post = posts![index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(),
                              child: Card(
                                elevation: 5,
                                child: SizedBox(
                                  // width: 300,
                                  // height: 500,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                post.user!.image.toString() ==
                                                        ''
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .blue
                                                                    .shade100,
                                                                shape: BoxShape
                                                                    .circle),
                                                        height: 35,
                                                        width: 35,
                                                        child: Center(
                                                          child: Text(
                                                            post.user!.name[0],
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                              post.user!.image
                                                                  .toString(),
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              offset:
                                                                  const Offset(
                                                                      5.0, 5.0),
                                                              blurRadius: 1,
                                                              spreadRadius: 1,
                                                              color: Colors
                                                                  .grey.shade400
                                                                  .withOpacity(
                                                                      0.4),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  "Abraham Lincoln",
                                                  style: GoogleFonts.montserrat(
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Icon(
                                              Icons.more_vert_outlined,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          color: Colors.grey.shade500,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 250,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  post.file.toString(),
                                                ),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Visibility(
                                          visible: post.heading
                                              .toString()
                                              .isNotEmpty,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Visibility(
                                              visible: post.heading
                                                  .toString()
                                                  .isNotEmpty,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      post.heading.toString(),
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        textStyle:
                                                            const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    //
                                                    ReadMoreText(
                                                      post.description
                                                          .toString(),
                                                      trimLines: 5,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText:
                                                          'Show more',
                                                      trimExpandedText:
                                                          'Show less',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        textStyle:
                                                            const TextStyle(
                                                                // color: Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                      moreStyle:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.blue.shade50,
                                                        minimumSize: const Size
                                                                .fromHeight(
                                                            40), // NEW
                                                      ),
                                                      onPressed: () {},
                                                      child: Text(
                                                        'Visit ${post.user!.name}',
                                                        style: const TextStyle(
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            SimpleCircularProgressBar(
                                              progressStrokeWidth: 4,
                                              backColor: Colors.grey.shade200,
                                              backStrokeWidth: 4,
                                              progressColors: const [
                                                Colors.blue
                                              ],
                                              maxValue: 40,
                                              size: 50,
                                              onGetText: (double value) {
                                                return Text(
                                                    '${value.toInt()}%');
                                              },
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Targeting 90% ",
                                                  style: GoogleFonts.montserrat(
                                                    textStyle: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                    "Medium targets reached",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      textStyle:
                                                          const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Container(
                              //   decoration:
                              //       const BoxDecoration(color: Colors.white),

                              // )
                              // Container(
                              //   decoration:
                              //       const BoxDecoration(color: Colors.white),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Padding(
                              //         padding: const EdgeInsets.symmetric(
                              //             horizontal: 10),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Row(
                              //               children: [
                              //                 post.user!.image.toString() == ''
                              //                     ? Container(
                              //                         decoration: BoxDecoration(
                              //                             color: Colors
                              //                                 .blue.shade100,
                              //                             shape:
                              //                                 BoxShape.circle),
                              //                         height: 35,
                              //                         width: 35,
                              //                         child: Center(
                              //                           child: Text(
                              //                             post.user!.name[0],
                              //                           ),
                              //                         ),
                              //                       )
                              //                     : Container(
                              //                         height: 35,
                              //                         width: 35,
                              //                         decoration: BoxDecoration(
                              //                           shape: BoxShape.circle,
                              //                           image: DecorationImage(
                              //                               image: NetworkImage(
                              //                                 post.user!.image
                              //                                     .toString(),
                              //                               ),
                              //                               fit: BoxFit.cover),
                              //                         ),
                              //                       ),
                              //                 const SizedBox(
                              //                   width: 8,
                              //                 ),
                              //                 Column(
                              //                   crossAxisAlignment:
                              //                       CrossAxisAlignment.start,
                              //                   children: [
                              //                     Text(
                              //                       post.user!.name,
                              //                       style: const TextStyle(
                              //                         fontWeight:
                              //                             FontWeight.bold,
                              //                       ),
                              //                     ),
                              //                     Text(
                              //                       post.user!.bio,
                              //                       style: const TextStyle(
                              //                           fontWeight:
                              //                               FontWeight.bold,
                              //                           color: Colors.grey),
                              //                     )
                              //                   ],
                              //                 )
                              //               ],
                              //             ),
                              //             InkWell(
                              //               onTap: () {
                              //                 showModalBottomSheet(
                              //                   context: context,
                              //                   builder: (context) {
                              //                     return const Column(
                              //                       mainAxisSize:
                              //                           MainAxisSize.min,
                              //                       children: <Widget>[
                              //                         ListTile(
                              //                           leading: Icon(Icons
                              //                               .block_outlined),
                              //                           title: Text('Block'),
                              //                         ),
                              //                         ListTile(
                              //                           leading: Icon(
                              //                               Icons.star_outline),
                              //                           title: Text('Rate'),
                              //                         ),
                              //                         ListTile(
                              //                           leading: Icon(Icons
                              //                               .check_circle_outline),
                              //                           title: Text(
                              //                               'Visit account'),
                              //                         ),
                              //                       ],
                              //                     );
                              //                   },
                              //                 );
                              //               },
                              //               child: Row(
                              //                 children: [
                              //                   Row(
                              //                     children: [
                              //                       const Icon(
                              //                         Icons.timer_outlined,
                              //                         size: 16,
                              //                         color: Colors.grey,
                              //                       ),
                              //                       const SizedBox(
                              //                         width: 3,
                              //                       ),
                              //                       Text("22 min",
                              //                           style: TextStyle(
                              //                             color: Colors.grey,
                              //                           ))
                              //                     ],
                              //                   ),
                              //                   const Icon(
                              //                     Icons.more_vert_outlined,
                              //                   ),
                              //                 ],
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //       ),
                              //       const SizedBox(
                              //         height: 10,
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.symmetric(
                              //             horizontal: 10),
                              //         child: Visibility(
                              //           visible:
                              //               post.heading.toString().isNotEmpty,
                              //           child: Padding(
                              //             padding: const EdgeInsets.symmetric(
                              //                 vertical: 10),
                              //             child: Text(
                              //               post.heading.toString(),
                              //               style: GoogleFonts.montserrat(
                              //                 textStyle: const TextStyle(
                              //                   fontWeight: FontWeight.bold,
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.symmetric(
                              //             horizontal: 10),
                              //         child: Visibility(
                              //           visible:
                              //               post.file.toString().isNotEmpty,
                              //           child: InkWell(
                              //             onTap: () {
                              //               Navigator.push(
                              //                 context,
                              //                 MaterialPageRoute(
                              //                   builder: (context) => ImageView(
                              //                     image: post.file.toString(),
                              //                   ),
                              //                 ),
                              //               );
                              //             },
                              //             child: Container(
                              //               height: 300,
                              //               width: MediaQuery.of(context)
                              //                   .size
                              //                   .width,
                              //               decoration: BoxDecoration(
                              //                 image: DecorationImage(
                              //                     image: NetworkImage(
                              //                       post.file.toString(),
                              //                     ),
                              //                     fit: BoxFit.cover),
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //       const SizedBox(
                              //         height: 10,
                              //       ),
                              //       Visibility(
                              //         visible: post.heading!.isNotEmpty,
                              //         child: Padding(
                              //           padding: const EdgeInsets.symmetric(
                              //               horizontal: 10),
                              //           child: Container(
                              //             decoration: const BoxDecoration(
                              //               color: Colors.white,
                              //               // borderRadius: const BorderRadius.all(
                              //               //   Radius.circular(10.0),
                              //               // ),
                              //               // boxShadow: [
                              //               //   BoxShadow(
                              //               //     color: Colors.grey.shade300,
                              //               //     spreadRadius: 2,
                              //               //     blurRadius: 5,
                              //               //     offset: const Offset(0, 3),
                              //               //   ),
                              //               // ],
                              //             ),
                              //             child: Padding(
                              //               padding: const EdgeInsets.all(8.0),
                              //               child: Column(
                              //                 children: [
                              //                   Row(
                              //                     children: [
                              //                       const Icon(
                              //                           Icons.link_outlined),
                              //                       const SizedBox(
                              //                         width: 5,
                              //                       ),
                              //                       Text(post.companylink,
                              //                           style: GoogleFonts
                              //                               .montserrat(
                              //                             textStyle:
                              //                                 const TextStyle(
                              //                                     fontWeight:
                              //                                         FontWeight
                              //                                             .w500),
                              //                           ))
                              //                     ],
                              //                   ),
                              //                   const Divider(),
                              //                   Row(
                              //                     children: [
                              //                       const Icon(
                              //                           Icons.work_outline),
                              //                       const SizedBox(
                              //                         width: 5,
                              //                       ),
                              //                       Text(
                              //                         'people image',
                              //                         style: GoogleFonts
                              //                             .montserrat(
                              //                           textStyle:
                              //                               const TextStyle(
                              //                                   fontWeight:
                              //                                       FontWeight
                              //                                           .w500),
                              //                         ),
                              //                       )
                              //                     ],
                              //                   ),
                              //                   const Divider(),
                              //                   // Row(
                              //                   //   children: [
                              //                   //     const Icon(
                              //                   //         Icons.link_outlined),
                              //                   //     const SizedBox(
                              //                   //       width: 5,
                              //                   //     ),
                              //                   //     Text(post.companylink)
                              //                   //   ],
                              //                   // ),
                              //                   // const Divider()
                              //                 ],
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //       const SizedBox(
                              //         height: 10,
                              //       ),
                              //       Padding(
                              //         padding: const EdgeInsets.symmetric(
                              //             horizontal: 10),
                              //         child: Visibility(
                              //           visible: post.description
                              //               .toString()
                              //               .isNotEmpty,
                              //           child: Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              //             child: Column(
                              //               crossAxisAlignment:
                              //                   CrossAxisAlignment.start,
                              //               children: [
                              //                 Text(
                              //                   'Description',
                              //                   style: GoogleFonts.montserrat(
                              //                     textStyle: const TextStyle(
                              //                         fontWeight:
                              //                             FontWeight.bold),
                              //                   ),
                              //                 ),
                              //                 const SizedBox(
                              //                   height: 4,
                              //                 ),
                              //                 ReadMoreText(
                              //                   post.description.toString(),
                              //                   trimLines: 5,
                              //                   // colorClickableText:
                              //                   //     Colors.grey.shade700,
                              //                   trimMode: TrimMode.Line,
                              //                   trimCollapsedText: 'Show more',
                              //                   trimExpandedText: 'Show less',
                              //                   style: GoogleFonts.montserrat(
                              //                     textStyle: const TextStyle(
                              //                         // color: Colors.grey,
                              //                         fontWeight:
                              //                             FontWeight.w500),
                              //                   ),
                              //                   moreStyle: const TextStyle(
                              //                       fontWeight:
                              //                           FontWeight.bold),
                              //                 ),
                              //                 const SizedBox(
                              //                   height: 5,
                              //                 ),
                              //                 TextButton(
                              //                   style: TextButton.styleFrom(
                              //                     backgroundColor:
                              //                         Colors.blue.shade50,
                              //                     minimumSize:
                              //                         const Size.fromHeight(
                              //                             40), // NEW
                              //                   ),
                              //                   onPressed: () {},
                              //                   child: Text(
                              //                     'Visit ${post.user!.name}',
                              //                     style: const TextStyle(
                              //                       color: Colors.blue,
                              //                     ),
                              //                   ),
                              //                 ),
                              //                 const SizedBox(
                              //                   height: 20,
                              //                 ),
                              //                 // Center(
                              //                 //   child: Row(
                              //                 //     mainAxisAlignment:
                              //                 //         MainAxisAlignment
                              //                 //             .spaceBetween,
                              //                 //     children: [
                              //                 //       Text(
                              //                 //         "Actions",
                              //                 //         style: GoogleFonts.montserrat(
                              //                 //             textStyle:
                              //                 //                 const TextStyle(
                              //                 //                     fontWeight:
                              //                 //                         FontWeight
                              //                 //                             .bold)),
                              //                 //       ),

                              //                 //     ],
                              //                 //   ),
                              //                 // ),
                              //                 // Divider(
                              //                 //   height: 10,
                              //                 //   thickness: 3,
                              //                 //   // indent: 20,
                              //                 //   endIndent: 250,
                              //                 //   color: Colors.grey.shade400,
                              //                 // ),
                              //                 // const SizedBox(
                              //                 //   height: 20,
                              //                 // ),
                              //                 // const Divider(),
                              //                 // Row(
                              //                 //   mainAxisAlignment:
                              //                 //       MainAxisAlignment
                              //                 //           .spaceEvenly,
                              //                 //   children: [
                              //                 //     Column(
                              //                 //       children: [
                              //                 //         Container(
                              //                 //           padding:
                              //                 //               const EdgeInsets
                              //                 //                   .all(5),
                              //                 //           decoration:
                              //                 //               BoxDecoration(
                              //                 //                   color: Colors
                              //                 //                       .amber
                              //                 //                       .shade50,
                              //                 //                   shape: BoxShape
                              //                 //                       .circle),
                              //                 //           child: const Icon(
                              //                 //             Icons
                              //                 //                 .bookmark_outline,
                              //                 //             color: Colors.amber,
                              //                 //             size: 22,
                              //                 //           ),
                              //                 //         ),
                              //                 //         const Text('bookmark')
                              //                 //       ],
                              //                 //     ),
                              //                 //     Column(
                              //                 //       children: [
                              //                 //         Container(
                              //                 //           padding:
                              //                 //               const EdgeInsets
                              //                 //                   .all(5),
                              //                 //           decoration:
                              //                 //               BoxDecoration(
                              //                 //                   color: Colors
                              //                 //                       .red
                              //                 //                       .shade50,
                              //                 //                   shape: BoxShape
                              //                 //                       .circle),
                              //                 //           child: Icon(
                              //                 //             Icons
                              //                 //                 .reviews_outlined,
                              //                 //             color: Colors
                              //                 //                 .red.shade300,
                              //                 //             size: 22,
                              //                 //           ),
                              //                 //         ),
                              //                 //         const Text(
                              //                 //           'Reviews',
                              //                 //           style: TextStyle(),
                              //                 //         )
                              //                 //       ],
                              //                 //     ),
                              //                 //     Column(
                              //                 //       children: [
                              //                 //         Container(
                              //                 //           padding:
                              //                 //               const EdgeInsets
                              //                 //                   .all(5),
                              //                 //           decoration:
                              //                 //               BoxDecoration(
                              //                 //                   color: Colors
                              //                 //                       .purple
                              //                 //                       .shade50,
                              //                 //                   shape: BoxShape
                              //                 //                       .circle),
                              //                 //           child: Icon(
                              //                 //             Icons.work_outline,
                              //                 //             color: Colors
                              //                 //                 .purple.shade300,
                              //                 //             size: 22,
                              //                 //           ),
                              //                 //         ),
                              //                 //         const Text('Jobs')
                              //                 //       ],
                              //                 //     )
                              //                 //   ],
                              //                 // ),
                              //                 // const Divider()
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //       const SizedBox(
                              //         height: 10,
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
}
