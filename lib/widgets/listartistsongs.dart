import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_songs/main.dart';
import 'package:music_songs/open_audio.dart';
import 'package:music_songs/screens/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../database/songmodel_adapter.dart';

class ListArtistSongs extends StatefulWidget {
  final int newIndex;
  final String ArtistName;
  const ListArtistSongs(
      {Key? key, required this.newIndex, required this.ArtistName})
      : super(key: key);

  @override
  State<ListArtistSongs> createState() => _ListArtistSongsState();
}

class _ListArtistSongsState extends State<ListArtistSongs> {
  final box = MusicBox.getInstance();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
          title: Text(
            widget.ArtistName,
          ),
          elevation: 0.0,
        ),
        body: ListView(
          children: [
            ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, value, child) {
                  // Set<Audio> allArtistSongs = {};
                  Set<Audio> allArtistSongsAudio = {};
                  List<Audio> allArtistSongs = [];
                  for (var song in databaseAudioList) {
                    if (song.metas.artist == widget.ArtistName) {
                      allArtistSongsAudio.add(Audio.file(
                        song.metas.artist.toString(),
                        metas: Metas(
                          title: song.metas.title,
                          artist: song.metas.artist,
                          id: song.metas.id.toString(),
                        ),
                      ));
                    }
                  }
                  allArtistSongs = allArtistSongsAudio.toList();
                  // return ListView.separated(
                  //   physics: NeverScrollableScrollPhysics(),
                  //   shrinkWrap: true,
                  //   itemBuilder: (context, index) {
                  //     return ListTile(
                  //       leading: CircleAvatar(backgroundColor: Colors.green),
                  //       title: Text('Hai'),
                  //     );
                  //   },
                  //   itemCount: 10,
                  //   separatorBuilder: (context, index) {
                  //     return SizedBox(
                  //       height: 15,
                  //     );
                  //   },
                  // );
                  return ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      print('${allArtistSongsAudio.length} ahahhahahah');
                      return GestureDetector(
                        // onTap: () => {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: ((context) => ScreenPlaying(
                        //           audiosongs: databaseAudioList,
                        //           index:
                        //           ?allArtistSongs[index].metas.id,

                        //         )),
                        //   ),

                        // ),
                        // },
                        child: ListTile(
                          leading: SizedBox(
                            height: 43,
                            width: 43,
                            child: QueryArtworkWidget(
                              id: int.parse(allArtists[index].id.toString()),
                              type: ArtworkType.AUDIO,
                              artworkBorder:
                                  BorderRadius.all(Radius.circular(7)),
                              artworkFit: BoxFit.fill,
                              nullArtworkWidget: Container(
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  image: DecorationImage(
                                    image:
                                        AssetImage("assets/Images/Image 4.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            allArtistSongs[index].metas.title.toString(),
                            style: TextStyle(color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            allArtistSongs[index].metas.title.toString(),
                            style: TextStyle(color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // trailing: PopupMenuButton(
                          //   icon: Icon(
                          //     Icons.more_vert_outlined,
                          //     color: Colors.white,
                          //   ),
                          //   itemBuilder: (BuildContext context) => [
                          //     const PopupMenuItem(
                          //       value: "1",
                          //       child: Text(
                          //         "Remove song",
                          //         style: TextStyle(
                          //           color: Colors.black,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          //   onSelected: (value) {
                          //     if (value == "1") {
                          //       setState(() {});
                          //     }
                          //   },
                          // ),
                        ),
                      );
                    },
                    itemCount: allArtistSongs.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 15,
                      );
                    },
                  );
                }),
          ],
        ),
      ),
    );
  }
}
