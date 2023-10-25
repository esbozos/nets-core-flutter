import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewListener extends StatefulWidget {
  final FutureOr<NavigationDecision> Function(NavigationRequest request)?
      onNavigationRequest;
  final Function(String error)? onError;
  final String url;
  final bool showProgress;
  const WebViewListener(
      {super.key,
      required this.url,
      this.onNavigationRequest,
      this.onError,
      this.showProgress = false});
  @override
  State<WebViewListener> createState() => _StateWebViewListener();
}

class _StateWebViewListener extends State<WebViewListener> {
  dynamic controller;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          if (widget.showProgress) {
            setState(() {
              this.progress = (progress / 100).round() / 100;
            });
          }
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {
          if (widget.onError != null) {
            widget.onError!(error.description);
          }
        },
        onNavigationRequest: (NavigationRequest request) {
          if (widget.onNavigationRequest != null) {
            return widget.onNavigationRequest!(request);
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('build webview');

      print('controller: $controller');
    }
    if (controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Simple Example')),
      body: WebViewWidget(controller: controller),
    );
  }
}
