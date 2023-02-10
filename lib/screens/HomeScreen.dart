import 'dart:async';

import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playit/Audiofetchfunc/onAuioQuary.dart';
import 'package:playit/screens/Showdialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SongModel> list = [];
  Uint8List? Art;
  final OnAudioQuery _onAudioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _songSearch = TextEditingController();

  GetAllTracks() async {
    OnAudioQuery onAudioQuery = OnAudioQuery();
    try {
      List<SongModel> listt = await onAudioQuery.querySongs(
        path: "/storage/emulated/0/Music",
        sortType: SongSortType.DATE_ADDED,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      );
      setState(() {
        list = listt;
      });
    } catch (e) {
      return [];
    }
  }

  Refresh() async {
    setState(() {
      GetAllTracks();
    });
  }

  GetArtwork(int id, ArtworkType type) async {
    Uint8List? Artwork = await _onAudioQuery.queryArtwork(id, type);
    return Artwork;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Audiofetch().Getpermission();
    GetAllTracks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent.withOpacity(0.4),
        leading: Icon(CupertinoIcons.music_note),
        title: Text("PlaYit"),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Refresh();
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  end: Alignment.bottomRight,
                  begin: Alignment.topLeft,
                  colors: [
                Color.fromARGB(255, 190, 185, 255),
                Color.fromARGB(255, 175, 175, 255),
                Color.fromARGB(255, 144, 134, 255),
                Color.fromARGB(255, 151, 153, 255),
                Color.fromARGB(255, 178, 130, 255),
              ])),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final data = list[index];

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PlayiTmain(
                                  songsdetails: data,
                                  onAudioQuery: _onAudioQuery,
                                  audioPlayer: _audioPlayer)));
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 2, right: 2, top: 5),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.transparent,
                            child: Container(
                              height: MediaQuery.of(context).size.height / 12,
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
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        CupertinoIcons.music_note_2,
                                        color: Colors.white,
                                      )),
                                  subtitle: Text(
                                    data.artist.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
