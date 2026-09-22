import 'package:flutter/material.dart';

/// The ways of studying that don't produce a note or a verse entry. The
/// [key] is what's stored in the database, so never rename one.
class StudyLogKind {
  const StudyLogKind(this.key, this.label, this.icon);
  final String key;
  final String label;
  final IconData icon;
}

const studyLogKinds = <StudyLogKind>[
  StudyLogKind('broadcasting', 'Watched JW Broadcasting', Icons.smart_display_outlined),
  StudyLogKind('restudy', 'Re-read / restudied', Icons.menu_book_outlined),
  StudyLogKind('drawing', 'Drawing / creative study', Icons.brush_outlined),
  StudyLogKind('family', 'Family worship', Icons.groups_outlined),
  StudyLogKind('meeting', 'Meeting preparation', Icons.event_note_outlined),
  StudyLogKind('other', 'Something else', Icons.more_horiz),
];

StudyLogKind studyLogKindFor(String key) =>
    studyLogKinds.firstWhere((k) => k.key == key, orElse: () => studyLogKinds.last);
