import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mzn_news/services/global_methods.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsWebview extends StatefulWidget {
  const NewsDetailsWebview({super.key, required this.url});
  final String url;

  @override
  State<NewsDetailsWebview> createState() => _NewsDetailsWebviewState();
}

class _NewsDetailsWebviewState extends State<NewsDetailsWebview> {
  late final WebViewController controller;
  int loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(Uri.parse(widget.url))
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("SnackBar", onMessageReceived: (message) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message.message)));
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.url),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(IconlyLight.arrow_left),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  if (await controller.canGoBack()) {
                    await controller.goBack();
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Cannot go further back')),
                    );
                    return;
                  }
                },
              ),
              IconButton(
                icon: const Icon(IconlyLight.arrow_right),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  if (await controller.canGoForward()) {
                    await controller.goForward();
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(
                          content: Text('Cannot go further forward')),
                    );
                    return;
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () async {
                  await _showModalSheet();
                },
              ),
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }

  Future<void> _showModalSheet() async {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      showDragHandle: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'More Options',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(
                  height: 5,
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share'),
                  onTap: () async {
                    try {
                      await Share.share(
                        widget.url,
                        subject: 'Share this link',
                      );
                    } catch (err) {
                      if (context.mounted) {
                        GlobalMethods.errorDialog(
                          errMsg: err.toString(),
                          context: context,
                        );
                      }
                    }
                  },
                ),
                const Divider(
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.open_in_browser),
                  title: const Text('Open in Browser'),
                  onTap: () async {
                    try {
                      await launchUrl(Uri.parse(widget.url));
                    } catch (err) {
                      if (context.mounted) {
                        GlobalMethods.errorDialog(
                          errMsg: err.toString(),
                          context: context,
                        );
                      }
                    }

                    if (!await launchUrl(Uri.parse(widget.url))) {
                      throw Exception('Could not launch $widget.url');
                    }
                  },
                ),
                const Divider(
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Refresh'),
                  onTap: () async {
                    try {
                      await controller.reload();
                    } catch (err) {
                      if (context.mounted) {
                        GlobalMethods.errorDialog(
                          errMsg: err.toString(),
                          context: context,
                        );
                      }
                    } finally {
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ));
      },
    );
  }
}
