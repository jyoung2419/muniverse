import 'package:flutter/material.dart';
import '../muniverse_logo.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final bool showMenu;
  final bool isHome;

  const Header({
    super.key,
    this.height = kToolbarHeight,
    this.showMenu = true,
    this.isHome = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 120,
      backgroundColor: isHome ? Colors.transparent : const Color(0xFF0B0C0C),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      flexibleSpace: isHome
          ? ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white54,
              Colors.transparent,
            ],
            stops: [0.8, 0.9, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: Container(color: const Color(0xFF0B0C0C)),
      )
          : null,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/voteMainScreen');
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 32),
              ),
              child: const Text(
                '투표',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/storeMainScreen');
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 32),
              ),
              child: const Text(
                '스토어',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      title: GestureDetector(
        onTap: () {
          final currentRoute = ModalRoute.of(context)?.settings.name;
          if (currentRoute != '/home') {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }
        },
        child: const MuniverseLogo(),
      ),
      actions: showMenu
          ? [
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(40, 32),
          ),
          child: const Text(
            '한국어',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      ]
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
