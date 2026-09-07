enum AiProvider {
  gemini,
  groq;

  String get displayName => switch (this) {
        AiProvider.gemini => 'Gemini',
        AiProvider.groq => 'Groq',
      };

  String get setupUrl => switch (this) {
        AiProvider.gemini => 'https://aistudio.google.com/apikey',
        AiProvider.groq => 'https://console.groq.com/keys',
      };
}
