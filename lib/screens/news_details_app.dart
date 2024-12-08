import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:mzn_news/consts/vars.dart';
import 'package:mzn_news/providers/news_provider.dart';
import 'package:mzn_news/screens/news_details_webview.dart';
import 'package:mzn_news/services/global_methods.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class NewsDetailsApp extends StatefulWidget {
  static const routeName = "/NewsDetailsApp";
  const NewsDetailsApp({super.key});

  @override
  State<NewsDetailsApp> createState() => _NewsDetailsAppState();
}

class _NewsDetailsAppState extends State<NewsDetailsApp> {
  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final publishedAt = ModalRoute.of(context)!.settings.arguments as String;
    final currentNews = newsProvider.findByDate(publishedAt: publishedAt);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          currentNews.sourceName,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left_2),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentNews.title,
                  style: largeTitle,
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  currentNews.publishedDate,
                  style: smallPara,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: FancyShimmerImage(
                    imageUrl: currentNews.urlToImage,
                    boxFit: BoxFit.fill,
                    errorWidget: Image.asset('assets/images/empty_image.png'),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 10,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      NewsAppBtn(
                        icon: Icons.public,
                        function: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: NewsDetailsWebview(url: currentNews.url),
                              type: PageTransitionType.rightToLeft,
                              inheritTheme: true,
                              ctx: context,
                            ),
                          );
                        },
                      ),
                      NewsAppBtn(
                        icon: Icons.share,
                        function: () async {
                          try {
                            await Share.share(
                              currentNews.url,
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
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: smallTitle,
                ),
                Text(
                  currentNews.description,
                  style: smallPara,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Content',
                  style: smallTitle,
                ),
                Text(
                  currentNews.content,
                  style: smallPara,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NewsAppBtn extends StatelessWidget {
  const NewsAppBtn({
    required this.icon,
    required this.function,
    super.key,
  });

  final IconData icon;
  final GestureTapCallback function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Card(
        elevation: 10,
        shape: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: 28,
          ),
        ),
      ),
    );
  }
}
