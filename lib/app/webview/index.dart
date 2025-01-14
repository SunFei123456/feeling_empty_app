import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:get/get.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({
    super.key,
    required this.url,
    this.title = '',
  });

  /// 导航到网页
  static Future<T?> navigate<T>({
    required BuildContext context,
    required String url,
    String title = '',
    bool fullscreenDialog = false,
  }) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(
          url: url,
          title: title,
        ),
        fullscreenDialog: fullscreenDialog,
      ),
    );
  }

  /// 导航到网页（替换当前路由）
  static Future<T?> navigateReplace<T>({
    required BuildContext context,
    required String url,
    String title = '',
  }) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(
          url: url,
          title: title,
        ),
      ),
    );
  }

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final _controller = Rx<WebViewController?>(null);
  final _isLoading = true.obs;
  final _loadingProgress = 0.0.obs;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            _isLoading.value = true;
            _loadingProgress.value = 0.0;
          },
          onProgress: (int progress) {
            _loadingProgress.value = progress / 100;
          },
          onPageFinished: (String url) {
            _isLoading.value = false;
            _loadingProgress.value = 1.0;
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView错误: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    _controller.value = controller;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        title: Text(widget.title,
            style: TextStyle(
                color: isDark ? Colors.white : Colors.black, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            if (await _controller.value?.canGoBack() ?? false) {
              await _controller.value?.goBack();
            } else {
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.value?.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Obx(() => _controller.value == null
              ? const Center(child: CupertinoActivityIndicator())
              : WebViewWidget(controller: _controller.value!)),
          Obx(() => _isLoading.value
              ? Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: _loadingProgress.value,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.purple.shade400,
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
