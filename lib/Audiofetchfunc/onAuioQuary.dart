import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class Audiofetch extends GetxController {
  RxList<SongModel> Songquary = <SongModel>[].obs;

  List<SongModel> get Songs => Songquary.value;

  RxInt _id = RxInt(0);
  int get id => _id.value;

  updateid(int idd) {
    _id.value = idd;
  }

  Getpermission() async {
    try {
      var result = await Permission.storage.status;
      if (result.isDenied) {
        Map<Permission, PermissionStatus> status = await [
          Permission.camera,
          Permission.storage,
        ].request();
      }
    } catch (e) {
      print(e);
    }
  }

  GetAllTracks() async {
    OnAudioQuery onAudioQuery = OnAudioQuery();
    List<SongModel> listt = await onAudioQuery.querySongs(
      path: "/storage/emulated/0/Music",
      sortType: SongSortType.DATE_ADDED,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );
    Songquary.value = listt;
  }

  @override
  void onInit() {
    super.onInit();
    Getpermission();
    GetAllTracks();
  }
}
