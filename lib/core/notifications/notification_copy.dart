typedef NotificationText = ({String title, String body});

/// The wording of every notification DpbsHub can send, in one place. Both
/// the real scheduler (reminders_repository.dart, inactivity_nudge_service.dart)
/// and Settings → "Preview notifications" read from here, so what you preview
/// is exactly what arrives — and changing a message means editing one line.
///
/// [n] is your current streak in days; the streak-aware messages fall back to
/// a plain version when it's 0.
abstract final class NotificationCopy {
  // --- Same-day reminders: you haven't studied today -----------------------

  static NotificationText main(int n) => (
        title: 'Time to study 📖',
        body: n > 0
            ? 'Keep your $n-day streak going — a few minutes is all it takes.'
            : 'Take a few minutes for your daily Bible study.',
      );

  /// The three follow-ups, [index] 0..2 — one, two and three hours after the
  /// reminder time, each more insistent than the last.
  static NotificationText followUp(int index, int n) => switch (index) {
        0 => (
            title: "Still haven't studied today 👀",
            body: 'Just one verse counts. Open DpbsHub and log it.',
          ),
        1 => (
            title: n > 0 ? 'Your $n-day streak is on the line 🔥' : "Don't let today slip by 🔥",
            body: 'A single verse keeps the habit alive. Come back now.',
          ),
        _ => (
            title: 'Last call ⏰',
            body: n > 0
                ? "The day's almost over. Study now or lose your $n-day streak."
                : "The day's almost over. Study now — even one verse counts.",
          ),
      };

  /// End-of-day streak alerts — only while there's a streak to lose.
  static NotificationText streakEvening(int n) => (
        title: '⚠️ Your $n-day streak ends tonight',
        body: 'About two and a half hours left. One verse is enough to save it.',
      );

  static NotificationText streakFinal(int n) => (
        title: '🚨 45 minutes left',
        body: 'Study now, or your $n-day streak resets at midnight.',
      );

  // --- Same-day reminders: you've already studied today --------------------

  static const NotificationText gentleMain = (title: 'Just your daily reminder', body: '');

  static NotificationText gentleFollowUp(int index) => switch (index) {
        0 => (
            title: 'Daily reminder 📖',
            body: "You've already studied today — feel free to add a little more.",
          ),
        1 => (
            title: 'Daily reminder 📖',
            body: 'Nice work today. A few more minutes never hurts.',
          ),
        _ => (
            title: 'Daily reminder 📖',
            body: 'Well done today — see you tomorrow!',
          ),
      };

  // --- Multi-day nudges: you've gone quiet for days ------------------------

  /// Keyed by how many days of silence have passed; each fires at noon.
  static const Map<int, NotificationText> inactivityRungs = {
    1: (
      title: "Haven't studied yet today 📖",
      body: 'A few verses today keeps your streak alive.',
    ),
    2: (
      title: 'Two days now 😟',
      body: 'Your Bible study streak has slipped. Come back and start it again.',
    ),
    3: (
      title: "It's been 3 days 😢",
      body: 'DpbsHub misses you. Open the app and log even one verse today.',
    ),
    5: (
      title: '🚨 5 days of silence',
      body: 'Almost a week — just one verse gets you back on track.',
    ),
  };

  /// From day 6 of silence onward, every day at noon until you study again.
  static const NotificationText inactivityDaily = (
    title: 'Your study habit is fading',
    body: 'One verse today gets you back on track.',
  );

  // --- Tests (Settings only) -----------------------------------------------

  static const NotificationText testInstant = (
    title: 'Test notification 🔔',
    body: 'If you see this, notifications are allowed on this device.',
  );

  static const NotificationText testScheduled = (
    title: 'Scheduled test ✅',
    body: 'This came through the alarm scheduler, so your reminders will arrive too.',
  );
}
