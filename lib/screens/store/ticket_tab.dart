import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/product/product_usd_provider.dart';
import '../../models/product/product_vod_usd_model.dart';
import '../../models/product/product_live_usd_model.dart';
import '../../widgets/common/translate_text.dart';

class TicketTab extends StatefulWidget {
  const TicketTab({super.key});

  @override
  State<TicketTab> createState() => _TicketTabState();
}

class _TicketTabState extends State<TicketTab> {
  String? _prevLang;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;

    if (_prevLang != lang) {
      _prevLang = lang;
      context.read<ProductUSDProvider>().fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductUSDProvider>();
    final vods = provider.vods;
    final lives = provider.lives;
    final lang = context.watch<LanguageProvider>().selectedLanguageCode;
    final buyText = lang == 'kr' ? '구매하기' : 'BUY';
    final products = [...vods, ...lives];

    if (provider.error != null) {
      return Center(
        child: TranslatedText(
          provider.error!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final isVod = product is ProductVodUSDModel;
        final imageUrl = product.productImageUrl;
        final name = product.name;
        final note = product.note;
        final price = product.totalPrice;

        return Container(
          height: 170,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF212225),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x5270737C), width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 12, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TranslatedText(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Html(
                        data: note,
                        style: {
                          'body': Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(12),
                            color: Colors.white70,
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isVod ? const Color(0xFF2EFFAA) : Colors.black,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isVod ? 'VOD' : 'LIVE',
                              style: TextStyle(
                                color: isVod ? Colors.black : const Color(0xFF2EFFAA),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              print('구매 클릭: ${product.productCode}');
                            },
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
                            child: Text(
                              buyText,
                              style: const TextStyle(
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
}
