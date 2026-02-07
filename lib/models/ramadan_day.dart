class RamadanDay {
  final int day;
  final DateTime date;
  final String sehri;
  final String iftar;
  final Map<String, String> prayers;

  RamadanDay({
    required this.day,
    required this.date,
    required this.sehri,
    required this.iftar,
    required this.prayers,
  });

  factory RamadanDay.fromJson(Map<String, dynamic> json) {
    return RamadanDay(
      day: json['day'],
      date: DateTime.parse(json['date']),
      sehri: json['sehri'],
      iftar: json['iftar'],
      prayers: Map<String, String>.from(json['prayers']),
    );
  }

  String get dateString {
    return "${date.year}-${_two(date.month)}-${_two(date.day)}";
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
}
