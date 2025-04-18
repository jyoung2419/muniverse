import 'package:flutter/material.dart';

class VoteFilterWidget extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onChanged;

  const VoteFilterWidget({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: filters.map((filter) {
        final isSelected = selectedFilter == filter;

        return GestureDetector(
          onTap: () => onChanged(filter),
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: isSelected ? Colors.white : Color(0xFF989BA2),
                ),
                const SizedBox(width: 6),
                Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Color(0xFF989BA2),
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
