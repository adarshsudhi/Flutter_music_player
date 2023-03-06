import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playit/Audiofetchfunc/onAuioQuary.dart';
import 'package:playit/global/Colors.dart';

class PlayiTmain extends StatefulWidget {
  const PlayiTmain(
      {super.key,
      required this.player,
      required this.currentindex,
      required this.songsoureces,
      required this.songlist,
      required this.onAudioQuery});
  final int? currentindex;
  final List<AudioSource> songsoureces;
  final List<SongModel> songlist;
  final AudioPlayer player;
  final OnAudioQuery onAudioQuery;

  @override
  State<PlayiTmain> createState() => _PlayiTmainState();
}

class _PlayiTmainState extends State<PlayiTmain> {
  final Getxsong = Get.put(Audiofetch());
  bool Shuffled = false;
  List<AudioSource> sourece = [];
  Uint8List? Artwork;
  int? currentindex = 0;
  bool _isplaying = false;
  Duration duration = Duration();
  Duration position = Duration();
  Uint8List? img;
  bool _isLooped = false;
  listentoindex() {
    widget.player.currentIndexStream.listen((event) {
      setState(() {
        if (event != null) {
          currentindex = event;
          Getxsong.updateid(currentindex!);
        }
      });
    });
  }

  parse() {
    for (var element in widget.songlist) {
      sourece.add(AudioSource.uri(
        Uri.parse(element.uri!),
        tag: MediaItem(
          id: '${widget.songlist[currentindex!].id}',
          album: "${widget.songlist[currentindex!].album}",
          title: widget.songlist[currentindex!].displayName,
          artUri: Uri.parse(widget.songlist[currentindex!].uri!),
        ),
      ));
    }
  }

  PlayAudio() {
    widget.player.setAudioSource(ConcatenatingAudioSource(children: sourece),
        initialIndex: currentindex);
    widget.player.play();
    _isplaying = true;
    widget.player.durationStream.listen((d) {
      if (mounted) {
        setState(() {
          duration = d!;
        });
      }
    });
    widget.player.positionStream.listen((p) {
      if (mounted) {
        setState(() {
          position = p;
        });
      }
    });
  }

  void changeduration(int sceconds) {
    Duration duration = Duration(seconds: sceconds);
    widget.player.seek(duration);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    parse();
    currentindex = widget.currentindex;
    listentoindex();
    PlayAudio();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    widget.player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new_outlined)),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent.withOpacity(0.1),
        title: Text(widget.songlist[currentindex!].displayName),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
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
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60))),
                elevation: 50,
                child: Container(
                  width: double.infinity,
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
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60))),
                  height: MediaQuery.of(context).size.height / 4,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 4,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(60),
                                bottomRight: Radius.circular(60))),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 130),
                          child: Column(
                            children: [
                              Text(
                                'Song : ${widget.songlist[Getxsong.id].displayName}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Singer : ${widget.songlist[Getxsong.id].composer}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Card(
                elevation: 30,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(100),
                        bottomLeft: Radius.circular(100))),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: Artwork != null
                      ? Image.asset("assets/339990.jpg")
                      : QueryArtworkWidget(
                          artworkQuality: FilterQuality.high,
                          size: 3000,
                          quality: 100,
                          artworkBorder: BorderRadius.only(
                              topRight: Radius.circular(100),
                              bottomLeft: Radius.circular(100)),
                          id: widget.songlist[currentindex!].id,
                          keepOldArtwork: true,
                          artworkWidth: MediaQuery.of(context).size.width / 1.2,
                          type: ArtworkType.AUDIO),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Card(
                  elevation: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60)),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 155, 148, 255),
                            Color.fromARGB(255, 150, 150, 255),
                            Color.fromARGB(255, 128, 116, 255),
                            Color.fromARGB(255, 133, 135, 255),
                            Color.fromARGB(255, 166, 111, 255),
                          ],
                        ),
                        color: Colors.transparent.withOpacity(0.7),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () {
                                  _isLooped = !_isLooped;
                                  if (_isLooped) {
                                    widget.player.setLoopMode(LoopMode.one);
                                  } else {
                                    widget.player.setLoopMode(LoopMode.off);
                                  }
                                },
                                icon: Icon(
                                  CupertinoIcons.loop,
                                  color: _isLooped ? Colors.red : Colors.white,
                                )),
                            IconButton(
                                onPressed: () {
                                  widget.player.stop();
                                  Get.back();
                                },
                                icon: Icon(
                                  Icons.stop_circle_outlined,
                                  color: Colors.white,
                                  size: 35,
                                )),
                            IconButton(
                                onPressed: () {
                                  Shuffled = !Shuffled;
                                  if (Shuffled) {
                                    widget.player.setShuffleModeEnabled(true);
                                  } else {
                                    widget.player.setShuffleModeEnabled(false);
                                  }
                                },
                                icon: Icon(
                                  CupertinoIcons.shuffle,
                                  color: Shuffled == true
                                      ? Colors.red
                                      : Colors.white,
                                ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              position
                                  .toString()
                                  .split(".")[0]
                                  .replaceRange(0, 2, ""),
                              style: TextStyle(color: Colors.black),
                            ),
                            Expanded(
                                child: Slider(
                                    activeColor: Colors.black.withOpacity(0.5),
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
                              duration
                                  .toString()
                                  .split(".")[0]
                                  .replaceRange(0, 2, ""),
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () {
                                  widget.player.seekToPrevious();
                                },
                                icon: Icon(
                                  Icons.skip_previous_outlined,
                                  size: 40,
                                  color: Colors.white,
                                )),
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                              child: IconButton(
                                  onPressed: () {
                                    _isplaying = !_isplaying;
                                    if (_isplaying) {
                                      widget.player.play();
                                    } else {
                                      widget.player.pause();
                                    }
                                  },
                                  icon: _isplaying
                                      ? Icon(
                                          CupertinoIcons.pause,
                                          color: Colors.black,
                                        )
                                      : Icon(
                                          CupertinoIcons.play_arrow,
                                          color: Colors.black,
                                        )),
                            ),
                            IconButton(
                                onPressed: () {
                                  widget.player.seekToNext();
                                },
                                icon: Icon(
                                  Icons.skip_next_outlined,
                                  size: 40,
                                  color: Colors.white,
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
