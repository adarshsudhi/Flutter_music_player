import 'dart:async';

import 'dart:io';

import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:playit/Audiofetchfunc/onAuioQuary.dart';
import 'package:playit/global/Colors.dart';
import 'package:playit/screens/Playscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AudioSource> songs = [];
  Uint8List? Art;
  final OnAudioQuery _onAudioQuery = OnAudioQuery();
  int? Currentindex = 0;
  final AudioPlayer audioPlayer = AudioPlayer();
  final TextEditingController _songSearch = TextEditingController();
  final Getsongcontroller = Get.put(Audiofetch());

  GetArtwork(int id, ArtworkType type) async {
    final OnAudioQuery _onAudioQuery = OnAudioQuery();
    final AudioPlayer _audioPlayer = AudioPlayer();
    Uint8List? Artwork = await _onAudioQuery.queryArtwork(id, type);

    return Artwork;
  }

  parse() {
    for (var element in Getsongcontroller.Songs) {
      songs.add(AudioSource.uri(
        Uri.parse(element.uri!),
      ));
    }
  }

  Concatinateaduiosource(List<AudioSource> Audiosoureces) async {
    var playlist = ConcatenatingAudioSource(children: Audiosoureces);
    return playlist;
  }

  Currentselectedintem() {}
  @override
  void initState() {
    super.initState();
    Getsongcontroller.GetAllTracks();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
              backgroundColor: Colors.transparent.withOpacity(0.3),
              leading: Icon(CupertinoIcons.music_note),
              title: Text("PlaYit")),
          body: RefreshIndicator(
            onRefresh: () {
              setState(() {});
              return Getsongcontroller.GetAllTracks();
            },
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        end: Alignment.bottomRight,
                        begin: Alignment.topLeft,
                        colors: backgroundColors)),
                child: Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: Getsongcontroller.Songs.length,
                            itemBuilder: (context, index) {
                              final data = Getsongcontroller.Songs[index];
                              final AudioPlayer player = AudioPlayer();
                              final OnAudioQuery onAudioQuery = OnAudioQuery();

                              return InkWell(
                                onTap: () async {
                                  Currentindex = index;

                                  Get.to(() => PlayiTmain(
                                      player: player,
                                      currentindex: Currentindex,
                                      songsoureces: songs,
                                      songlist: Getsongcontroller.Songs,
                                      onAudioQuery: onAudioQuery));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 2, right: 2, top: 5),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    color: Colors.transparent,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              12,
                                      decoration: BoxDecoration(),
                                      child: Center(
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 25,
                                            child: QueryArtworkWidget(
                                                keepOldArtwork: true,
                                                id: data.id,
                                                type: ArtworkType.AUDIO),
                                          ),
                                          title: Text(
                                            data.title,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          trailing: IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.more_vert,
                                                color: Colors.white,
                                              )),
                                          subtitle: Text(
                                            data.artist.toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }))
                  ],
                )),
          ));
    });
  }
}
