import 'dart:io';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../data/local/database.dart';
import '../../data/repositories/attachments_repository.dart';

Future<void> showAttachmentViewer(
  BuildContext context, {
  required Attachment attachment,
  required AttachmentsRepository repo,
}) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _AttachmentViewerScreen(attachment: attachment, repo: repo),
    ),
  );
}

class _AttachmentViewerScreen extends StatelessWidget {
  const _AttachmentViewerScreen({required this.attachment, required this.repo});
  final Attachment attachment;
  final AttachmentsRepository repo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<File>(
        future: repo.fileFor(attachment),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final file = snap.data!;
          if (!file.existsSync()) {
            return const Center(
              child: Text('This file is missing from device storage.',
                  style: TextStyle(color: Colors.white70)),
            );
          }
          return switch (attachment.kind) {
            AttachmentKind.image => Center(child: InteractiveViewer(child: Image.file(file))),
            AttachmentKind.video => _VideoPlayer(file: file),
            _ => _AudioPlayer(file: file),
          };
        },
      ),
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  const _VideoPlayer({required this.file});
  final File file;

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late final VideoPlayerController _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        if (mounted) setState(() => _ready = true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const Center(child: CircularProgressIndicator());
    return Center(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_controller),
            GestureDetector(
              onTap: () => setState(
                () => _controller.value.isPlaying ? _controller.pause() : _controller.play(),
              ),
              child: AnimatedOpacity(
                opacity: _controller.value.isPlaying ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.play_arrow_rounded, size: 72, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioPlayer extends StatefulWidget {
  const _AudioPlayer({required this.file});
  final File file;

  @override
  State<_AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<_AudioPlayer> {
  final _player = ap.AudioPlayer();
  ap.PlayerState _state = ap.PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _total = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player.onPlayerStateChanged.listen((s) => mounted ? setState(() => _state = s) : null);
    _player.onPositionChanged.listen((p) => mounted ? setState(() => _position = p) : null);
    _player.onDurationChanged.listen((d) => mounted ? setState(() => _total = d) : null);
    _player.setSourceDeviceFile(widget.file.path);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _format(Duration d) =>
      '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final playing = _state == ap.PlayerState.playing;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.graphic_eq_rounded, size: 64, color: Colors.white70),
          const SizedBox(height: 20),
          IconButton(
            iconSize: 64,
            color: Colors.white,
            icon: Icon(playing ? Icons.pause_circle_filled : Icons.play_circle_fill),
            onPressed: () => playing ? _player.pause() : _player.resume(),
          ),
          const SizedBox(height: 12),
          Text(
            '${_format(_position)} / ${_format(_total)}',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
