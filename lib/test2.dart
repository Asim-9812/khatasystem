import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:khata_app/common/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomReportPage extends StatefulWidget {
  const CustomReportPage({super.key});

  @override
  State<CustomReportPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<CustomReportPage> {
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

    bgController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {

          },
          onPageFinished: (String url) async {

            // Add a delay to ensure the page is fully loaded
            await Future.delayed(const Duration(milliseconds: 500));

            // Only inject JavaScript to fill and submit the form once
            if (!isFormSubmitted) {
              // Inject JavaScript to fill the login form fields and trigger the login button click
              await bgController.runJavaScript("""
                // Fill the fields with the credentials
                document.getElementById('companyCode').value = '$id';
                document.getElementById('userName').value = '$username';
                document.getElementById('password').value = '$password';
                
                // Trigger the login button click event
                document.getElementById('submitButton').click();
              """);

              // Set flag to prevent further submissions
              setState(() {
                isFormSubmitted = true;
              });
            }



          },
          onNavigationRequest: (NavigationRequest request) async {
            // Once the login is complete and we navigate to the desired page, stop further navigation
            if (request.url.toLowerCase() == 'https://khatasystem.com/home/index') {
              print(request.url);
              bgController.loadRequest(Uri.parse('https://khatasystem.com/CustomReport/CustomReport/Index?menuName=Stock%20Summary%20Report')).whenComplete(() async {

                await Future.delayed(Duration(seconds: 3),(){
                  setState(() {
                    isLoading= false;
                  });
                });

              });
              return NavigationDecision.prevent;

            }
            else if (request.url == url) {
              Navigator.pop(context);
              bgController.clearCache();
              bgController.clearLocalStorage();
              return NavigationDecision.prevent;
            }
            else{
              return NavigationDecision.prevent;
            }


          },
        ),
      )

      ..loadRequest(Uri.parse(url)); // Load the login page URL in the background WebView



  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (val,_){
        bgController.clearCache();
        bgController.clearLocalStorage();
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // WebView Widget
              WebViewWidget(controller: bgController),

              // Loading spinner (SpinKit) displayed on top of WebView
              if (isLoading)
                Center(
                  child: Container(
                      color: ColorManager.white,
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset('assets/gif/loading-img2.gif')),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
