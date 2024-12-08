import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:mzn_news/consts/colors.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: lightWhite),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Image.asset(
                    'assets/images/newspaper.png',
                    height: 60,
                    width: 60,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: Text(
                    'MZN News',
                    style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 20, letterSpacing: 0.6)),
                  ),
                ),
              ],
            ),
          ),
          ListTiles(
            labelName: 'Home',
            iconName: IconlyBold.home,
            listClick: () {},
          ),
          ListTiles(
            labelName: 'Bookmarks',
            iconName: IconlyBold.bookmark,
            listClick: () {},
          ),
        ],
      ),
    );
  }
}

class ListTiles extends StatelessWidget {
  const ListTiles({
    required this.labelName,
    required this.listClick,
    required this.iconName,
    super.key,
  });

  final String labelName;
  final Function listClick;
  final IconData iconName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconName),
      title: Text(
        labelName,
        style: const TextStyle(fontSize: 20),
      ),
      onTap: () {
        listClick();
      },
    );
  }
}
