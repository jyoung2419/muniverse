import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../muniverse_text.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final bool showMenu;

  const Header({super.key, this.height = kToolbarHeight, this.showMenu = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xB2111111),
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: TextButton(
            onPressed: () {
              // TODO: 언어 변경 기능 연결
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(40, 32),
            ),
            child: Text(
              'LAN',
              style: GoogleFonts.kodchasan(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      title: GestureDetector(
        onTap: () {
          final currentRoute = ModalRoute.of(context)?.settings.name;
          if (currentRoute != '/home') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
                  (route) => false,
            );
          }
        },
        child: const MuniverseText(fontSize: 24),
      ),

      actions: showMenu
          ? [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ]
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
