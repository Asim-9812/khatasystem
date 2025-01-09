import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPageView extends StatefulWidget {
  const WebPageView({super.key});

  @override
  State<WebPageView> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebPageView> {
  late WebViewController controller; // Visible WebView
  late WebViewController bgController; // Background WebView
  final String url = 'https://www.google.com/';
  bool isSubmitted = false;  // Flag to check if form is submitted

  @override
  void initState() {
    super.initState();

    // Initialize the main WebView controller (visible)
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    // Initialize the background WebView controller (hidden)
    bgController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            // Once the background page is loaded, perform the search
            if (!isSubmitted) {
              // Inject JavaScript to set the search query and submit the form
              await bgController.runJavaScript("""
                var searchBox = document.querySelector('textarea[name="q"]');
                if (searchBox && !searchBox.value) {
                  searchBox.value = 'web page project';
                  searchBox.form.submit();  // Automatically submit the form
                }
              """);

              // Set flag to prevent further submissions
              setState(() {
                isSubmitted = true;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            // Once the background WebView navigates, redirect the main WebView to show the final result
            controller.loadRequest(Uri.parse(request.url));
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(url)); // Load Google in the background WebView
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Web Page View")),
      body: WebViewWidget(controller: controller), // Main WebView to show the result
    );
  }
}
