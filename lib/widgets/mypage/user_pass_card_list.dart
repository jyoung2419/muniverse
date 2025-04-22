import 'package:flutter/material.dart';
import '../../models/ticket/user_pass_model.dart';

class UserPassCardList extends StatelessWidget {
  final List<UserPass> passes;

  const UserPassCardList({super.key, required this.passes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: passes.map((pass) {
        return Card(
          color: const Color(0xFF212225),
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              pass.passName,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'PIN: ${pass.pinNumber}',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        );
      }).toList(),
    );
  }
}
