import 'package:flutter/material.dart';

class RoundSelector extends StatelessWidget {
  final List<String> rounds;
  final String selectedRound;
  final ValueChanged<String> onChanged;

  const RoundSelector({
    super.key,
    required this.rounds,
    required this.selectedRound,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: rounds.map((round) {
        final isSelected = selectedRound == round;
        return Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,       // ✅ 터치 물결 제거
            highlightColor: Colors.transparent,    // ✅ 터치 하이라이트 제거
            hoverColor: Colors.transparent,        // ✅ 마우스 hover 효과 제거 (웹 대응)
          ),
          child: RawChip(
            label: SizedBox(
              width: 30,
              height: 18,
              child: Center(
                child: Text(
                  round,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            backgroundColor: const Color(0xFF111111),
            selectedColor: const Color(0xFF3670C1),
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            selected: isSelected,
            showCheckmark: false,
            onSelected: (_) => onChanged(round),
            side: const BorderSide(
              color: Color(0xFF6D7582),
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        );
      }).toList(),
    );
  }
}
