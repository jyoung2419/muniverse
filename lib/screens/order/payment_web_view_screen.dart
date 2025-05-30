import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String url;

  const PaymentWebViewScreen({super.key, required this.url});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _returnPageHandled = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            final url = request.url;
            debugPrint('🌐 onNavigationRequest: $url');

            if (url.startsWith('http://')) {
              final secureUrl = url.replaceFirst('http://', 'https://');
              debugPrint('🔁 리디렉션 감지: $url → $secureUrl');
              _controller.loadRequest(Uri.parse(secureUrl));
              return NavigationDecision.prevent;
            }

            if (url.startsWith('intent://')) {
              try {
                final fallbackUrl = _extractFallbackUrl(url);
                debugPrint('📦 fallback URL: $fallbackUrl');
                if (await canLaunchUrl(Uri.parse(fallbackUrl))) {
                  await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
                }
              } catch (e) {
                debugPrint('ℹ️ fallback_url 없음, 시스템 처리에 맡깁니다.');
              }
              return NavigationDecision.prevent;
            }

            if (url.startsWith('market://') || url.startsWith('kakaotalk://')) {
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              }
              return NavigationDecision.prevent;
            }

            debugPrint('✅ 이동 허용: $url');
            return NavigationDecision.navigate;
          },
          onPageStarted: (url) {
            debugPrint('📄 onPageStarted: $url');
          },
          onPageFinished: (url) {
            if (!_returnPageHandled && url.contains('/pg_return.html')) {
              _returnPageHandled = true;

              final uri = Uri.parse(url);
              final orderId = uri.queryParameters['orderNumber'];

              Future.delayed(const Duration(seconds: 5), () async {
                if (mounted) {
                  Navigator.pop(context, orderId);
                }
              });
            }
          },
          onWebResourceError: (error) {
            debugPrint('❌ Web 에러: ${error.description}');
          },
        ),
      )
      // ..addJavaScriptChannel(
      //   'MuniverseChannel',
      //   onMessageReceived: (message) {
      //     try {
      //       final data = jsonDecode(message.message);
      //       final status = data['status'];
      //       print('📩 WebView 메시지 수신: $status');
      //
      //       if (status == 'COMPLETED') {
      //         Navigator.pop(context, 'success');
      //       } else {
      //         Navigator.pop(context, 'fail');
      //       }
      //     } catch (e) {
      //       print('⚠️ 메시지 파싱 실패: $e');
      //     }
      //   },
      // )
      ..loadRequest(Uri.parse(widget.url));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _controller.runJavaScript('''
      //   (function() {
      //     const originalPostMessage = window.postMessage;
      //     window.postMessage = function(message, targetOrigin) {
      //       try {
      //         MuniverseChannel.postMessage(JSON.stringify(message));
      //       } catch (e) {
      //         console.error("postMessage hook error", e);
      //       }
      //       originalPostMessage(message, targetOrigin);
      //     };
      //   })();
      // ''');
    });
  }

  String _extractFallbackUrl(String intentUrl) {
    final fallbackKey = 'S.browser_fallback_url=';
    final start = intentUrl.indexOf(fallbackKey);
    if (start == -1) throw Exception('fallback_url 없음');

    final end = intentUrl.indexOf(';', start);
    final encodedUrl = intentUrl.substring(
      start + fallbackKey.length,
      end == -1 ? intentUrl.length : end,
    );

    return Uri.decodeComponent(encodedUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
