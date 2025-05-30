import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  final List<String> viewTypes;

  const ProductDetailScreen({
    super.key,
    required this.productCode,
    required this.viewType,
    required this.eventName,
    required this.viewTypes,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _tabInitialized = false;
  bool _isLoading = true;
  int _quantity = 1;
  final ValueNotifier<bool> isUSDNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    final lang = context.read<LanguageProvider>().selectedLanguageCode;
    isUSDNotifier.value = lang != 'kr';
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
    final ScrollController _scrollController = ScrollController();

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

    final isUSDValue = isUSDNotifier.value;
    final imageUrl = isUSDValue ? usd!.productImgUrl : kr!.productImgUrl;
    final name = isUSDValue ? usd!.name : kr!.name;
    final price = isUSDValue ? usd!.priceDollar : kr!.priceWon.toDouble();
    final fee = isUSDValue ? usd!.chargeDollar : kr!.chargeWon.toDouble();
    final unitPrice = isUSDValue ? usd!.totalPrice : kr!.totalPrice.toDouble();
    final unitSymbol = isUSDValue ? '\$' : '₩';
    final totalPrice = unitPrice * _quantity;
    final currencyType = isUSDValue ? 'dollar' : 'won';

    final formattedPrice = isUSDValue
        ? price.toStringAsFixed(2)
        : NumberFormat('#,###').format(price);

    final totalPriceWithoutFee = price * _quantity;
    final formattedTotalPriceWithoutFee = isUSDValue
        ? totalPriceWithoutFee.toStringAsFixed(2)
        : NumberFormat('#,###').format(totalPriceWithoutFee);

    final formattedTotalPrice = isUSDValue
        ? totalPrice.toStringAsFixed(2)
        : NumberFormat('#,###').format(totalPrice);
    final buyButtonText = lang == 'kr' ? '구매하기' : 'BUY';

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C0C),
      appBar: const Header(),
      endDrawer: const AppDrawer(),
      floatingActionButton: const BackFAB(),
      body: Stack(
        children: [
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                          TranslatedText(widget.eventName, style: const TextStyle(fontSize: 11, color: Colors.white)),
                                          const SizedBox(height: 6),
                                          Text(name, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500)),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: widget.viewTypes.map((type) {
                                              return Container(
                                                margin: const EdgeInsets.only(right: 4),
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  type,
                                                  style: const TextStyle(
                                                    color: Color(0xFF2EFFAA),
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),

                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Text(
                                                '$unitSymbol $formattedPrice',
                                                style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                                              ),
                                              const Spacer(),
                                              Container(
                                                height: 24,
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF1A1A1A),
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(color: Colors.white24),
                                                ),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    value: isUSDValue ? 'USD' : 'KRW',
                                                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                                                    dropdownColor: const Color(0xFF1A1A1A),
                                                    style: const TextStyle(color: Colors.white, fontSize: 11),
                                                    items: const [
                                                      DropdownMenuItem(value: 'KRW', child: Text('KRW')),
                                                      DropdownMenuItem(value: 'USD', child: Text('USD')),
                                                    ],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        isUSDNotifier.value = value == 'USD';
                                                      });
                                                    },
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
                              const SizedBox(height: 4),
                              const Divider(color: Colors.white10),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  RawMaterialButton(
                                    onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                                    fillColor: const Color(0xFF992BEF),
                                    shape: const CircleBorder(),
                                    constraints: const BoxConstraints.tightFor(width: 22, height: 22),
                                    child: const Icon(Icons.remove, color: Color(0xFF212225), size: 20),
                                  ),
                                  const SizedBox(width: 4),
                                  Text('$_quantity', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 4),
                                  RawMaterialButton(
                                    onPressed: () => setState(() => _quantity++),
                                    fillColor: const Color(0xFF992BEF),
                                    shape: const CircleBorder(),
                                    constraints: const BoxConstraints.tightFor(width: 22, height: 22),
                                    child: const Icon(Icons.add, color: Color(0xFF212225), size: 20),
                                  ),
                                  const Spacer(),
                                  Text('$unitSymbol $formattedTotalPriceWithoutFee', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 14),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => OrderSheetScreen(
                                              productCode: widget.productCode,
                                              viewType: widget.viewType,
                                              eventName: widget.eventName,
                                              imageUrl: imageUrl,
                                              productName: name,
                                              quantity: _quantity,
                                              formattedTotalPrice: formattedTotalPrice,
                                              totalPrice: totalPrice,
                                              price: price,
                                              fee: fee,
                                              currencyType: currencyType,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2EFFAA),
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        minimumSize: const Size(0, 28),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: Text(buyButtonText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TranslatedText(
                                      '* 해당 상품은 1장당 ${isUSDValue ? '\$${fee.toStringAsFixed(2)}' : '₩${NumberFormat('#,###').format(fee)}'}의 판매수수료가 부과됩니다.',
                                      style: const TextStyle(color: Colors.white70, fontSize: 10),
                                    ),
                                    const SizedBox(height: 6),
                                    const TranslatedText('영상 예시 화면 확인하기', style: TextStyle(color: Color(0xFF2EFFAA), fontSize: 10)),
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
                  ],
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: const [
                ProductDetailInfoTab(),
                ProductDetailNoteTab(),
                ProductDetailFAQTab(),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            right: 16,
            child: GestureDetector(
              onTap: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: SvgPicture.asset(
                'assets/svg/scroll_top.svg',
                width: 80,
                height: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
