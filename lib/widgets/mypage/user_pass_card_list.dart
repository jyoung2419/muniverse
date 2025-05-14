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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    child: Image.network(
                      pass.productImageUrl,
                      width: 160,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pass.eventName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(pass.passName,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 13)),
                        const SizedBox(height: 8),
                        DottedDivider(),
                        const SizedBox(height: 8),
                        TextField(
                          readOnly: true,
                          controller: TextEditingController(text: pass.pinNumber),
                          style: const TextStyle(color: Colors.white54),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF2B2B2B),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
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
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(65, 30),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }
}
