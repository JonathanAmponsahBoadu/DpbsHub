import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/local/database.dart';
import '../../data/providers.dart';
import '../../data/repositories/attachments_repository.dart';
import 'attachment_viewer.dart';

/// Row of attachment thumbnails plus an "Add" button — drop this into any
/// screen that should let you attach photos, videos or a voice note (verse
/// entries, standalone notes, talks). Owns nothing itself; every attachment
/// lives against (ownerType, ownerId) in the shared Attachments table.
class AttachmentsStrip extends ConsumerWidget {
  const AttachmentsStrip({super.key, required this.ownerType, required this.ownerId});

  final String ownerType;
  final String ownerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(attachmentsRepositoryProvider);
    final attachmentsAsync =
        ref.watch(_attachmentsStreamProvider((repo: repo, ownerType: ownerType, ownerId: ownerId)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Attachments', style: Theme.of(context).textTheme.labelLarge),
            const Spacer(),
            IconButton.filledTonal(
              icon: const Icon(Icons.add_a_photo_outlined, size: 20),
              tooltip: 'Add photo, video or voice note',
              onPressed: () => _showAddMenu(context, repo),
            ),
          ],
        ),
        const SizedBox(height: 8),
        attachmentsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, __) => Text('$e'),
          data: (list) {
            if (list.isEmpty) {
              return Text(
                'None yet — a scripture, note or talk doesn\'t need one, but a photo of your '
                'notebook page or a short voice note can help it stick.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              );
            }
            return SizedBox(
              height: 84,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) =>
                    _AttachmentThumb(attachment: list[i], repo: repo),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _showAddMenu(BuildContext context, AttachmentsRepository repo) async {
    final choice = await showModalBottomSheet<_AddChoice>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.of(sheetContext).pop(_AddChoice.cameraPhoto),
            ),
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: const Text('Choose a photo'),
              onTap: () => Navigator.of(sheetContext).pop(_AddChoice.galleryPhoto),
            ),
            ListTile(
              leading: const Icon(Icons.videocam_outlined),
              title: const Text('Record a video'),
              onTap: () => Navigator.of(sheetContext).pop(_AddChoice.cameraVideo),
            ),
            ListTile(
              leading: const Icon(Icons.video_library_outlined),
              title: const Text('Choose a video'),
              onTap: () => Navigator.of(sheetContext).pop(_AddChoice.galleryVideo),
            ),
            ListTile(
              leading: const Icon(Icons.mic_outlined),
              title: const Text('Record a voice note'),
              onTap: () => Navigator.of(sheetContext).pop(_AddChoice.voiceNote),
            ),
          ],
        ),
      ),
    );
    if (choice == null || !context.mounted) return;

    switch (choice) {
      case _AddChoice.cameraPhoto:
        await _pickImage(context, repo, ImageSource.camera);
      case _AddChoice.galleryPhoto:
        await _pickImage(context, repo, ImageSource.gallery);
      case _AddChoice.cameraVideo:
        await _pickVideo(context, repo, ImageSource.camera);
      case _AddChoice.galleryVideo:
        await _pickVideo(context, repo, ImageSource.gallery);
      case _AddChoice.voiceNote:
        if (context.mounted) await _recordVoiceNote(context, repo);
    }
  }

  Future<void> _pickImage(BuildContext context, AttachmentsRepository repo, ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 85);
    if (picked == null) return;
    await repo.add(
      ownerType: ownerType,
      ownerId: ownerId,
      kind: AttachmentKind.image,
      sourcePath: picked.path,
      extension: _extensionOf(picked.path, fallback: 'jpg'),
    );
  }

  Future<void> _pickVideo(BuildContext context, AttachmentsRepository repo, ImageSource source) async {
    final picked = await ImagePicker().pickVideo(
      source: source,
      maxDuration: const Duration(minutes: 5),
    );
    if (picked == null) return;
    await repo.add(
      ownerType: ownerType,
      ownerId: ownerId,
      kind: AttachmentKind.video,
      sourcePath: picked.path,
      extension: _extensionOf(picked.path, fallback: 'mp4'),
    );
  }

  Future<void> _recordVoiceNote(BuildContext context, AttachmentsRepository repo) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => _VoiceRecorderSheet(
        onSaved: (path) async {
          await repo.add(
            ownerType: ownerType,
            ownerId: ownerId,
            kind: AttachmentKind.audio,
            sourcePath: path,
            extension: 'm4a',
          );
        },
      ),
    );
  }

  String _extensionOf(String path, {required String fallback}) {
    final ext = p.extension(path).replaceFirst('.', '').toLowerCase();
    return ext.isEmpty ? fallback : ext;
  }
}

enum _AddChoice { cameraPhoto, galleryPhoto, cameraVideo, galleryVideo, voiceNote }

/// Keyed provider so each screen's strip watches only its own owner's rows.
final _attachmentsStreamProvider = StreamProvider.family<
    List<Attachment>, ({AttachmentsRepository repo, String ownerType, String ownerId})>(
  (ref, args) => args.repo.watchFor(args.ownerType, args.ownerId),
);

class _AttachmentThumb extends ConsumerWidget {
  const _AttachmentThumb({required this.attachment, required this.repo});
  final Attachment attachment;
  final AttachmentsRepository repo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => showAttachmentViewer(context, attachment: attachment, repo: repo),
      onLongPress: () => _confirmDelete(context, ref),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 84,
          height: 84,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: switch (attachment.kind) {
            AttachmentKind.image => FutureBuilder<File>(
                future: repo.fileFor(attachment),
                builder: (context, snap) => snap.hasData
                    ? Image.file(snap.data!, fit: BoxFit.cover)
                    : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            AttachmentKind.video => const Center(
                child: Icon(Icons.play_circle_fill_rounded, size: 36),
              ),
            _ => const Center(child: Icon(Icons.graphic_eq_rounded, size: 32)),
          },
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove attachment?'),
        content: const Text('This deletes the file from your device.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: const Text('Remove')),
        ],
      ),
    );
    if (confirmed == true) await repo.remove(attachment);
  }
}

/// Minimal in-sheet recorder: tap to start, tap to stop and save. Uses the
/// `record` package's default AAC/M4A encoder, which every Android device
/// supports without extra setup.
class _VoiceRecorderSheet extends StatefulWidget {
  const _VoiceRecorderSheet({required this.onSaved});
  final Future<void> Function(String path) onSaved;

  @override
  State<_VoiceRecorderSheet> createState() => _VoiceRecorderSheetState();
}

class _VoiceRecorderSheetState extends State<_VoiceRecorderSheet> {
  final _recorder = AudioRecorder();
  bool _recording = false;
  bool _saving = false;
  Duration _elapsed = Duration.zero;
  DateTime? _startedAt;

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    if (!await _recorder.hasPermission()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission is needed to record a voice note.')),
        );
      }
      return;
    }
    final dir = await getTemporaryDirectory();
    final path = p.join(dir.path, 'voice_${DateTime.now().millisecondsSinceEpoch}.m4a');
    await _recorder.start(const RecordConfig(), path: path);
    setState(() {
      _recording = true;
      _startedAt = DateTime.now();
    });
    _tick();
  }

  void _tick() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted || !_recording || _startedAt == null) return;
      setState(() => _elapsed = DateTime.now().difference(_startedAt!));
      _tick();
    });
  }

  Future<void> _stopAndSave() async {
    final path = await _recorder.stop();
    if (path == null) {
      if (mounted) Navigator.of(context).pop();
      return;
    }
    setState(() => _saving = true);
    await widget.onSaved(path);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _cancel() async {
    if (_recording) await _recorder.stop();
    if (mounted) Navigator.of(context).pop();
  }

  String _format(Duration d) =>
      '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _recording ? 'Recording…' : 'Voice note',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(_format(_elapsed), style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            if (_saving)
              const CircularProgressIndicator()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: _cancel, child: const Text('Cancel')),
                  const SizedBox(width: 16),
                  _recording
                      ? FilledButton.icon(
                          onPressed: _stopAndSave,
                          icon: const Icon(Icons.stop_rounded),
                          label: const Text('Stop & save'),
                        )
                      : FilledButton.icon(
                          onPressed: _start,
                          icon: const Icon(Icons.fiber_manual_record_rounded),
                          label: const Text('Start recording'),
                        ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
