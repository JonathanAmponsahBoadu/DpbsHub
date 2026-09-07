import '../../data/local/database.dart';

/// Builds an outbound link to the official jw.org reading page for a reference,
/// in the given language. This is pure navigation — the app never fetches or
/// parses jw.org content, it just hands you off to it in the browser.
///
/// English slugs follow jw.org's confirmed `/en/library/bible/nwt/books/<slug>/<chapter>/`
/// pattern with a `#v<book><chapter><verse>` anchor for verse-level highlighting.
/// Twi uses the confirmed `/tw/nhomakorabea/bible/nwt/nhoma/<slug>/<chapter>/` pattern.
///
/// Unverified per-book slugs (see [Book.slugEnVerified] / [Book.slugTwVerified])
/// fall back to the language's Bible book-index page instead of guessing wrong.
String buildJwOrgLink(Book book, int chapter, {int? verse, required String language}) {
  if (language == 'tw') {
    if (!book.slugTwVerified || book.slugTw.isEmpty) {
      return 'https://www.jw.org/tw/nhomakorabea/bible/nwt/';
    }
    return 'https://www.jw.org/tw/nhomakorabea/bible/nwt/nhoma/${book.slugTw}/$chapter/';
  }

  if (!book.slugEnVerified) {
    return 'https://www.jw.org/en/library/bible/nwt/books/';
  }
  final anchor = verse != null
      ? '#v${book.id.toString().padLeft(2, '0')}'
          '${chapter.toString().padLeft(3, '0')}'
          '${verse.toString().padLeft(3, '0')}'
      : '';
  return 'https://www.jw.org/en/library/bible/nwt/books/${book.slugEn}/$chapter/$anchor';
}

/// A book's jw.org overview page (no chapter) — used on the chapter-grid
/// screen so there's a pointer at the book level, not just per-chapter.
String buildJwOrgBookLink(Book book, {required String language}) {
  if (language == 'tw') {
    if (!book.slugTwVerified || book.slugTw.isEmpty) {
      return 'https://www.jw.org/tw/nhomakorabea/bible/nwt/';
    }
    return 'https://www.jw.org/tw/nhomakorabea/bible/nwt/nhoma/${book.slugTw}/';
  }
  if (!book.slugEnVerified) {
    return 'https://www.jw.org/en/library/bible/nwt/books/';
  }
  return 'https://www.jw.org/en/library/bible/nwt/books/${book.slugEn}/';
}

/// The whole-Bible jw.org library root — used on the main Bible (book list)
/// screen so there's a pointer even before you've picked a book.
String buildJwOrgLibraryLink({required String language}) {
  return language == 'tw'
      ? 'https://www.jw.org/tw/nhomakorabea/bible/nwt/'
      : 'https://www.jw.org/en/library/bible/nwt/books/';
}
