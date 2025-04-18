import 'package:flutter/material.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '공지사항',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(
              color: Color(0xFF2EFFAA),
              thickness: 1.5,
              height: 1,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: noticeData.length,
                itemBuilder: (context, index) {
                  final notice = noticeData[index];
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
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const BackFAB(),
    );
  }
}
