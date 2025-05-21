import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../providers/vote/vote_detail_provider.dart';

class VoteDetailInfoTab extends StatelessWidget {
  final String voteCode;
  const VoteDetailInfoTab({super.key, required this.voteCode});

  @override
  Widget build(BuildContext context) {
    final content = context.watch<VoteDetailProvider>().voteDetail?.detailContent.content ?? '';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Html(
            data: content,
            style: {
              "*": Style(color: Colors.white),
              "body": Style(
                color: Colors.white70,
                lineHeight: LineHeight(1.2),
              ),
              "li": Style(color: Colors.white),
              "p": Style(color: Colors.white),
              "h1": Style(color: Colors.white, fontSize: FontSize(14), fontWeight: FontWeight.w600, margin: Margins.zero),
              "h2": Style(color: Colors.white, fontSize: FontSize(12), fontWeight: FontWeight.w600, margin: Margins.zero),
              "h3": Style(color: Colors.white, fontSize: FontSize(10), fontWeight: FontWeight.w600, margin: Margins.zero),
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
