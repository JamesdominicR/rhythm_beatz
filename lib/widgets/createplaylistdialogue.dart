import 'package:flutter/material.dart';
import 'package:music_songs/database/songmodel_adapter.dart';

class CreatePlaylist extends StatefulWidget {
  CreatePlaylist({Key? key}) : super(key: key);

  @override
  State<CreatePlaylist> createState() => _CreatePlaylistState();
}

class _CreatePlaylistState extends State<CreatePlaylist> {
  List<MusicSongs> playlists = [];

  final box = MusicBox.getInstance();

  String? title;

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: Border.all(
        width: 4,
        color: Colors.white,
      ),
      backgroundColor: Color(0xffB4AFEF),
      child: SizedBox(
        height: 200,
        width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                right: 20,
                left: 20,
                top: 20,
              ),
              child: Text(
                "Add a name to playlist.",
                style: TextStyle(
                    color: Colors.black, fontSize: 18, fontFamily: 'Poppins'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 10,
              ),
              child: Form(
                key: formkey,
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  cursorHeight: 25,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                  onChanged: (value) {
                    title = value.trim();
                  },
                  validator: (value) {
                    List keys = box.keys.toList();
                    if (value!.trim() == "") {
                      return "name required";
                    }
                    if (keys
                        .where((element) => element == value.trim())
                        .isNotEmpty) {
                      return "this name already exits";
                    }
                    return null;
                  },
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15,
                      top: 5,
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'Poppins'),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15,
                      top: 5,
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          box.put(title, playlists);
                          Navigator.pop(context);
                          setState(() {});
                        }
                      },
                      child: const Center(
                        child: Text(
                          "Create",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
