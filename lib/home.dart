import 'dart:convert';
import 'package:findme/auth/login.dart';
import 'package:findme/data.dart';
import 'package:findme/drawer.dart';
import 'package:findme/httpServices/httpServices.dart';
import 'package:findme/models/user.dart';
import 'package:findme/post.dart';
import 'package:findme/profile.dart';
import 'package:findme/updates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'models/post.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                  title: const Text('Find me'),
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
                const Text(
                  'Top updates',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Updates(),
                      ),
                    );
                  },
                  child: const Text(
                    'View all',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                                  Container(
                                    height: 120,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(post.file.toString()),
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Row(
                                children: [
                                  Icon(
                                    Icons.lock,
                                    size: 13,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Subscribe')
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
                          children: [
                            Text(user.name),
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
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
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
                    Text(user.name),
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
}
