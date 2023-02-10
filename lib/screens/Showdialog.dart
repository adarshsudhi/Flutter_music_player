import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayiTmain extends StatefulWidget {
  const PlayiTmain(
      {super.key,
      required this.songsdetails,
      required this.onAudioQuery,
      required this.audioPlayer});
  final SongModel songsdetails;
  final OnAudioQuery onAudioQuery;
  final AudioPlayer audioPlayer;

  @override
  State<PlayiTmain> createState() => _PlayiTmainState();
}

class _PlayiTmainState extends State<PlayiTmain> {
  Uint8List? Artwork;
  bool _isplaying = false;
  Duration duration = Duration();
  Duration position = Duration();
  Uint8List? img;
  bool _isLooped = false;
  ConVertImg() async {
    final ByteData byte = await rootBundle.load("assets/339990.jpg");
    final Uint8List CovertedImg = byte.buffer.asUint8List();
    setState(() {
      img = CovertedImg;
    });
  }

  PlayAudio() {
    widget.audioPlayer
        .setAudioSource(AudioSource.uri(Uri.parse(widget.songsdetails.uri!)));
    widget.audioPlayer.play();
    _isplaying = true;
    widget.audioPlayer.durationStream.listen((d) {
      if (mounted) {
        setState(() {
          duration = d!;
        });
      }
    });
    widget.audioPlayer.positionStream.listen((p) {
      if (mounted) {
        setState(() {
          position = p;
        });
      }
    });
  }

  GetImgArtWrok() async {
    try {
      Uint8List? art = await widget.onAudioQuery
          .queryArtwork(widget.songsdetails.id, ArtworkType.AUDIO, size: 2000);
      if (art != null) {
        setState(() {
          Artwork = art;
        });
      } else {
        setState(() {
          Artwork = img;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void changeduration(int sceconds) {
    Duration duration = Duration(seconds: sceconds);
    widget.audioPlayer.seek(duration);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    GetImgArtWrok();
    ConVertImg();
    PlayAudio();
  }

  @override
  Widget build(BuildContext context) {
    if (Artwork == null) {
      return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: CircularProgressIndicator(color: Colors.indigo),
          ),
        ),
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 225, 222, 255),
            Color.fromARGB(255, 224, 221, 255),
            Color.fromARGB(255, 204, 199, 255),
            Color.fromARGB(255, 193, 202, 255),
          ],
        )),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 146, 148, 255),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Material(
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
                elevation: 50,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 190, 185, 255),
                          Color.fromARGB(255, 175, 175, 255),
                          Color.fromARGB(255, 144, 134, 255),
                          Color.fromARGB(255, 151, 153, 255),
                          Color.fromARGB(255, 178, 130, 255),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              )),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text("${widget.songsdetails.title}",
                            style:
                                TextStyle(color: Colors.black, fontSize: 20)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text("${widget.songsdetails.artist}",
                            style:
                                TextStyle(color: Colors.black, fontSize: 14)),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width / 1.11,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                          image: MemoryImage(Artwork!),
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover)),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Material(
                  elevation: 80,
                  shadowColor: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60)),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 190, 185, 255),
                            Color.fromARGB(255, 175, 175, 255),
                            Color.fromARGB(255, 144, 134, 255),
                            Color.fromARGB(255, 151, 153, 255),
                            Color.fromARGB(255, 178, 130, 255),
                          ],
                        ),
                        color: Colors.transparent.withOpacity(0.7),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              position.toString().split(".")[0],
                              style: TextStyle(color: Colors.black),
                            ),
                            Expanded(
                                child: Slider(
                                    activeColor: Colors.black,
                                    inactiveColor: Colors.white,
                                    value: position.inSeconds.toDouble(),
                                    max: duration.inSeconds.toDouble(),
                                    min: Duration(microseconds: 0)
                                        .inSeconds
                                        .toDouble(),
                                    onChanged: (value) {
                                      setState(() {
                                        changeduration(value.toInt());
                                        value = value;
                                      });
                                    })),
                            Text(
                              duration.toString().split(".")[0],
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  _isLooped = !_isLooped;
                                  if (_isLooped) {
                                    await widget.audioPlayer
                                        .setLoopMode(LoopMode.one);
                                  } else {
                                    await widget.audioPlayer
                                        .setLoopMode(LoopMode.off);
                                  }
                                },
                                icon: Icon(
                                  CupertinoIcons.loop_thick,
                                  size: 30,
                                  color: _isLooped ? Colors.red : Colors.black,
                                )),
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(50)),
                              child: IconButton(
                                  onPressed: () {
                                    _isplaying = !_isplaying;
                                    if (_isplaying) {
                                      widget.audioPlayer.play();
                                    } else {
                                      widget.audioPlayer.pause();
                                    }
                                  },
                                  icon: _isplaying
                                      ? Icon(
                                          CupertinoIcons.pause,
                                          color: Colors.white,
                                        )
                                      : Icon(
                                          CupertinoIcons.play_arrow,
                                          color: Colors.white,
                                        )),
                            ),
                            IconButton(
                                onPressed: () async {
                                  await widget.audioPlayer.stop();
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  CupertinoIcons.stop,
                                  size: 30,
                                  color: Colors.black,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
