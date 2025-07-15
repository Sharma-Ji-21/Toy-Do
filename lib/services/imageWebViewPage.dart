import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ImageWebViewPage extends StatelessWidget {
  final String url;
  const ImageWebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.white, title: const Text('Toys Link')),
      body: WebViewWidget(controller: controller),
    );
  }
}
