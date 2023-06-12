import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:readmore/readmore.dart';

class Ratings extends StatefulWidget {
  const Ratings({super.key, required this.name});
  final String name;

  @override
  State<Ratings> createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  bool canRate = true;
  List ratings = [
    {
      "image":
          "https://media.istockphoto.com/id/1007763808/photo/portrait-of-handsome-latino-african-man.jpg?s=612x612&w=0&k=20&c=XPL1ukeC99OY8HBfNa_njDujOPf9Xz4yCEOo7O3evU0=",
      "name": "Ozzy Colter",
      "createdAt": "2 min",
      "rating": "5.0",
      "comment": "The service was very good. I highly recommend!",
      "favorite": "true"
    },
    {
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQeHF_WRk106jz3MYIxgqSGTH-Cj7kgsYMDaUUEnqWVZ8yosyD0I5r4xMSZoTNc0-SBMxE&usqp=CAU",
      "name": "Eliam Camilo",
      "createdAt": "Yesterday",
      "rating": "3.5",
      "comment":
          "The service was very good. I did not know that you can work that good. Congratulations and keep it up.",
      "favorite": "false"
    },
    {
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmoNwonsEQMDbSxj-LxEy2RqOwbLl-aygsTplKFkDjaAWt_o6lMEVSDz1173E5kGrA6ls&usqp=CAU",
      "name": "Koen Bridger",
      "createdAt": "4 min",
      "rating": "4.9",
      "comment": "The service was very good. I highly recommend!",
      "favorite": "false"
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: const Text(
          'Ratings & Reviews',
          style: TextStyle(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: ratings.length,
                  separatorBuilder: (BuildContext context, index) {
                    return Container(
                      height: 10,
                    );
                  },
                  itemBuilder: (BuildContext context, index) {
                    var rating = ratings[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.grey[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: rating['image'] == ''
                            ? Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(child: Text(rating['name'][0])),
                              )
                            : Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(rating['image']),
                                      fit: BoxFit.cover),
                                ),
                              ),
                        title: Row(
                          children: [
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
                            const SizedBox(
                              width: 3,
                            ),
                            Text(rating['name'])
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReadMoreText(
                              rating['comment'],
                              trimLines: 2,
                              colorClickableText: Colors.pink,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              moreStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(rating['createdAt'])
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: OutlinedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)))),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text('Rate ${widget.name}'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Divider(),
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
                                itemSize: 30,
                                onRatingUpdate: (rating) {},
                                allowHalfRating: true,
                              ),
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
                                    hintText: 'Put comment (optional)',
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
                            Container(
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
                            )
                          ],
                        );
                      },
                    );
                    Row(
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
                          itemSize: 15,
                          onRatingUpdate: (rating) {},
                          allowHalfRating: true,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    );
                  },
                  child: const Text('RATE NOW'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
