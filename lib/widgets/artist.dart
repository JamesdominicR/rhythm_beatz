import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:music_songs/main.dart';
import 'listartistsongs.dart';

class Artist extends StatelessWidget {
  const Artist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: allArtists.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ListArtistSongs(
                            newIndex: index, //artist name
                            ArtistName: allArtists[index].artist,
                          ))));
            },
            title: Text(
              allArtists[index].artist,
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(
              Icons.navigate_next,
              color: Colors.white,
            ),
          );
        });
  }
}
