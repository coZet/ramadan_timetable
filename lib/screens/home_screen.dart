import 'package:flutter/material.dart';
import '../services/data_service.dart';
import 'day_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<List<Map<String, dynamic>>> _loadData() async {
    final data = await DataService.loadRamadanData();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ramadan Timetable'),
        actions: [
          IconButton(
            icon: const Icon(Icons.coffee),
            onPressed: () {
              // Buy Me a Coffee (later)
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // About (later)
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading data\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final days = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final d = days[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DayDetailScreen(
                          day: d['day'],
                          date: d['date'],
                          sehri: d['sehri'],
                          iftar: d['iftar'],
                          prayers:
                              Map<String, String>.from(d['prayers']),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Day ${d['day']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(d['date']),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Sehri: ${d['sehri']}'),
                            Text('Iftar: ${d['iftar']}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
