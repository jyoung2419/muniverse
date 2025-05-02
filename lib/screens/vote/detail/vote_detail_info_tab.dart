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
              "body": Style(
                color: Colors.white,
              ),
              "li": Style(
                color: Colors.white,
              ),
              "p": Style(
                color: Colors.white,
              ),
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
