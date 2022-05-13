import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import '../database/songmodel_adapter.dart';
import 'addtoplaylist.dart';

class MusicListMenu extends StatelessWidget {
  final String songID;
  MusicListMenu({Key? key, required this.songID}) : super(key: key);

  final box = MusicBox.getInstance();
  List<MusicSongs> dbSongs = [];
  List<Audio> fullSongs = [];

  @override
  Widget build(BuildContext context) {
    dbSongs = box.get("musics") as List<MusicSongs>;
    List? favourites = box.get("favourites");
    final temp = databaseSongs(dbSongs, songID);
    return PopupMenuButton(
      child: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      itemBuilder: (BuildContext bc) => [
        favourites!
                .where((element) => element.id.toString() == temp.id.toString())
                .isEmpty
            ? PopupMenuItem(
                onTap: () async {
                  favourites.add(temp);
                  await box.put("favourites", favourites);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        temp.title! + " Added to Favourites",
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Add to Favourite",
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              )
            : PopupMenuItem(
                onTap: () async {
                  favourites.removeWhere(
                      (element) => element.id.toString() == temp.id.toString());
                  await box.put("favourites", favourites);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        temp.title! + " Removed from Favourites",
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Remove From Favourite",
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              ),
        const PopupMenuItem(
          child: Text(
            "Add to Playlist",
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          value: "1",
        ),
      ],
      onSelected: (value) async {
        if (value == "1") {
          showModalBottomSheet(
            context: context,
            builder: (context) => AddtoPlayList(song: temp),
          );
        }
      },
    );
  }

  MusicSongs databaseSongs(List<MusicSongs> songs, String id) {
    return songs.firstWhere(
      (element) => element.id.toString().contains(id),
    );
  }
}
