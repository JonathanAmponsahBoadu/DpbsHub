import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A visibly-labeled "open on jw.org" button — used everywhere the app
/// hands off to the official reading page. Deliberately a globe icon + text
/// label (not a bare icon) so it reads unambiguously as "go read this on the
/// jw.org website", not just a generic action button.
class JwOrgLinkButton extends StatelessWidget {
  const JwOrgLinkButton({super.key, required this.url, this.compact = false});

  final String url;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return IconButton(
        tooltip: 'Read on jw.org',
        icon: const Icon(Icons.public),
        onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      );
    }
    return TextButton.icon(
      onPressed: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      icon: const Icon(Icons.public, size: 18),
      label: const Text('Read on jw.org'),
    );
  }
}
