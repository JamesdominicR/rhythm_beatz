import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_songs/database/songmodel_adapter.dart';
import 'package:music_songs/open_audio.dart';
import 'package:music_songs/screens/now_playing.dart';
import 'package:music_songs/widgets/songsheet.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistScreen extends StatefulWidget {
  String PlaylistName;
  PlaylistScreen({Key? key, required this.PlaylistName}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final box = MusicBox.getInstance();
  List<MusicSongs>? dbSongs = [];
  List<MusicSongs>? playlistSongs = [];
  List<Audio> playPlaylist = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xff29225a), Color(0xff2b234e)])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(widget.PlaylistName),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      return SongSheet(
                        playlistName: widget.PlaylistName,
                      );
                    },
                  );
                },
                icon: const Icon(FontAwesomeIcons.plus),
              ),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, value, child) {
                  var playlistSongs = box.get(widget.PlaylistName)!;
                  return playlistSongs.isEmpty
                      ? const SizedBox(
                          child: Center(
                            child: Text(
                              "Add Some Songs!",
                              style: TextStyle(
                                  fontFamily: 'Poppins', fontSize: 25),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: playlistSongs.length,
                          itemBuilder: (context, index) => GestureDetector(
                            child: ListTile(
                              leading: QueryArtworkWidget(
                                id: playlistSongs[index].id!,
                                type: ArtworkType.AUDIO,
                                artworkBorder: BorderRadius.circular(15),
                                artworkFit: BoxFit.cover,
                                nullArtworkWidget: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        15,
                                      ),
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/Images/Image 4.jpg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                playlistSongs[index].title!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                playlistSongs[index].artist!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                              ),
                              trailing: PopupMenuButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                                itemBuilder: (BuildContext context) => [
                                  const PopupMenuItem(
                                    value: "1",
                                    child: Text(
                                      "Remove song",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == "1") {
                                    setState(() {
                                      playlistSongs.removeAt(index);
                                      box.put(
                                          widget.PlaylistName, playlistSongs);
                                    });
                                  }
                                },
                              ),
                            ),
                            onTap: () {
                              for (var element in playlistSongs) {
                                playPlaylist.add(
                                  Audio.file(
                                    element.uri!,
                                    metas: Metas(
                                      title: element.title,
                                      id: element.id.toString(),
                                      artist: element.artist,
                                    ),
                                  ),
                                );
                              }
                              OpenAssetAudio(
                                      allsong: playPlaylist, index: index)
                                  .openAsset(
                                      index: index, audios: playPlaylist);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScreenPlaying(
                                    audiosongs: playPlaylist,
                                    index: index,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
