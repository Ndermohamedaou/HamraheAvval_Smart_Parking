import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class vlc_view extends StatefulWidget {
  @override
  _vlc_viewState createState() => _vlc_viewState();
}

class _vlc_viewState extends State<vlc_view> {
  VlcPlayerController controller;

  @override
  void initState() {
    controller = VlcPlayerController(onInit: () {
      controller.play();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VlcPlayer(
      controller: controller,
      aspectRatio: 4 / 3,
      url: 'http://samples.mplayerhq.hu/MPEG-4/embedded_subs/1Video_2Audio_2SUBs_timed_text_streams_.mp4',
    );
  }
}
