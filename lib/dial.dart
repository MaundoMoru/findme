import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:audioplayers/audioplayers.dart';

class Dial extends StatefulWidget {
  const Dial({
    super.key,
    required this.image,
    required this.name,
    required this.payment,
  });

  final String? image;
  final String? name;
  final String? payment;

  @override
  State<Dial> createState() => _DialState();
}

class _DialState extends State<Dial> {
  final audioPlayer = AudioPlayer();
  PlayerState? isPlaying;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  Future<void> playAudio() async {
    await audioPlayer.play(UrlSource(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3'));

    setState(() {
      isPlaying = PlayerState.playing;
    });
  }

  @override
  void initState() {
    super.initState();
    playAudio();

    // Listen to audio duration changes
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    // Listen to audio position
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        duration = newPosition;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: ListView(
          children: [
            widget.image == ''
                ? Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${widget.name}'[0],
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey.shade200
                            : Colors.grey[700],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage('${widget.image}'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                '${widget.name}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                'Requesting ...',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.grey[700],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const SpinKitWave(
                color: Colors.blue,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: InkWell(
                onTap: () {
                  setState(() {
                    audioPlayer.stop();
                    setState(() {
                      isPlaying = PlayerState.stopped;
                    });
                  });

                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                  child: const Icon(
                    Icons.call,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
