import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import '../database/songmodel_adapter.dart';
import '../screens/favourites.dart';
import '../screens/playlistscreen.dart';
import 'createplaylistdialogue.dart';
import 'customlist.dart';
import 'customplaylist.dart';
import 'editplaylistname.dart';

class LibraryPlaylist extends StatefulWidget {
  const LibraryPlaylist({Key? key}) : super(key: key);

  @override
  State<LibraryPlaylist> createState() => _LibraryPlaylistState();
}

class _LibraryPlaylistState extends State<LibraryPlaylist> {
  final box = MusicBox.getInstance();
  List playlists = [];
  String? playlistName = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        height: height,
        width: width,
        child: Column(
          children: [
            Column(
              children: [
                CustomListTile(
                  titleNew: 'Create Playlist',
                  leadingNew: FontAwesomeIcons.squarePlus,
                  ontapNew: () {
                    showDialog(
                      context: context,
                      builder: (context) => CreatePlaylist(),
                    );
                  },
                ),
                CustomListTile(
                  titleNew: 'Favourites',
                  leadingNew: FontAwesomeIcons.heart,
                  ontapNew: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Favourites(),
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, boxes, _) {
                  playlists = box.keys.toList();
                  return ListView.builder(
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: playlists[index] != "musics" &&
                                playlists[index] != "favourites"
                            ? CustomPlayList(
                                titleNew: playlists[index].toString(),
                                leadingNew: Icons.queue_music,
                                trailingNew: PopupMenuButton(
                                  child: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      child: Text(
                                        'Remove Playlist',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Poppins'),
                                      ),
                                      value: "0",
                                    ),
                                    const PopupMenuItem(
                                      value: "1",
                                      child: Text(
                                        "Rename Playlist",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Poppins'),
                                      ),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    if (value == "0") {
                                      box.delete(playlists[index]);
                                      setState(() {
                                        playlists = box.keys.toList();
                                      });
                                      // Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Playlist Removed'),
                                        ),
                                      );
                                    }
                                    if (value == "1") {
                                      showDialog(
                                        context: context,
                                        builder: (context) => EditPlaylist(
                                          playlistName: playlists[index],
                                        ),
                                      );
                                    }
                                  },
                                ),
                                ontapNew: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlaylistScreen(
                                        PlaylistName: playlists[index],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
