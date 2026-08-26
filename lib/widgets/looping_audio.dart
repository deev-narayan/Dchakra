import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Invisible widget that loops an asset audio file for the widget lifetime.
/// Pass [paused] to pause/resume in sync with the session timer.
class LoopingAudio extends StatefulWidget {
  final String assetPath;
  final ValueListenable<bool>? paused;

  const LoopingAudio({
    super.key,
    required this.assetPath,
    this.paused,
  });

  @override
  State<LoopingAudio> createState() => _LoopingAudioState();
}

class _LoopingAudioState extends State<LoopingAudio> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    widget.paused?.addListener(_syncPause);
    _start();
  }

  @override
  void didUpdateWidget(covariant LoopingAudio oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.paused != widget.paused) {
      oldWidget.paused?.removeListener(_syncPause);
      widget.paused?.addListener(_syncPause);
      _syncPause();
    }
  }

  Future<void> _start() async {
    final path = widget.assetPath.replaceFirst('assets/', '');
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource(path));
    await _syncPause();
  }

  Future<void> _syncPause() async {
    final shouldPause = widget.paused?.value ?? false;
    if (shouldPause) {
      await _player.pause();
    } else {
      await _player.resume();
    }
  }

  @override
  void dispose() {
    widget.paused?.removeListener(_syncPause);
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
