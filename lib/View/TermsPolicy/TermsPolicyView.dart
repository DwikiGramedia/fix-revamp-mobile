import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:revamp_eperpus_mobile/Utils/Style.dart';
import 'package:revamp_eperpus_mobile/View/CustomWidget/button.dart';
import 'package:revamp_eperpus_mobile/View/SignIn/signin_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports

class TemsAndPolicyView extends StatefulWidget {
  String locale;
  TemsAndPolicyView({Key? key, required this.locale}) : super(key: key);

  @override
  State<TemsAndPolicyView> createState() => _TermsAndPolicyViewState();
}

class _TermsAndPolicyViewState extends State<TemsAndPolicyView> {
  bool isAgree = false;
  bool showTerm = false;
  String locale = "id";
  final linkUrl = "";
  late WebViewController _controller;
  late WebViewController _termsController;

  String getUrl() {
    return showTerm
        ? "https://new-portal.gramedia.com/interface/eperpus/${widget.locale}/tnc/"
        : "https://new-portal.gramedia.com/interface/eperpus/${widget.locale}/privacy/";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // #docregion platform_features
    //webView();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params);
    _termsController = WebViewController.fromPlatformCreationParams(params);
    webTerms();
  }

  Future<void> webTerms() async {
    _termsController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(
          "https://new-portal.gramedia.com/interface/eperpus/${widget.locale}/tnc/"));

    // #docregion platform_features
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Platform.isIOS ? Colors.white : Colors.transparent,
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: WebViewWidget(controller: _termsController),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: isAgree,
                        onChanged: (value) {
                          setState(() {
                            isAgree = value!;
                          });
                        }),
                    SizedBox(
                      width: size.width * 0.8,
                      child: Text(
                        AppLocalizations.of(context)!.informationPrivacy,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Button(
                  title: AppLocalizations.of(context)!.understand,
                  onTap: isAgree
                      ? () async {
                          if (isAgree) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              SignInUIForm.routeName,
                              (route) => false,
                            );
                          } else {
                            setState(() {
                              isAgree = false;
                            });
                          }
                        }
                      : () {},
                  radius: 12,
                  style: h5Title,
                  color: isAgree ? Colors.green : Colors.grey,
                ),
                const SizedBox(
                  height: 48,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
