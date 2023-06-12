import 'dart:convert';
import 'package:findme/models/auth.dart';
import 'package:findme/models/task.dart';
import 'package:findme/models/user.dart';
import 'package:findme/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpServices {
  String? approved;
  bool? valid;
  String? loginStatus;
  bool isLoading = false;
  bool creatingUser = false;

  Future<Auth> sendOtp(String countryCode, String phoneNumber) async {
    isLoading = true;
    final response = await http.post(
      Uri.parse('https://findmeapi.onrender.com/sendOtp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, String>{
          'countryCode': countryCode,
          'phoneNumber': phoneNumber
        },
      ),
    );

    if (response.statusCode == 200) {
      Auth data = Auth.fromJson(jsonDecode(response.body));
      approved = data.status;
      valid = data.valid;
      isLoading = false;
      print(approved);
      print(valid);
      return data;
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<Auth> verifyOtp(countryCode, phoneNumber, otp) async {
    approved = "pending";
    isLoading = true;
    final response = await http.post(
      Uri.parse('https://findmeapi.onrender.com/verifyOtp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, String>{
          'countryCode': countryCode,
          'phoneNumber': phoneNumber,
          'otp': otp,
        },
      ),
    );

    if (response.statusCode == 200) {
      Auth data = Auth.fromJson(jsonDecode(response.body));
      approved = data.status;
      valid = data.valid;
      isLoading = false;

      print(data.status);
      print(data.valid);

      return data;
    } else {
      throw Exception('Failed to verify the user');
    }
  }

  Future<User> addUser(
    String countryCode,
    String phoneNumber,
    XFile? image,
    String name,
    String bio,
    String hired,
    String availability,
    String category,
    String payment,
    String rating,
    String online,
  ) async {
    creatingUser = true;
    if (image == null) {
      final response = await http.post(
        Uri.parse('https://findmeapi.onrender.com/addUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
          <String, String>{
            'countryCode': countryCode,
            'phoneNumber': phoneNumber,
            'image': '',
            'name': name,
            'bio': bio,
            'hired': hired,
            'availability': availability,
            'category': category,
            'payment': payment,
            'rating': rating,
            'online': online,
          },
        ),
      );

      if (response.statusCode == 200) {
        creatingUser = false;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user', response.body);

        Map<String, dynamic> user = jsonDecode(response.body);
        return User.fromJson(user);
      } else {
        throw Exception('Failed to edit the user');
      }
    } else {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://findmeapi.onrender.com/addUser'),
      );
      request.headers
          .addAll({'Content-Type': 'application/json; charset=UTF-8'});
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.fields['countryCode'] = countryCode.toString();
      request.fields['phoneNumber'] = phoneNumber.toString();
      request.fields['name'] = name.toString();
      request.fields['bio'] = bio.toString();
      request.fields['hired'] = hired.toString();
      request.fields['availability'] = availability.toString();
      request.fields['category'] = category.toString();
      request.fields['payment'] = payment.toString();
      request.fields['rating'] = rating.toString();
      request.fields['online'] = online.toString();

      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        creatingUser = false;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user', responsed.body);

        Map<String, dynamic> user = jsonDecode(responsed.body);
        return User.fromJson(user);
      } else {
        throw Exception('Failed to add the user');
      }
    }
  }

  Future<User> editUser(String id, XFile? image, String? userImage, String name,
      String category, String bio, String availability) async {
    isLoading = true;
    if (image == null) {
      final response = await http.put(
        Uri.parse('https://findmeapi.onrender.com/editUser/${id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
          <String, String>{
            'image': userImage.toString(),
            'name': name,
            'category': category,
            'bio': bio,
            'availability': availability
          },
        ),
      );

      if (response.statusCode == 200) {
        isLoading = false;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user', response.body);

        Map<String, dynamic> user = jsonDecode(response.body);
        return User.fromJson(user);
      } else {
        throw Exception('Failed to edit the user');
      }
    } else {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('https://findmeapi.onrender.com/editUser/${id}'),
      );
      request.headers
          .addAll({'Content-Type': 'application/json; charset=UTF-8'});
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      request.fields['name'] = name.toString();
      request.fields['bio'] = bio.toString();
      request.fields['availability'] = availability.toString();
      request.fields['category'] = category.toString();

      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        isLoading = false;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user', responsed.body);

        Map<String, dynamic> user = jsonDecode(responsed.body);
        return User.fromJson(user);
      } else {
        throw Exception('Failed to edit the user');
      }
    }
  }

  Future<List<User>> fetchUsers() async {
    var response =
        await http.get(Uri.parse('https://findmeapi.onrender.com/fetchUsers'));
    if (response.statusCode == 200) {
      return parseUsers(response.body);
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  List<User> parseUsers(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  Future<http.Response> addTask(
    String userId,
    String recipientId,
    String category,
    String description,
    String payment,
    String startdate,
    String enddate,
    String status,
    String paid,
  ) async {
    var response = await http.post(
      Uri.parse('https://findmeapi.onrender.com/addTask'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, String>{
          'userId': userId,
          'recipientId': recipientId,
          'category': category,
          'description': description,
          'payment': payment,
          'startdate': startdate,
          'enddate': enddate,
          'status': status,
          'paid': paid
        },
      ),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to add the task');
    }
  }

  Future<List<Task>> fetchTasks() async {
    var response =
        await http.get(Uri.parse('https://findmeapi.onrender.com/fetchTasks'));
    if (response.statusCode == 200) {
      return parseTasks(response.body);
    } else {
      throw Exception('Failed to add user');
    }
  }

  List<Task> parseTasks(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Task>((json) => Task.fromJson(json)).toList();
  }

  Future<Post> createPost(
      int userId, String description, XFile? image, XFile? video) async {
    print(isLoading);
    isLoading = true;
    print(isLoading);
    await Future.delayed(Duration(seconds: 2));
    if (description != '' && image == null && video == null) {
      var request = await http.post(
        Uri.parse('https://findmeapi.onrender.com/createPost'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'userId': userId.toString(),
          'description': description,
          "file": ""
        }),
      );

      if (request.statusCode == 200) {
        isLoading = false;

        return Post.fromJson(jsonDecode(request.body));
      } else {
        throw Exception('Could not post');
      }
    } else if (image != null && description == '' && video == null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://findmeapi.onrender.com/createPost'),
      );
      request.headers
          .addAll({'Content-Type': 'application/json; charset=UTF-8'});
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      request.fields['userId'] = userId.toString();
      request.fields['description'] = "";

      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        isLoading = false;

        Map<String, dynamic> post = jsonDecode(responsed.body);
        return Post.fromJson(post);
      } else {
        throw Exception('Failed to add the post');
      }
    } else if (video != null && description == '' && image == null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://findmeapi.onrender.com/createPost'),
      );
      request.headers
          .addAll({'Content-Type': 'application/json; charset=UTF-8'});
      request.files.add(await http.MultipartFile.fromPath('file', video.path));
      request.fields['userId'] = userId.toString();
      request.fields['description'] = "";

      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        isLoading = false;

        Map<String, dynamic> user = jsonDecode(responsed.body);
        return Post.fromJson(user);
      } else {
        throw Exception('Failed to make the post');
      }
    } else if (image != null && description != '' && video == null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://findmeapi.onrender.com/createPost'),
      );
      request.headers
          .addAll({'Content-Type': 'application/json; charset=UTF-8'});
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
      request.fields['userId'] = userId.toString();
      request.fields['description'] = description.toString();

      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        isLoading = false;

        Map<String, dynamic> user = jsonDecode(responsed.body);
        return Post.fromJson(user);
      } else {
        throw Exception('Failed to make the post');
      }
    } else {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://findmeapi.onrender.com/createPost'),
      );
      request.headers
          .addAll({'Content-Type': 'application/json; charset=UTF-8'});
      request.files.add(await http.MultipartFile.fromPath('file', video!.path));
      request.fields['userId'] = userId.toString();
      request.fields['description'] = description.toString();

      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        isLoading = false;

        Map<String, dynamic> post = jsonDecode(responsed.body);
        return Post.fromJson(post);
      } else {
        throw Exception('Failed to make the post');
      }
    }
  }

  Future<List<Post>> fetchPosts() async {
    var response =
        await http.get(Uri.parse('https://findmeapi.onrender.com/fetchPosts'));
    if (response.statusCode == 200) {
      return parsePosts(response.body);
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

  List<Post> parsePosts(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Post>((json) => Post.fromJson(json)).toList();
  }
}
