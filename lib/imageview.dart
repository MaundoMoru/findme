import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: image == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.contain),
              ),
            ),
    );
  }
}
