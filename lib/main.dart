import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_songs/widgets/bottom_navigation.dart';

import 'package:on_audio_query/on_audio_query.dart';

import 'database/songmodel_adapter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MusicSongsAdapter());
  await Hive.openBox<List>(boxname);
  final box = MusicBox.getInstance();
  List<dynamic> libraryKeys = box.keys.toList();
  if (!(libraryKeys.contains("favourites"))) {
    List<dynamic> likedSongs = [];
    await box.put("favourites", likedSongs);
  }
  runApp(const MyApp());
}

final box = MusicBox.getInstance();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final box = MusicBox.getInstance();
  final assetsAudioPlayer = AssetsAudioPlayer.withId('0');
  List<Audio> audiosongs = [];
  final _audioQuery = OnAudioQuery();

  List<MusicSongs> mappedSongs = [];
  List<MusicSongs> dbSongs = [];
  List<SongModel> fetchedSongs = [];
  @override
  void initState() {
    super.initState();
    fetchSongs();
    fetchArtist();
  }

  //fetch all the artists
  Set<ArtistModel> allArtistsSet = {};
  void fetchArtist() async {
    fetchallArtists = await _audioQuery.queryArtists();
    for (var song in fetchallArtists) {
      if (song.artist != '<unknown>') {
        allArtistsSet.add(song);
      }
    }
    allArtists = allArtistsSet.toList();
  }

  List<SongModel> allsong = [];
  fetchSongs() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }

    allsong = await _audioQuery.querySongs();
    mappedSongs = allsong
        .map((e) => MusicSongs(
            title: e.title,
            id: e.id,
            uri: e.uri!,
            duration: e.duration,
            artist: e.artist))
        .toList();
    await box.put('musics', mappedSongs);
    dbSongs = box.get('musics') as List<MusicSongs>;

    dbSongs.forEach((element) {
      audiosongs.add(
        Audio.file(
          element.uri.toString(),
          metas: Metas(
              title: element.title,
              id: element.id.toString(),
              artist: element.artist),
        ),
      );
    });
    await box.put('musics', mappedSongs);
    recievedDatabaseSongs = box.get('musics') as List<MusicSongs>;

    // convert it to the type Audio
    for (var element in recievedDatabaseSongs) {
      databaseAudioList.add(
        Audio.file(element.uri.toString(),
            metas: Metas(
                title: element.title,
                artist: element.artist,
                id: element.id.toString())),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
        backgroundColor: const Color(0xffD9D8E0),
        duration: 3000,
        splash: Padding(
          padding: EdgeInsets.symmetric(vertical: 120),
          child: Column(children: [
            Image.asset('assets/Images/Rectangle 14.png'),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'R',
                    style: TextStyle(
                      color: Color(0xffEA6553),
                      fontSize: 40,
                      fontFamily: 'Inter-Bold',
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'hythm',
                    style: TextStyle(
                      color: Color(0xff8A53EA),
                      fontSize: 40,
                      fontFamily: 'Inter-Bold',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(
                    text: 'B',
                    style: TextStyle(
                      color: Color(0xffEA6553),
                      fontSize: 40,
                      fontFamily: 'Inter-Bold',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(
                    text: 'eatz',
                    style: TextStyle(
                      color: Color(0xff8A53EA),
                      fontSize: 40,
                      fontFamily: 'Inter-Bold',
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
        splashIconSize: double.infinity,
        nextScreen: BottomNavigationWidget(
          allsong: audiosongs,
        ),
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}

// final mappedSong = box.values.toList().map((e) => );

List<ArtistModel> allArtists = [];
List<ArtistModel> fetchallArtists = [];
List<Audio> databaseAudioList = [];
List<SongModel> fetchedSongs = [];
List<MusicSongs> recievedDatabaseSongs = [];
