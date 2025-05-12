import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

class VoteFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onChanged;

  const VoteFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;

    final labels = lang == 'kr'
        ? ['전체', '진행중', '진행완료', '진행예정']
        : ['ALL', 'ONGOING', 'CLOSED', 'UPCOMING'];

    return Row(
      children: labels.map((label) {
        final isSelected = selectedFilter.toLowerCase() == label.toLowerCase();

        return GestureDetector(
          onTap: () => onChanged(label.toLowerCase()),
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: isSelected ? Colors.white : const Color(0xFF989BA2),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF989BA2),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
