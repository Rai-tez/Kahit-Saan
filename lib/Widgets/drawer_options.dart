import 'package:flutter/material.dart';
import 'package:kahit_saan/Constants/constants.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:kahit_saan/Widgets/pop_up.dart';

class DrawerOptions extends StatelessWidget {
  DrawerOptions(
      {required this.text, required this.onPressed, required this.icon});

  final Icon icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: icon,
      title: Text(
        "$text",
        style: kdrawerOptions,
      ),
    );
  }
}

class DrawerMenu extends StatelessWidget {
  // AudioPlayer
  final audioPlayer = new AudioPlayer();

  void playSound(String name) {
    AudioCache player = new AudioCache(fixedPlayer: audioPlayer);
    player.play(name);
  }

  @override
  Widget build(BuildContext context) {
    double icon_width = MediaQuery.of(context).size.height;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(0),
            decoration: const BoxDecoration(
              color: kyellow,
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "images/watermark.png",
                    color: kbrown,
                  )
                ),
              ],
            )
          ),
          DrawerOptions(
            text: "Settings",
            icon: Icon(Icons.settings),
            onPressed: () {
              playSound('all.wav');
            },
          ),
          DrawerOptions(
            text: "About Us",
              icon: Icon(Icons.people),
              onPressed: () {
                playSound('all.wav');
              }
          ),
          DrawerOptions(
            text: "User Guide",
            icon: Icon(Icons.info),
            onPressed: () {
              playSound('all.wav');
            }
          ),
          DrawerOptions(
            text: "Send Feedback",
            icon: Icon(Icons.reviews),
            onPressed: () {
              playSound('all.wav');
            }
          ),
          DrawerOptions(
            text: "Go Back",
            icon: Icon(Icons.arrow_right_alt_outlined),
            onPressed: () {
              playSound('all.wav');
              Navigator.pop(context);
            }
          ),
        ],
      ),
    );
  }
}
