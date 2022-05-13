import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/customlist.dart';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({Key? key}) : super(key: key);

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  bool _toggled = false;

  @override
  void initState() {
    super.initState();
    getSwitchValues();
  }

  getSwitchValues() async {
    _toggled = await getSwitchState();
    setState(() {});
  }

  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("notification", value);
    return prefs.setBool("notification", value);
  }

  Future<bool> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? _toggled = prefs.getBool("notification");

    return _toggled ?? true;
  }

  bool isSwitched = false;
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
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Settings',
            style: TextStyle(
              fontFamily: 'assets/fonts/Inter-Medium.ttf',
              fontSize: 32,
              color: Color(0xffB4AFEF),
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 28,
              color: Color(0xffB4AFEF),
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            height: height,
            width: width,
            child: Column(
              children: [
                Column(
                  children: [
                    SwitchListTile(
                      activeTrackColor: Color(0xff8A53EA),
                      activeColor: Colors.white,
                      title: const Text(
                        'Notifications',
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Poppins',
                            color: Colors.white),
                      ),
                      secondary: const Icon(
                        FontAwesomeIcons.solidBell,
                        color: Colors.white,
                      ),
                      value: _toggled,
                      onChanged: (bool value) {
                        setState(() {
                          _toggled = value;
                          saveSwitchState(value);
                          if (_toggled == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'App need to Restart to see the Changes',
                                  style: TextStyle(fontFamily: 'Poppins'),
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'App need to Restart to see the Changes',
                                  style: TextStyle(fontFamily: 'Poppins'),
                                ),
                              ),
                            );
                          }
                        });
                      },
                    ),
                    CustomListTile(
                      titleNew: 'Share',
                      leadingNew: FontAwesomeIcons.shareNodes,
                      ontapNew: () {
                        Share.share(
                          'Hey, Enjoy your favourite songs with RythmBeatz',
                        );
                      },
                    ),
                    CustomListTile(
                      titleNew: 'Privacy Policy',
                      leadingNew: FontAwesomeIcons.lock,
                      ontapNew: () {},
                    ),
                    CustomListTile(
                      titleNew: 'Terms & Conditions',
                      leadingNew: FontAwesomeIcons.book,
                      ontapNew: () {},
                    ),
                    CustomListTile(
                      titleNew: 'About',
                      leadingNew: FontAwesomeIcons.circleInfo,
                      ontapNew: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Rhythm Beatz',
                          applicationVersion: '2.10.0',
                          children: [
                            const Text(
                              "Rhythm Beatz is an Offline Music Player Created by James Dominic.",
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                          ],
                          applicationIcon: SizedBox(
                            height: 47,
                            width: 47,
                            child: Image.asset(
                                "assets/Images/RhythmBeatz logo.jpg"),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
