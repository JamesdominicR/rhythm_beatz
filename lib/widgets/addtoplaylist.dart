import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_songs/database/songmodel_adapter.dart';

import 'createplaylistdialogue.dart';

class AddtoPlayList extends StatelessWidget {
  AddtoPlayList({Key? key, required this.song}) : super(key: key);
  MusicSongs song;

  List playlists = [];
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
              onTap: () => showDialog(
                context: context,
                builder: (context) => CreatePlaylist(),
              ),
              leading: const Icon(
                FontAwesomeIcons.plus,
              ),
              title: const Text(
                "Add a New Playlist",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          ...playlists
              .map(
                (audio) => audio != "musics" && audio != 'favourites'
                    ? ListTile(
                        onTap: () async {
                          playlistSongs = box.get(audio);
                          List existingSongs = [];
                          existingSongs = playlistSongs!
                              .where((element) =>
                                  element.id.toString() == song.id.toString())
                              .toList();
                          if (existingSongs.isEmpty) {
                            final songs = box.get("musics") as List<MusicSongs>;
                            final temp = songs.firstWhere((element) =>
                                element.id.toString() == song.id.toString());
                            playlistSongs?.add(temp);

                            await box.put(audio, playlistSongs!);

                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                song.title! + ' Added to Playlist',
                                style: const TextStyle(fontFamily: 'Poppins'),
                              ),
                            ));
                          } else {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  song.title! + ' is already in Playlist.',
                                  style: const TextStyle(fontFamily: 'Poppins'),
                                ),
                              ),
                            );
                          }
                        },
                        leading: const Icon(Icons.queue_music),
                        title: Text(
                          audio.toString(),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22,
                          ),
                        ),
                      )
                    : Container(),
              )
              .toList()
        ],
      ),
    );
  }
}
