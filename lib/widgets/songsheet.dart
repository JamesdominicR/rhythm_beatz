import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../database/songmodel_adapter.dart';

class SongSheet extends StatefulWidget {
  String playlistName;
  SongSheet({Key? key, required this.playlistName}) : super(key: key);

  @override
  State<SongSheet> createState() => _SongSheetState();
}

class _SongSheetState extends State<SongSheet> {
  final box = MusicBox.getInstance();

  List<MusicSongs> dbSongs = [];
  List<MusicSongs> playlistSongs = [];
  @override
  void initState() {
    super.initState();
    fullSongs();
  }

  fullSongs() {
    dbSongs = box.get("musics") as List<MusicSongs>;
    playlistSongs = box.get(widget.playlistName)!.cast<MusicSongs>();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dbSongs.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: SizedBox(
              height: 50,
              width: 50,
              child: QueryArtworkWidget(
                id: dbSongs[index].id!,
                type: ArtworkType.AUDIO,
                artworkBorder: BorderRadius.circular(15),
                artworkFit: BoxFit.cover,
                nullArtworkWidget: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                      image: AssetImage("assets/Images/Image 4.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              dbSongs[index].title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            subtitle: Text(
              dbSongs[index].artist!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            trailing: playlistSongs
                    .where((element) =>
                        element.id.toString() == dbSongs[index].id.toString())
                    .isEmpty
                ? IconButton(
                    onPressed: () async {
                      playlistSongs.add(dbSongs[index]);
                      await box.put(widget.playlistName, playlistSongs);

                      setState(() {});
                    },
                    icon: const Icon(Icons.add))
                : IconButton(
                    onPressed: () async {
                      playlistSongs.removeWhere((elemet) =>
                          elemet.id.toString() == dbSongs[index].id.toString());

                      await box.put(widget.playlistName, playlistSongs);
                      setState(() {});
                    },
                    icon: const Icon(Icons.check_box),
                  ),
          ),
        );
      },
    );
  }
}
