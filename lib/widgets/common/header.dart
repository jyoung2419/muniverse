import 'package:flutter/material.dart';
import '../muniverse_logo.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
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
  State<Header> createState() => _HeaderState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _HeaderState extends State<Header> {
  String selectedLanguage = '한국어';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 120,
      backgroundColor: widget.isHome ? Colors.transparent : const Color(0xFF0B0C0C),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      flexibleSpace: widget.isHome
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
      actions: widget.showMenu
          ? [
        PopupMenuButton<String>(
          onSelected: (value) {
            setState(() {
              selectedLanguage = value;
            });
            print('선택된 언어: $value');
            // TODO: 선택된 언어값 → Provider or Global 변수에 저장 가능
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: '한국어',
              child: Text('한국어', style: TextStyle(color: Colors.white)),
            ),
            const PopupMenuItem(
              value: 'English',
              child: Text('English', style: TextStyle(color: Colors.white)),
            ),
            const PopupMenuItem(
              value: '日本語',
              child: Text('日本語', style: TextStyle(color: Colors.white)),
            ),
            const PopupMenuItem(
              value: '简体中文',
              child: Text('简体中文', style: TextStyle(color: Colors.white)),
            ),
            const PopupMenuItem(
              value: '繁體中文',
              child: Text('繁體中文', style: TextStyle(color: Colors.white)),
            ),
          ],
          child: Text(
            selectedLanguage,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          color: const Color(0xFF212225),
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
}
