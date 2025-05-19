import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/product/product_detail_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/back_fab.dart';
import '../../widgets/common/header.dart';
import '../../widgets/common/translate_text.dart';
import '../order/order_sheet_screen.dart';
import 'detail/product_detail_info_tab.dart';
import 'detail/product_detail_note_tab.dart';
import 'detail/product_detail_faq_tab.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productCode;
  final String viewType;
  final String eventName;

  const ProductDetailScreen({
    super.key,
    required this.productCode,
    required this.viewType,
    required this.eventName,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _tabInitialized = false;
  bool _isLoading = true;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    await context.read<ProductDetailProvider>().fetchDetail(widget.productCode, widget.viewType);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final tabs = lang == 'kr' ? ['판매정보', '유의사항', 'FAQ'] : ['Info', 'Note', 'FAQ'];

    final provider = context.watch<ProductDetailProvider>();
    final kr = provider.krDetail;
    final usd = provider.usdDetail;

    if (_isLoading || (kr == null && usd == null)) {
      return const Scaffold(
        backgroundColor: Color(0xFF0B0C0C),
        appBar: Header(),
        endDrawer: AppDrawer(),
        floatingActionButton: BackFAB(),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF2EFFAA))),
      );
    }

    if (!_tabInitialized) {
      _tabController = TabController(length: 3, vsync: this);
      _tabInitialized = true;
    }

    final isUSD = usd != null;
    final imageUrl = isUSD ? usd!.productImgUrl : kr!.productImgUrl;
    final name = isUSD ? usd!.name : kr!.name;
    final price = isUSD ? usd.priceDollar : kr!.priceWon.toDouble();
    final fee = isUSD ? usd.chargeDollar : kr!.chargeWon.toDouble();
    final unitPrice = isUSD ? usd.totalPrice : kr!.totalPrice.toDouble();
    final totalPrice = unitPrice * _quantity;

    final unitSymbol = isUSD ? '\$' : '₩';
    final formattedUnitPrice = isUSD
        ? unitPrice.toStringAsFixed(2)
        : NumberFormat('#,###').format(unitPrice);
    final formattedTotalPrice = isUSD
        ? totalPrice.toStringAsFixed(2)
        : NumberFormat('#,###').format(totalPrice);
    final buyButtonText = lang == 'kr' ? '구매하기' : 'BUY';

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF212225),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이미지 + 텍스트 Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 180,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TranslatedText(widget.eventName,
                                    style: const TextStyle(fontSize: 11, color: Colors.white)),
                                const SizedBox(height: 6),
                                Text(name,
                                    style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: widget.viewType == 'VOD' ? Colors.black : const Color(0xFF2EFFAA),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    widget.viewType,
                                    style: TextStyle(
                                      color: widget.viewType == 'VOD' ? const Color(0xFF2EFFAA) : Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Row(
                                    children: [
                                      Text(
                                        '$unitSymbol $formattedUnitPrice',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      // Row(
                                      //   children: [
                                      //     Container(
                                      //       width: 16,
                                      //       height: 16,
                                      //       decoration: BoxDecoration(
                                      //         border: Border.all(color: Color(0xFF992BEF), width: 1.5),
                                      //         borderRadius: BorderRadius.circular(4),
                                      //       ),
                                      //       child: const Icon(
                                      //         Icons.keyboard_arrow_down,
                                      //         size: 14,
                                      //         color: Color(0xFF992BEF),
                                      //       ),
                                      //     ),
                                      //     const SizedBox(width: 6),
                                      //     const Text(
                                      //       'USD',
                                      //       style: TextStyle(
                                      //         color: Colors.white,
                                      //         fontSize: 14,
                                      //         fontWeight: FontWeight.w500,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        RawMaterialButton(
                          onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                          fillColor: Color(0xFF992BEF),
                          shape: const CircleBorder(),
                          constraints: const BoxConstraints.tightFor(width: 22, height: 22),
                          child: const Icon(Icons.remove, color: Color(0xFF212225), size: 20),
                        ),
                        const SizedBox(width: 4),
                        Text('$_quantity', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(width: 4),
                        RawMaterialButton(
                          onPressed: () => setState(() => _quantity++),
                          fillColor: Color(0xFF992BEF),
                          shape: const CircleBorder(),
                          constraints: const BoxConstraints.tightFor(width: 22, height: 22),
                          child: const Icon(Icons.add, color: Color(0xFF212225), size: 20),
                        ),
                        const Spacer(),
                        Text(
                          '$unitSymbol $formattedTotalPrice',
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 14),
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderSheetScreen(
                                    eventName: widget.eventName,
                                    imageUrl: imageUrl,
                                    productName: name,
                                    quantity: _quantity,
                                    formattedTotalPrice: formattedTotalPrice,
                                    totalPrice: totalPrice,
                                    price: price,
                                    fee: fee,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2EFFAA),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), // 높이 줄임
                              minimumSize: const Size(0, 28),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              buyButtonText,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 4),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TranslatedText(
                            '* 해당 상품은 1장당 1400원의 판매수수료가 부과됩니다.',
                            style: TextStyle(color: Colors.white70, fontSize: 10),
                          ),
                          SizedBox(height: 6),
                          TranslatedText(
                            '영상 예시 화면 확인하기',
                            style: TextStyle(color: Color(0xFF2EFFAA), fontSize: 10),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF2EFFAA),
                unselectedLabelColor: Colors.white60,
                indicatorColor: const Color(0xFF2EFFAA),
                tabs: tabs.map((label) => Tab(text: label)).toList(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: TabBarView(
                controller: _tabController,
                children: const [
                  ProductDetailInfoTab(),
                  ProductDetailNoteTab(),
                  ProductDetailFAQTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
