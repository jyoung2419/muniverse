import 'package:flutter/material.dart';
import '../../models/ticket/user_pass_model.dart';
import '../common/dotted_divider.dart';

class UserPassCardList extends StatelessWidget {
  final List<UserPassModel> passes;

  const UserPassCardList({super.key, required this.passes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: passes.map((pass) {
        final hasLive = pass.hasLive;
        final hasVod = pass.hasVod;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 이미지
                      Container(
                        width: 160,
                        height: 100,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(pass.productImageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // 텍스트 + 버튼
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pass.eventName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(pass.passName,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12)),
                            const SizedBox(height: 8),
                            const DottedDivider(),
                            Row(
                              children: [
                                if (hasLive) _buildActionButton('LIVE'),
                                if (hasLive && hasVod) const SizedBox(width: 6),
                                if (hasVod) _buildActionButton('VOD'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: TextEditingController(text: pass.pinNumber),
                    readOnly: true,
                    style: const TextStyle(
                      color: Color(0xFFEFEFEF),
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      filled: true,
                      fillColor: Color(0xFF1A1A1A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Divider(color: Color(0xFF2B2B2B)), // 리스트 간 구분선
          ],
        );
      }).toList(),
    );
  }

  Widget _buildActionButton(String label) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2EFFAA),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(40, 25),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }
}
