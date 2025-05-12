import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';

class YearFilterDropdown extends StatelessWidget {
  final int selectedYear;
  final List<int> years;
  final ValueChanged<int> onChanged;

  const YearFilterDropdown({
    super.key,
    required this.selectedYear,
    required this.years,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final suffix = lang == 'kr' ? '년' : '';

    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        value: selectedYear,
        dropdownColor: const Color(0xFF212225),
        style: const TextStyle(color: Colors.white, fontSize: 13),
        icon: const SizedBox.shrink(),
        onChanged: (int? newValue) {
          if (newValue != null) onChanged(newValue);
        },
        items: years.map((year) {
          return DropdownMenuItem<int>(
            value: year,
            child: Text('$year$suffix'),
          );
        }).toList(),
      ),
    );
  }
}
