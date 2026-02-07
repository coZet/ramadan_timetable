class PrayerAdjustment {
  final String date;      // yyyy-MM-dd
  final String prayer;    // fajr, dhuhr, asr, maghrib, isha
  int offsetMinutes;      // + / -

  PrayerAdjustment({
    required this.date,
    required this.prayer,
    required this.offsetMinutes,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'prayer': prayer,
        'offsetMinutes': offsetMinutes,
      };

  factory PrayerAdjustment.fromJson(Map<String, dynamic> json) {
    return PrayerAdjustment(
      date: json['date'],
      prayer: json['prayer'],
      offsetMinutes: json['offsetMinutes'],
    );
  }
}
