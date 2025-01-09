import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomReportPage extends StatefulWidget {
  const CustomReportPage({super.key});

  @override
  State<CustomReportPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<CustomReportPage> {
  late WebViewController controller;
  late WebViewController bgController; // Background controller
  final String url = 'https://khatasystem.com/Login/Index';
  bool isFormSubmitted = false; // Flag to check if the form has been submitted
  bool isLoading = true; // Flag to show/hide loading animation

  @override
  void initState() {
    super.initState();

    final credBox = Hive.box('hiddenBox');
    final id = credBox.get('id');
    final username = credBox.get('username');
    final password = credBox.get('password');


    print(id);
    print(username);
    print(password);
    // Initialize the WebView controller for the main view
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // Once the login is complete and we navigate to the desired page, stop further navigation
            if (request.url == url) {
              Navigator.pop(context);
            }
            return NavigationDecision.navigate; // Allow navigation if the final page is loaded
          },
        )
      );

    // Initialize the background WebView controller
    bgController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // When a new page starts loading, show the loading animation
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            // When the page is fully loaded, hide the loading animation
            // setState(() {
            //   isLoading = false;
            // });

            // Add a delay to ensure the page is fully loaded
            await Future.delayed(const Duration(milliseconds: 500));

            // Only inject JavaScript to fill and submit the form once
            if (!isFormSubmitted) {
              // Inject JavaScript to fill the login form fields and trigger the login button click
              await bgController.runJavaScript("""
                // Fill the fields with the credentials
                document.getElementById('companyCode').value = 'k-00001';
                document.getElementById('userName').value = 'admin';
                document.getElementById('password').value = 'admin123';
                
                // Trigger the login button click event
                document.getElementById('submitButton').click();
              """);

              // Set flag to prevent further submissions
              setState(() {
                isFormSubmitted = true;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            // Once the login is complete and we navigate to the desired page, stop further navigation
            if (request.url != 'https://khatasystem.com/CustomReport/CustomReport/Index?menuName=Stock%20Summary%20Report') {
              // Prevent navigating away and load the final page
              bgController.loadRequest(Uri.parse('https://khatasystem.com/CustomReport/CustomReport/Index?menuName=Stock%20Summary%20Report'));
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate; // Allow navigation if the final page is loaded
          },
        ),
      )
      ..loadRequest(Uri.parse(url)); // Load the login page URL in the background WebView

    // Wait until the final page is loaded and display it in the main WebView
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        controller.loadRequest(Uri.parse('https://khatasystem.com/CustomReport/CustomReport/Index?menuName=Stock%20Summary%20Report'));
        isLoading= false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // WebView Widget
            WebViewWidget(controller: controller),
        
            // Loading spinner (SpinKit) displayed on top of WebView
            if (isLoading)
              Center(
                child: Image.asset('assets/gif/loading-img2.gif'),
              ),
          ],
        ),
      ),
    );
  }
}
