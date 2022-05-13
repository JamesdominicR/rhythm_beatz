import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_songs/database/songmodel_adapter.dart';
import 'package:music_songs/widgets/createplaylistdialogue.dart';

class BuildSheet extends StatelessWidget {
  BuildSheet({Key? key, required this.song}) : super(key: key);
  Audio song;
  List playlists = [];
  String? playlistName = '';
  List<dynamic>? playlistSongs = [];

  @override
  Widget build(BuildContext context) {
    final box = MusicBox.getInstance();
    playlists = box.keys.toList();
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
            child: ListTile(
              onTap: () => {
                showDialog(
                  context: context,
                  builder: (context) => CreatePlaylist(),
                ),
              },
              leading: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFF606060),
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                child: const Center(
                    child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                )),
              ),
              title: const Text(
                "Create Playlist",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ...playlists
              .map((e) => e != "musics" && e != "favorites"
                  ? libraryList(
                      child: ListTile(
                      onTap: () async {
                        playlistSongs = box.get(e);
                        List existingSongs = [];
                        existingSongs = playlistSongs!
                            .where((element) =>
                                element.id.toString() ==
                                song.metas.id.toString())
                            .toList();

                        if (existingSongs.isEmpty) {
                          final songs = box.get("musics") as List<MusicSongs>;
                          final temp = songs.firstWhere((element) =>
                              element.id.toString() ==
                              song.metas.id.toString());
                          playlistSongs?.add(temp);

                          await box.put(e, playlistSongs!);

                          // setState(() {});
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('songs added'),
                          ));
                        } else {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Song already exists'),
                          ));
                        }
                      },
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/Images/Image 4.jpg"),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        ),
                      ),
                      title: Text(
                        e.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ))
                  : Container())
              .toList()
        ],
      ),
    );
  }

  Padding libraryList({required child}) {
    return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
        child: child);
  }
}
