enum LineType {
  surahName,
  basmallah,
  ayah;

  static LineType fromDb(String value) => switch (value) {
    'surah_name' => surahName,
    'basmallah' => basmallah,
    'ayah' => ayah,
    _ => throw StateError('Unknown line_type: $value'),
  };
}