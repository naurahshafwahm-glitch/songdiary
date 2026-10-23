import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class Song {
  final String title, artist, mood, language;
  final int duration;
  final bool isFavorite;

  const Song({
    required this.title,
    required this.artist,
    required this.mood,
    required this.language,
    required this.duration,
    this.isFavorite = false,
  });

  Song copyWith({bool? isFavorite}) => Song(
        title: title,
        artist: artist,
        mood: mood,
        language: language,
        duration: duration,
        isFavorite: isFavorite ?? this.isFavorite,
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SongDiary',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFD982A5),
          ),
          scaffoldBackgroundColor: const Color(0xFFFFF8FB),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        home: const SongDiaryPage(),
      );
}

class SongDiaryPage extends StatefulWidget {
  const SongDiaryPage({super.key});

  @override
  State<SongDiaryPage> createState() => _SongDiaryPageState();
}

class _SongDiaryPageState extends State<SongDiaryPage> {
  String mood = 'All', language = 'All';
  bool favoritesOnly = false;

  final List<Song> songs = [
    const Song(title: 'Komang', artist: 'Raim Laode',
        mood: 'In Love', language: 'Indonesia', duration: 225),
    const Song(title: 'Evaluasi', artist: 'Hindia',
        mood: 'Sad', language: 'Indonesia', duration: 220),
    const Song(title: 'Rehat', artist: 'Kunto Aji',
        mood: 'Calm', language: 'Indonesia', duration: 240),
    const Song(title: 'Akad', artist: 'Payung Teduh',
        mood: 'In Love', language: 'Indonesia', duration: 300),
    const Song(title: 'Tak Ingin Usai', artist: 'Keisya Levronka',
        mood: 'Sad', language: 'Indonesia', duration: 270),
    const Song(title: 'ทัก (FIRST SIGHT)', artist: 'LYKN',
        mood: 'Happy', language: 'Thailand', duration: 207),
    const Song(title: 'LYKYOU', artist: 'LYKN',
        mood: 'In Love', language: 'Thailand', duration: 214),
    const Song(title: 'NO WORRIES', artist: 'LYKN',
        mood: 'In Love', language: 'Thailand', duration: 240),
    const Song(title: 'ถ้าเกิด (If Only)', artist: 'LYKN',
        mood: 'Sad', language: 'Thailand', duration: 230),
    const Song(title: 'Love Symptoms', artist: 'William Jakrapatr',
        mood: 'In Love', language: 'Thailand', duration: 220),
  ];

  void toggleFavorite(int index) {
    setState(() {
      songs[index] = songs[index].copyWith(
        isFavorite: !songs[index].isFavorite,
      );
    });
    final song = songs[index];
    debugPrint('Lagu: ${song.title} | '
        'Favorit: ${song.isFavorite}');
  }

  @override
  Widget build(BuildContext context) {
    final filtered = songs.asMap().entries.where((entry) {
      final s = entry.value;
      return (mood == 'All' || s.mood == mood) &&
          (language == 'All' || s.language == language) &&
          (!favoritesOnly || s.isFavorite);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎧 SongDiary',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '♥ ${songs.where((s) => s.isFavorite).length}',
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFE3ED), Color(0xFFDFF1FF)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.music_note, size: 36),
                SizedBox(height: 8),
                Text('What is your mood today?',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Text('Find a song that feels like you.'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Choose your mood',
              style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 6,
            children: ['All', 'Happy', 'Sad', 'Calm', 'In Love']
                .map((m) => ChoiceChip(
                      label: Text(m),
                      selected: mood == m,
                      onSelected: (_) {
                        setState(() => mood = m);
                        debugPrint('Filter mood: $m');
                      },
                    )).toList(),
          ),
          const SizedBox(height: 12),
          const Text('Choose language',
              style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 6,
            children: ['All', 'Indonesia', 'Thailand']
                .map((l) => ChoiceChip(
                      label: Text(l),
                      selected: language == l,
                      onSelected: (_) {
                        setState(() => language = l);
                        debugPrint('Filter bahasa: $l');
                      },
                    )).toList(),
          ),
          FilterChip(
            label: const Text('Favorites only'),
            selected: favoritesOnly,
            onSelected: (v) {
              setState(() => favoritesOnly = v);
              debugPrint('Filter favorit: $v');
            },
          ),
          const SizedBox(height: 12),
          Text(mood == 'All' ? 'Your song collection' : '$mood songs',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('No songs found.'),
            ),
          ...filtered.map((entry) => SongCard(
                song: entry.value,
                onFavorite: () => toggleFavorite(entry.key),
              )),
          const Center(child: Text('Made with love and music ♡')),
        ],
      ),
    );
  }
}

class SongCard extends StatelessWidget {
  final Song song;
  final VoidCallback onFavorite;

  const SongCard({
    super.key,
    required this.song,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFCE1EC), Color(0xFFDFF1FF)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.music_note,
                    color: Color(0xFFD982A5)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(song.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    Text(song.artist),
                    Text('${song.mood} • ${song.language}'),
                    Text('${song.duration ~/ 60}:'
                        '${(song.duration % 60).toString().padLeft(2, '0')}'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onFavorite,
                child: Icon(song.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
              ),
            ],
          ),
        ),
      );
}
