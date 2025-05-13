import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/translate_text.dart';
import '../../widgets/info/notice_item.dart';
import '../../providers/notice/notice_provider.dart';
import '../../widgets/common/header.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<NoticeProvider>().fetchNotices());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoticeProvider>();
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final notices = provider.notices;
    final noticeTitle = lang == 'kr' ? '공지사항' : 'NOTICE';
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Text(
                noticeTitle,
                style: TextStyle(
                  color: Color(0xFF2EFFAA),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (provider.notices.isEmpty) {
                    return const Center(
                      child: TranslatedText(
                        '공지사항이 없습니다.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: notices.length,
                    itemBuilder: (context, index) {
                      final notice = notices[index];
                      return NoticeItem(
                        title: notice.title,
                        createDate: notice.createDate,
                        content: notice.content,
                        isExpanded: _expandedIndex == index,
                        onTap: () {
                          setState(() {
                            _expandedIndex = _expandedIndex == index ? null : index;
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const BackFAB(),
    );
  }
}
