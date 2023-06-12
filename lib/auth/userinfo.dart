import 'dart:io';

import 'package:findme/httpServices/httpServices.dart';
import 'package:findme/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({
    super.key,
    required this.countryCode,
    required this.phoneNumber,
  });

  final String countryCode;
  final String phoneNumber;

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  String? hired = 'false';
  String? payment = '450/d';
  String? rating = '5.0';
  String? online = 'true';
  String? jobCategory;
  final ImagePicker imagePicker = ImagePicker();
  XFile? image;
  HttpServices httpServices = HttpServices();

  final List<String> category = [
    'Art',
    'Business',
    'Education',
    'Law enforcement',
    'Media',
    'Medical',
    'Service industry',
    'Technology',
    'Other options'
  ];

  String? availability = '';

  Future<void> pickImage() async {
    var img = await imagePicker.pickImage(source: ImageSource.gallery);
    if (img == null) return;
    setState(() {
      image = img;
    });
    print(image!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: const Text(
          'Add details',
          style: TextStyle(),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Stack(
                    children: [
                      image == null
                          ? Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade200,
                                shape: BoxShape.circle,
                                image: const DecorationImage(
                                  image: AssetImage('images/profile.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: FileImage(
                                      File(image!.path),
                                    ),
                                    fit: BoxFit.cover),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            pickImage();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade200,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 3,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                            child: Icon(
                              Icons.camera,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Full name',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey.shade200
                                  : Colors.grey[700],
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade700,
                          ),
                        ),
                        child: TextFormField(
                          controller: _name,
                          decoration: const InputDecoration(
                              // contentPadding: const EdgeInsets.all(8),
                              border: InputBorder.none,
                              hintText: 'Enter your name',
                              prefixIcon: Icon(Icons.person_outline)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // category
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Job category',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey.shade200
                                  : Colors.grey[700],
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade700,
                          ),
                        ),
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(8),
                            border: InputBorder.none,
                            hintText: 'Enter your name',
                            prefixIcon: Icon(
                              Icons.category_outlined,
                            ),
                          ),
                          hint: const Text('Select job type'),
                          value: jobCategory,
                          isExpanded: true,
                          alignment: AlignmentDirectional.bottomStart,
                          items: category
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                              .toList(),
                          onChanged: (String? value) {
                            setState(() {
                              jobCategory = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // bio
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add bio',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey.shade200
                                  : Colors.grey[700],
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade700,
                          ),
                        ),
                        child: TextFormField(
                          controller: _bio,
                          decoration: const InputDecoration(
                            // contentPadding: EdgeInsets.all(5),
                            border: InputBorder.none,
                            hintText: 'Bio',
                            prefixIcon: Icon(Icons.info_outline),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),

                // Availability
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Availability',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
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
                              child: RadioListTile(
                                title: const Text("Full Time"),
                                value: "Full Time",
                                groupValue: availability,
                                onChanged: (value) {
                                  setState(() {
                                    availability = value.toString();
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
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
                              child: RadioListTile(
                                title: const Text("Part Time"),
                                value: "Part Time",
                                groupValue: availability,
                                onChanged: (value) {
                                  setState(() {
                                    availability = value.toString();
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 60,
                )
              ],
            ),
          ),

          // bottom button
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () async {
                  setState(() {});
                  await httpServices.addUser(
                    widget.countryCode,
                    widget.phoneNumber,
                    image,
                    _name.text,
                    _bio.text,
                    hired.toString(),
                    availability.toString(),
                    jobCategory.toString(),
                    payment.toString(),
                    rating.toString(),
                    online.toString(),
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Menu(),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: httpServices.creatingUser == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitCircle(
                              color: Colors.grey.shade300,
                              size: 30.0,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              'Please wait ...',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'NEXT',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ],
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
