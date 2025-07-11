import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ticket/user_pass_provider.dart';
import '../../models/ticket/user_pass_model.dart' as ticket;
import '../common/translate_text.dart';

void ShowRegisterPassDialog(BuildContext context) {
  final lang = Localizations.localeOf(context).languageCode;
  final okText = lang == 'ko' ? '확인' : 'OK';
  final userPasses = context.read<UserPassProvider>().userPasses;

  String? selectedPass = userPasses.isNotEmpty ? userPasses.first.pinNumber : null;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: const Color(0xFF222222),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TranslatedText(
                        '알림',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Center(
                    child: TranslatedText(
                      '보유하신 이용권을 선택해 주세요.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 240,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          dropdownColor: const Color(0xFF222222),
                          value: selectedPass,
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          style: const TextStyle(color: Colors.white),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPass = newValue;
                            });
                          },
                          items: userPasses.map<DropdownMenuItem<String>>((ticket.UserPassModel pass) {
                            return DropdownMenuItem<String>(
                              value: pass.pinNumber,
                              child: Text(
                                pass.pinNumber,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // TODO: 선택된 selectedPass 값으로 처리
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2EFFAA),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(okText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
