import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

class DayDetailScreen extends StatefulWidget {
  final int day;
  final String date;
  final String sehri;
  final String iftar;
  final Map<String, String> prayers;

  const DayDetailScreen({
    super.key,
    required this.day,
    required this.date,
    required this.sehri,
    required this.iftar,
    required this.prayers,
  });

  @override
  State<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends State<DayDetailScreen> {
  final Map<String, int> _offsets = {};
  final Map<String, bool> _alarms = {};

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

Future<void> _loadPrefs() async {
  final prefs = await SharedPreferences.getInstance();

  for (final key in widget.prayers.keys) {
    _offsets[key] =
        prefs.getInt('${widget.date}_${key}_offset') ?? 0;

    _alarms[key] =
        prefs.getBool('${widget.date}_${key}_alarm') ?? false;
  }

  setState(() {});
}


  Future<void> _saveOffset(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${widget.date}_${key}_offset', value);
  }


  Future<void> _saveAlarm(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${widget.date}_${key}_alarm', value);
  }


  String _adjustTime(String time, int offset) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final dt = DateTime(2026, 1, 1, hour, minute)
        .add(Duration(minutes: offset));

    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  int _alarmId(String key) {
    switch (key) {
      case 'fajr':
        return 100;
      case 'dhuhr':
        return 101;
      case 'asr':
        return 102;
      case 'maghrib':
        return 103;
      case 'isha':
        return 104;
      default:
        return 999;
    }
  }

  Future<void> _toggleAlarm(String key) async {
    final enabled = !(_alarms[key] ?? false);
    _alarms[key] = enabled;
    await _saveAlarm(key, enabled);

    if (!enabled) {
      await NotificationService.cancel(_alarmId(key));
      setState(() {});
      return;
    }

    final adjusted =
        _adjustTime(widget.prayers[key]!, _offsets[key] ?? 0);
    final parts = adjusted.split(':');

    final date = DateTime.parse(widget.date);
    final alarmTime = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );

    await NotificationService.scheduleAlarm(
      id: _alarmId(key),
      title: '${key.toUpperCase()} Prayer',
      body: 'Time for ${key.toUpperCase()} prayer',
      dateTime: alarmTime,
      isFajr: key == 'fajr',
    );

    setState(() {});
  }

  Widget _prayerRow(String key, String time) {
    final offset = _offsets[key] ?? 0;
    final adjusted = _adjustTime(time, offset);
    final alarmOn = _alarms[key] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  key.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Time: $adjusted'),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    _offsets[key] = offset - 1;
                    _saveOffset(key, _offsets[key]!);
                    setState(() {});
                  },
                ),
                Text('$offset m'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _offsets[key] = offset + 1;
                    _saveOffset(key, _offsets[key]!);
                    setState(() {});
                  },
                ),
                IconButton(
                  icon: Icon(
                    alarmOn
                        ? Icons.notifications_active
                        : Icons.notifications_none,
                    color: alarmOn ? Colors.green : Colors.grey,
                  ),
                  onPressed: () => _toggleAlarm(key),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Day ${widget.day}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${widget.date}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Sehri'),
                trailing: Text(widget.sehri),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Iftar'),
                trailing: Text(widget.iftar),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Prayer Times',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...widget.prayers.entries
                .map((e) => _prayerRow(e.key, e.value))
                .toList(),
          ],
        ),
      ),
    );
  }
}
