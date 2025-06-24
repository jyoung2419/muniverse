import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muniverse_app/widgets/common/translate_text.dart';
import 'package:provider/provider.dart';
import '../../models/event/main/event_nav_model.dart';
import '../../providers/language_provider.dart';
import '../../providers/translation_provider.dart';
import '../../providers/event/main/event_nav_provider.dart';
import '../../screens/title/title_home_screen.dart';
import '../../utils/shared_prefs_util.dart';
import 'muniverse_logo.dart';

class Header extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final double height;
  final bool showMenu;
  final bool isHome;
  final String? eventCode;

  const Header({
    super.key,
    this.height = kToolbarHeight,
    this.showMenu = true,
    this.isHome = false,
    this.eventCode,
  });

  @override
  ConsumerState<Header> createState() => _HeaderState();

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _HeaderState extends ConsumerState<Header> {
  String? selectedEventName;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(eventNavProvider.notifier).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final navs = ref.watch(eventNavProvider).value ?? [];
    final languageProvider = context.watch<LanguageProvider>();
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final homeText = languageProvider.selectedLanguageCode == 'kr' ? '홈' : 'HOME';

    if (currentRoute == '/home') {
      selectedEventName = homeText;
    }

    if (navs.length > 1) {
      if (widget.isHome) {
        selectedEventName = homeText;
      } else if (widget.eventCode != null) {
        final matched = navs.firstWhere(
              (e) => e.eventCode == widget.eventCode,
          orElse: () => navs[1],
        );
        if (selectedEventName != matched.eventName) {
          selectedEventName = matched.eventName;
        }
      }
    }

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
    leading: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: SizedBox(
          width: 100,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true, // ✅ 추가

              isDense: true,
              value: selectedEventName,
              alignment: Alignment.centerLeft,
              icon: const SizedBox.shrink(),
              dropdownColor: const Color(0xFF212225),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  selectedEventName = value;
                });
                if (value == homeText) {
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                  return;
                }
                final target = navs.firstWhere(
                      (e) => e.eventName == value,
                  orElse: () => EventNavModel(eventName: '', eventCode: ''),
                );
                if (target.eventCode.isNotEmpty) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(arguments: target.eventCode),
                      builder: (_) => TitleHomeScreen(eventCode: target.eventCode),
                    ),
                  );
                }
              },
              selectedItemBuilder: (context) {
                return [
                  DropdownMenuItem<String>(
                    value: homeText,
                    child: Row(
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 100),
                          child: TranslatedText(
                            homeText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.white),
                      ],
                    ),
                  ),
                  ...navs.skip(1).map((e) => DropdownMenuItem<String>(
                    value: e.eventName,
                    child: Row(
                      children: [
                        Expanded( // ✅ 이 부분!
                          child: TranslatedText(
                            e.eventName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.white),
                      ],
                    ),
                  )),
                ];
              },
              items: [
                DropdownMenuItem<String>(
                  value: homeText,
                  child: TranslatedText(
                    homeText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ...navs.skip(1).map((e) => DropdownMenuItem<String>(
                  value: e.eventName,
                  child: TranslatedText(
                    e.eventName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
              ],

            ),
          ),),
        ),
      ),

      title: GestureDetector(
        onTap: () {
          if (currentRoute != '/home') {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }
        },
        child: const MuniverseLogo(),
      ),
      actions: widget.showMenu ? [
        PopupMenuButton<String>(
          onSelected: (value) async {
            String langCode;
            switch (value) {
              case '한국어': langCode = 'kr'; break;
              case 'English': langCode = 'en'; break;
              case '日本語': langCode = 'jp'; break;
              case '简体中文': langCode = 'cn'; break;
              case '繁體中文': langCode = 'tw'; break;
              default: langCode = 'kr';
            }

            context.read<LanguageProvider>().setLanguage(langCode);
            final translationProvider = context.read<TranslationProvider>();
            await SharedPrefsUtil.setAcceptLanguage(langCode);
            translationProvider.clear();
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: '한국어',
              child: Text(
                '한국어',
                style: TextStyle(
                    color: languageProvider.selectedLanguageCode == 'kr'
                        ? Color(0xFF2EFFAA)
                        : Colors.white
                ),
              ),
            ),
            PopupMenuItem(
              value: 'English',
              child: Text(
                'English',
                style: TextStyle(
                    color: languageProvider.selectedLanguageCode == 'en'
                        ? Color(0xFF2EFFAA)
                        : Colors.white
                ),
              ),
            ),
            PopupMenuItem(
              value: '日本語',
              child: Text(
                '日本語',
                style: TextStyle(
                    color: languageProvider.selectedLanguageCode == 'jp'
                        ? Color(0xFF2EFFAA)
                        : Colors.white
                ),
              ),
            ),
            PopupMenuItem(
              value: '简体中文',
              child: Text(
                '简体中文',
                style: TextStyle(
                    color: languageProvider.selectedLanguageCode == 'cn'
                        ? Color(0xFF2EFFAA)
                        : Colors.white
                ),
              ),
            ),
            PopupMenuItem(
              value: '繁體中文',
              child: Text(
                '繁體中文',
                style: TextStyle(
                    color: languageProvider.selectedLanguageCode == 'tw'
                        ? Color(0xFF2EFFAA)
                        : Colors.white
                ),
              ),
            ),
          ],
          child: Text(
            languageProvider.languageText,
            style: const TextStyle(
              color: Colors.white,
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
        )
      ] : null,
    );
  }
}
