import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
class AudioPage extends StatefulWidget {
  const AudioPage({required this.audioUrl, super.key});
  final String audioUrl;

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final AudioPlayer _player = AudioPlayer();
  

  @override
  void initState(){
    super.initState();
    _playAudio();
  }

  void _playAudio() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource(widget.audioUrl.replaceFirst('assets/', '')));
  }

  @override
  void dispose(){
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
