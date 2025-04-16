import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ticket/base_ticket_provider.dart';

class EventTicketTab extends StatelessWidget {
  const EventTicketTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tickets = context.watch<BaseTicketProvider>().tickets;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];

        return Container(
          height: 185,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF212225),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // ✅ 이미지 + 상태 뱃지 (Stack)
              Stack(
                children: [
                  Container(
                    width: 180,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      image: DecorationImage(
                        image: AssetImage(ticket.imagePath),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2EFFAA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '진행중',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // 텍스트 영역
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '목포 뮤직페스티벌',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '상품명입니다상품명입니다상품명입니다상품명입니다상품명입니다상품명입니다상품명입니다',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '₩90,000',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (ticket.type == 'STREAMING' || ticket.type == 'ALL')
                            _buildTag('LIVE'),
                          if (ticket.type == 'STREAMING' || ticket.type == 'ALL')
                            _buildTag('Re-Streaming'),
                          if (ticket.type == 'VOD' || ticket.type == 'ALL')
                            _buildTag('VOD'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // ✅ 버튼 Row로 정렬
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2EFFAA),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size(60, 30),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              elevation: 0,
                            ),
                            child: const Text(
                              '구매하기',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTag(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF171719),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF2EFFAA),
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
